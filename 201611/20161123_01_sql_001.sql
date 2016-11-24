-- 初始化
begin; 
CREATE EXTENSION IF NOT EXISTS pg_stat_statements; 

create schema IF NOT EXISTS __pg_stats__; 
set search_path=__pg_stats__,public,pg_catalog; 

-- 全局, pg_db_role_setting  
create table IF NOT EXISTS snap_pg_db_role_setting as select 1::int8 snap_id, now() snap_ts, * from pg_db_role_setting; 

-- 全局, 表空间占用  
create table IF NOT EXISTS snap_pg_tbs_size as select 1::int8 snap_id, now() snap_ts, spcname, pg_tablespace_location(oid), pg_size_pretty(pg_tablespace_size(oid)) from pg_tablespace order by pg_tablespace_size(oid) desc;  

-- 全局, 数据库空间占用  
create table IF NOT EXISTS snap_pg_db_size as select 1::int8 snap_id, now() snap_ts, datname, pg_size_pretty(pg_database_size(oid)) from pg_database order by pg_database_size(oid) desc;  

-- 全局, 当前活跃度  
create table IF NOT EXISTS snap_pg_stat_activity as select 1::int8 snap_id, now() snap_ts, state, count(*) from pg_stat_activity group by 1,2,3;  

-- 全局, 总剩余连接数  
create table IF NOT EXISTS snap_pg_conn_stats as select 1::int8 snap_id, now() snap_ts, max_conn,used,res_for_super,max_conn-used-res_for_super res_for_normal from (select count(*) used from pg_stat_activity) t1,(select setting::int res_for_super from pg_settings where name=$$superuser_reserved_connections$$) t2,(select setting::int max_conn from pg_settings where name=$$max_connections$$) t3; 

-- 全局, 用户连接数限制  
create table IF NOT EXISTS snap_pg_role_conn_limit as select 1::int8 snap_id, now() snap_ts, a.rolname,a.rolconnlimit,b.connects from pg_authid a,(select usename,count(*) connects from pg_stat_activity group by usename) b where a.rolname=b.usename order by b.connects desc;  

-- 全局, 数据库连接限制  
create table IF NOT EXISTS snap_pg_db_conn_limit as select 1::int8 snap_id, now() snap_ts, a.datname, a.datconnlimit, b.connects from pg_database a,(select datname,count(*) connects from pg_stat_activity group by datname) b where a.datname=b.datname order by b.connects desc;  

-- 全局, TOP CPUTIME 10 SQL
create table IF NOT EXISTS snap_pg_cputime_topsql as select 1::int8 snap_id, now() snap_ts, c.rolname,b.datname,a.total_time/a.calls per_call_time,a.* from pg_stat_statements a,pg_database b,pg_authid c where a.userid=c.oid and a.dbid=b.oid order by a.total_time desc limit 10;  

-- 全局, 数据库统计信息, 回滚比例, 命中比例, 数据块读写时间, 死锁, 复制冲突
create table IF NOT EXISTS snap_pg_stat_database as select 1::int8 snap_id, now() snap_ts, datname,round(100*(xact_rollback::numeric/(case when xact_commit > 0 then xact_commit else 1 end + xact_rollback)),2)||$$ %$$ rollback_ratio, round(100*(blks_hit::numeric/(case when blks_read>0 then blks_read else 1 end + blks_hit)),2)||$$ %$$ hit_ratio, blk_read_time, blk_write_time, conflicts, deadlocks from pg_stat_database; 

-- 全局, 检查点, bgwriter 统计信息
create table IF NOT EXISTS snap_pg_stat_bgwriter as select 1::int8 snap_id, now() snap_ts,  * from pg_stat_bgwriter; 

-- 全局, archiver 统计信息
create table IF NOT EXISTS snap_pg_stat_archiver as select 1::int8 snap_id, now() snap_ts,coalesce(pg_xlogfile_name(pg_current_xlog_insert_location()),'-') as now_insert_xlog_file,  * from pg_stat_archiver; 

-- 全局, 数据库年龄
create table IF NOT EXISTS snap_pg_database_age as select 1::int8 snap_id, now() snap_ts, datname,age(datfrozenxid),2^31-age(datfrozenxid) age_remain from pg_database order by age(datfrozenxid) desc;

-- 全局, 长事务, 2PC 
create table IF NOT EXISTS snap_pg_long_xact as select 1::int8 snap_id, now() snap_ts, datname,usename,query,xact_start,now()-xact_start xact_duration,query_start,now()-query_start query_duration,state from pg_stat_activity where state<>$$idle$$ and (backend_xid is not null or backend_xmin is not null) and now()-xact_start > interval $$30 min$$ order by xact_start;

create table IF NOT EXISTS snap_pg_long_2pc as select 1::int8 snap_id, now() snap_ts, name,statement,prepare_time,now()-prepare_time duration,parameter_types,from_sql from pg_prepared_statements where now()-prepare_time > interval $$30 min$$ order by prepare_time;

-- 全局, 用户密码到期时间
create table IF NOT EXISTS snap_pg_user_deadline as select 1::int8 snap_id, now() snap_ts, rolname,rolvaliduntil from pg_authid order by rolvaliduntil;


-- 库级, 快照清单
create table IF NOT EXISTS snap_list (id serial8 primary key, snap_ts timestamp, snap_level text);  
insert into snap_list (snap_ts, snap_level) values (now(), 'database'); 

-- 库级, pg_stat_statements  
create table IF NOT EXISTS snap_pg_stat_statements as select 1::int8 snap_id, now() snap_ts, * from pg_stat_statements; 

-- 库级, 对象空间占用柱状图  
create table IF NOT EXISTS snap_pg_rel_space_bucket as select 1::int8 snap_id, now() snap_ts, current_database(), buk this_buk_no, cnt rels_in_this_buk, pg_size_pretty(min) buk_min, pg_size_pretty(max) buk_max from 
( 
 select row_number() over (partition by buk order by tsize), tsize, buk, min(tsize) over (partition by buk),max(tsize) over (partition by buk), count(*) over (partition by buk) cnt from 
 ( 
   select pg_relation_size(a.oid) tsize, width_bucket(pg_relation_size(a.oid),tmin-1,tmax+1,10) buk from 
   ( 
     select min(pg_relation_size(a.oid)) tmin, max(pg_relation_size(a.oid)) tmax from pg_class a, pg_namespace c where a.relnamespace=c.oid and nspname !~ $$^pg_$$ and nspname<>$$information_schema$$ 
   ) t, pg_class a, pg_namespace c where a.relnamespace=c.oid and nspname !~ $$^pg_$$ and nspname<>$$information_schema$$ 
 ) t 
) t where row_number=1;  

-- 库级, 数据库对象空间前5000  
create table IF NOT EXISTS snap_pg_db_rel_size as select 1::int8 snap_id, now() snap_ts, current_database(),b.nspname,c.relname,c.relkind,pg_relation_size(c.oid),a.seq_scan,a.seq_tup_read,a.idx_scan,a.idx_tup_fetch,a.n_tup_ins,a.n_tup_upd,a.n_tup_del,a.n_tup_hot_upd,a.n_live_tup,a.n_dead_tup from pg_stat_all_tables a, pg_class c,pg_namespace b where c.relnamespace=b.oid and c.relkind=$$r$$ and a.relid=c.oid order by pg_relation_size(c.oid) desc limit 5000;  

-- 库级, pg_statio_all_tables  
create table IF NOT EXISTS snap_pg_statio_all_tables as select 1::int8 snap_id, now() snap_ts, current_database(),* from pg_statio_all_tables;  

-- 库级, pg_statio_all_indexes  
create table IF NOT EXISTS snap_pg_statio_all_indexes as select 1::int8 snap_id, now() snap_ts, current_database(),* from pg_statio_all_indexes;  

-- 库级, 索引数超过4并且SIZE大于10MB的表
create table IF NOT EXISTS snap_pg_many_indexes_rel as select 1::int8 snap_id, now() snap_ts, current_database(), t2.nspname, t1.relname, pg_relation_size(t1.oid), t3.idx_cnt from pg_class t1, pg_namespace t2, (select indrelid,count(*) idx_cnt from pg_index group by 1 having count(*)>4) t3 where t1.oid=t3.indrelid and t1.relnamespace=t2.oid and pg_relation_size(t1.oid)/1024/1024.0>10 order by t3.idx_cnt desc; 

-- 库级, 上次巡检以来未使用，或者使用较少的索引
create table IF NOT EXISTS snap_pg_notused_indexes as select 1::int8 snap_id, now() snap_ts, current_database(),t2.schemaname,t2.relname,t2.indexrelname,t2.idx_scan,t2.idx_tup_read,t2.idx_tup_fetch,pg_relation_size(indexrelid) from pg_stat_all_tables t1,pg_stat_all_indexes t2 where t1.relid=t2.relid and t2.idx_scan<10 and t2.schemaname not in ($$pg_toast$$,$$pg_catalog$$) and indexrelid not in (select conindid from pg_constraint where contype in ($$p$$,$$u$$,$$f$$)) and pg_relation_size(indexrelid)>65536 order by pg_relation_size(indexrelid) desc; 

-- 库级, 表膨胀前10
create table IF NOT EXISTS snap_pg_table_bloat as select 1::int8 snap_id, now() snap_ts, 
  current_database() AS db, schemaname, tablename, reltuples::bigint AS tups, relpages::bigint AS pages, otta,
  ROUND(CASE WHEN otta=0 OR sml.relpages=0 OR sml.relpages=otta THEN 0.0 ELSE sml.relpages/otta::numeric END,1) AS tbloat,
  CASE WHEN relpages < otta THEN 0 ELSE relpages::bigint - otta END AS wastedpages,
  CASE WHEN relpages < otta THEN 0 ELSE bs*(sml.relpages-otta)::bigint END AS wastedbytes,
  CASE WHEN relpages < otta THEN $$0 bytes$$::text ELSE (bs*(relpages-otta))::bigint || $$ bytes$$ END AS wastedsize,
  iname, ituples::bigint AS itups, ipages::bigint AS ipages, iotta,
  ROUND(CASE WHEN iotta=0 OR ipages=0 OR ipages=iotta THEN 0.0 ELSE ipages/iotta::numeric END,1) AS ibloat,
  CASE WHEN ipages < iotta THEN 0 ELSE ipages::bigint - iotta END AS wastedipages,
  CASE WHEN ipages < iotta THEN 0 ELSE bs*(ipages-iotta) END AS wastedibytes,
  CASE WHEN ipages < iotta THEN $$0 bytes$$ ELSE (bs*(ipages-iotta))::bigint || $$ bytes$$ END AS wastedisize,
  CASE WHEN relpages < otta THEN
    CASE WHEN ipages < iotta THEN 0 ELSE bs*(ipages-iotta::bigint) END
    ELSE CASE WHEN ipages < iotta THEN bs*(relpages-otta::bigint)
      ELSE bs*(relpages-otta::bigint + ipages-iotta::bigint) END
  END AS totalwastedbytes
FROM (
  SELECT
    nn.nspname AS schemaname,
    cc.relname AS tablename,
    COALESCE(cc.reltuples,0) AS reltuples,
    COALESCE(cc.relpages,0) AS relpages,
    COALESCE(bs,0) AS bs,
    COALESCE(CEIL((cc.reltuples*((datahdr+ma-
      (CASE WHEN datahdr%ma=0 THEN ma ELSE datahdr%ma END))+nullhdr2+4))/(bs-20::float)),0) AS otta,
    COALESCE(c2.relname,$$?$$) AS iname, COALESCE(c2.reltuples,0) AS ituples, COALESCE(c2.relpages,0) AS ipages,
    COALESCE(CEIL((c2.reltuples*(datahdr-12))/(bs-20::float)),0) AS iotta -- very rough approximation, assumes all cols
  FROM
     pg_class cc
  JOIN pg_namespace nn ON cc.relnamespace = nn.oid AND nn.nspname <> $$information_schema$$
  LEFT JOIN
  (
    SELECT
      ma,bs,foo.nspname,foo.relname,
      (datawidth+(hdr+ma-(case when hdr%ma=0 THEN ma ELSE hdr%ma END)))::numeric AS datahdr,
      (maxfracsum*(nullhdr+ma-(case when nullhdr%ma=0 THEN ma ELSE nullhdr%ma END))) AS nullhdr2
    FROM (
      SELECT
        ns.nspname, tbl.relname, hdr, ma, bs,
        SUM((1-coalesce(null_frac,0))*coalesce(avg_width, 2048)) AS datawidth,
        MAX(coalesce(null_frac,0)) AS maxfracsum,
        hdr+(
          SELECT 1+count(*)/8
          FROM pg_stats s2
          WHERE null_frac<>0 AND s2.schemaname = ns.nspname AND s2.tablename = tbl.relname
        ) AS nullhdr
      FROM pg_attribute att 
      JOIN pg_class tbl ON att.attrelid = tbl.oid
      JOIN pg_namespace ns ON ns.oid = tbl.relnamespace 
      LEFT JOIN pg_stats s ON s.schemaname=ns.nspname
      AND s.tablename = tbl.relname
      AND s.inherited=false
      AND s.attname=att.attname,
      (
        SELECT
          (SELECT current_setting($$block_size$$)::numeric) AS bs,
            CASE WHEN SUBSTRING(SPLIT_PART(v, $$ $$, 2) FROM $$#"[0-9]+.[0-9]+#"%$$ for $$#$$)
              IN ($$8.0$$,$$8.1$$,$$8.2$$) THEN 27 ELSE 23 END AS hdr,
          CASE WHEN v ~ $$mingw32$$ OR v ~ $$64-bit$$ THEN 8 ELSE 4 END AS ma
        FROM (SELECT version() AS v) AS foo
      ) AS constants
      WHERE att.attnum > 0 AND tbl.relkind=$$r$$
      GROUP BY 1,2,3,4,5
    ) AS foo
  ) AS rs
  ON cc.relname = rs.relname AND nn.nspname = rs.nspname
  LEFT JOIN pg_index i ON indrelid = cc.oid
  LEFT JOIN pg_class c2 ON c2.oid = i.indexrelid
) AS sml order by wastedbytes desc limit 10;

-- 库级, 索引膨胀前10
create table IF NOT EXISTS snap_pg_index_bloat as select 1::int8 snap_id, now() snap_ts, 
  current_database() AS db, schemaname, tablename, reltuples::bigint AS tups, relpages::bigint AS pages, otta,
  ROUND(CASE WHEN otta=0 OR sml.relpages=0 OR sml.relpages=otta THEN 0.0 ELSE sml.relpages/otta::numeric END,1) AS tbloat,
  CASE WHEN relpages < otta THEN 0 ELSE relpages::bigint - otta END AS wastedpages,
  CASE WHEN relpages < otta THEN 0 ELSE bs*(sml.relpages-otta)::bigint END AS wastedbytes,
  CASE WHEN relpages < otta THEN $$0 bytes$$::text ELSE (bs*(relpages-otta))::bigint || $$ bytes$$ END AS wastedsize,
  iname, ituples::bigint AS itups, ipages::bigint AS ipages, iotta,
  ROUND(CASE WHEN iotta=0 OR ipages=0 OR ipages=iotta THEN 0.0 ELSE ipages/iotta::numeric END,1) AS ibloat,
  CASE WHEN ipages < iotta THEN 0 ELSE ipages::bigint - iotta END AS wastedipages,
  CASE WHEN ipages < iotta THEN 0 ELSE bs*(ipages-iotta) END AS wastedibytes,
  CASE WHEN ipages < iotta THEN $$0 bytes$$ ELSE (bs*(ipages-iotta))::bigint || $$ bytes$$ END AS wastedisize,
  CASE WHEN relpages < otta THEN
    CASE WHEN ipages < iotta THEN 0 ELSE bs*(ipages-iotta::bigint) END
    ELSE CASE WHEN ipages < iotta THEN bs*(relpages-otta::bigint)
      ELSE bs*(relpages-otta::bigint + ipages-iotta::bigint) END
  END AS totalwastedbytes
FROM (
  SELECT
    nn.nspname AS schemaname,
    cc.relname AS tablename,
    COALESCE(cc.reltuples,0) AS reltuples,
    COALESCE(cc.relpages,0) AS relpages,
    COALESCE(bs,0) AS bs,
    COALESCE(CEIL((cc.reltuples*((datahdr+ma-
      (CASE WHEN datahdr%ma=0 THEN ma ELSE datahdr%ma END))+nullhdr2+4))/(bs-20::float)),0) AS otta,
    COALESCE(c2.relname,$$?$$) AS iname, COALESCE(c2.reltuples,0) AS ituples, COALESCE(c2.relpages,0) AS ipages,
    COALESCE(CEIL((c2.reltuples*(datahdr-12))/(bs-20::float)),0) AS iotta -- very rough approximation, assumes all cols
  FROM
     pg_class cc
  JOIN pg_namespace nn ON cc.relnamespace = nn.oid AND nn.nspname <> $$information_schema$$
  LEFT JOIN
  (
    SELECT
      ma,bs,foo.nspname,foo.relname,
      (datawidth+(hdr+ma-(case when hdr%ma=0 THEN ma ELSE hdr%ma END)))::numeric AS datahdr,
      (maxfracsum*(nullhdr+ma-(case when nullhdr%ma=0 THEN ma ELSE nullhdr%ma END))) AS nullhdr2
    FROM (
      SELECT
        ns.nspname, tbl.relname, hdr, ma, bs,
        SUM((1-coalesce(null_frac,0))*coalesce(avg_width, 2048)) AS datawidth,
        MAX(coalesce(null_frac,0)) AS maxfracsum,
        hdr+(
          SELECT 1+count(*)/8
          FROM pg_stats s2
          WHERE null_frac<>0 AND s2.schemaname = ns.nspname AND s2.tablename = tbl.relname
        ) AS nullhdr
      FROM pg_attribute att 
      JOIN pg_class tbl ON att.attrelid = tbl.oid
      JOIN pg_namespace ns ON ns.oid = tbl.relnamespace 
      LEFT JOIN pg_stats s ON s.schemaname=ns.nspname
      AND s.tablename = tbl.relname
      AND s.inherited=false
      AND s.attname=att.attname,
      (
        SELECT
          (SELECT current_setting($$block_size$$)::numeric) AS bs,
            CASE WHEN SUBSTRING(SPLIT_PART(v, $$ $$, 2) FROM $$#"[0-9]+.[0-9]+#"%$$ for $$#$$)
              IN ($$8.0$$,$$8.1$$,$$8.2$$) THEN 27 ELSE 23 END AS hdr,
          CASE WHEN v ~ $$mingw32$$ OR v ~ $$64-bit$$ THEN 8 ELSE 4 END AS ma
        FROM (SELECT version() AS v) AS foo
      ) AS constants
      WHERE att.attnum > 0 AND tbl.relkind=$$r$$
      GROUP BY 1,2,3,4,5
    ) AS foo
  ) AS rs
  ON cc.relname = rs.relname AND nn.nspname = rs.nspname
  LEFT JOIN pg_index i ON indrelid = cc.oid
  LEFT JOIN pg_class c2 ON c2.oid = i.indexrelid
) AS sml order by wastedibytes desc limit 10;

-- 库级, 垃圾数据前十  
create table IF NOT EXISTS snap_pg_dead_tup as select 1::int8 snap_id, now() snap_ts, current_database(),schemaname,relname,n_dead_tup from pg_stat_all_tables where n_live_tup>0 and n_dead_tup/n_live_tup>0.2 and schemaname not in ($$pg_toast$$,$$pg_catalog$$) order by n_dead_tup desc limit 10;

-- 库级, 表年龄前100
create table IF NOT EXISTS snap_pg_rel_age as select 1::int8 snap_id, now() snap_ts, current_database(),rolname,nspname,relkind,relname,age(relfrozenxid),2^31-age(relfrozenxid) age_remain from pg_authid t1 join pg_class t2 on t1.oid=t2.relowner join pg_namespace t3 on t2.relnamespace=t3.oid where t2.relkind in ($$t$$,$$r$$) order by age(relfrozenxid) desc limit 100;


-- 库级, unlogged table 和 哈希索引
create table IF NOT EXISTS snap_pg_unlogged_table as select 1::int8 snap_id, now() snap_ts, current_database(),t3.rolname,t2.nspname,t1.relname from pg_class t1,pg_namespace t2,pg_authid t3 where t1.relnamespace=t2.oid and t1.relowner=t3.oid and t1.relpersistence=$$u$$;

create table IF NOT EXISTS snap_pg_hash_idx as select 1::int8 snap_id, now() snap_ts, current_database(),pg_get_indexdef(oid) from pg_class where relkind=$$i$$ and pg_get_indexdef(oid) ~ $$USING hash$$;

-- 库级, 剩余可使用次数不足1000万次的序列检查
create or replace function f(OUT v_datname name, OUT v_role name, OUT v_nspname name, OUT v_relname name, OUT v_times_remain int8) returns setof record as $$
declare
begin
  v_datname := current_database();
  for v_role,v_nspname,v_relname in select rolname,nspname,relname from pg_authid t1 , pg_class t2 , pg_namespace t3 where t1.oid=t2.relowner and t2.relnamespace=t3.oid and t2.relkind='S' 
  LOOP
    execute 'select (max_value-last_value)/increment_by from "'||v_nspname||'"."'||v_relname||'" where not is_cycled' into v_times_remain;
    return next;
  end loop;
end;
$$ language plpgsql;

create table IF NOT EXISTS snap_pg_seq_deadline as select 1::int8 snap_id, now() snap_ts, * from f() where v_times_remain is not null and v_times_remain < 10240000 order by v_times_remain limit 10;

-- 库级, 清理未引用的大对象 
create table IF NOT EXISTS snap_pg_vacuumlo as select 1::int8 snap_id, now() snap_ts, current_database(), 1::int8 as lo_bloat;

create or replace function vacuumlo(i_snapid int8) returns void as $$
declare
  los oid[];
  lo oid;
  v_nspname name;
  v_relname name;
  v_attname name;
  v_bloat int8;
begin
  SELECT array_agg(oid) into los FROM pg_largeobject_metadata;

  if los is not null and array_length(los,1) > 0 then
    for v_nspname,v_relname,v_attname in 
      SELECT s.nspname, c.relname, a.attname 
      FROM pg_class c, pg_attribute a, pg_namespace s, pg_type t 
      WHERE a.attnum > 0 AND NOT a.attisdropped 
        AND a.attrelid = c.oid 
        AND a.atttypid = t.oid 
        AND c.relnamespace = s.oid 
        AND t.typname in ('oid', 'lo') 
        AND c.relkind in ('r', 'm') 
        AND s.nspname !~ '^pg_'
    loop 
      for lo in execute format('SELECT %I FROM %I.%I', quote_ident(v_attname), quote_ident(v_nspname), quote_ident(v_relname)) loop
        los := array_remove(los, lo);
      end loop;
    end loop;
  end if;

  if los is not null and array_length(los,1) > 0 then
    select sum(current_setting('block_size')::int8) into v_bloat from pg_largeobject where loid = any(los);
    
    insert into snap_pg_vacuumlo select i_snapid, now() snap_ts, current_database(), v_bloat;
    raise notice 'lo bloats: %', pg_size_pretty(v_bloat);
    
    raise notice 'begin vacuumlo. %', clock_timestamp();
    perform lo_unlink(o) from unnest(los) t(o);
    raise notice 'end vacuumlo. %', clock_timestamp();
  end if;
end;
$$ language plpgsql strict;

-- 库级, 锁等待
create table IF NOT EXISTS snap_pg_waiting as 
with t_wait as                     
(select a.mode,a.locktype,a.database,a.relation,a.page,a.tuple,a.classid,
a.objid,a.objsubid,a.pid,a.virtualtransaction,a.virtualxid,a,
transactionid,b.query,b.xact_start,b.query_start,b.usename,b.datname 
  from pg_locks a,pg_stat_activity b where a.pid=b.pid and not a.granted),
t_run as 
(select a.mode,a.locktype,a.database,a.relation,a.page,a.tuple,
a.classid,a.objid,a.objsubid,a.pid,a.virtualtransaction,a.virtualxid,
a,transactionid,b.query,b.xact_start,b.query_start,
b.usename,b.datname from pg_locks a,pg_stat_activity b where 
a.pid=b.pid and a.granted) 
select 
1::int8 snap_id, now() snap_ts, 
r.locktype, r.mode r_mode,r.usename r_user,r.datname r_db,
r.relation::regclass,r.pid r_pid,
r.page r_page,r.tuple r_tuple,r.xact_start r_xact_start,
r.query_start r_query_start,
now()-r.query_start r_locktime,r.query r_query,w.mode w_mode,
w.pid w_pid,w.page w_page,
w.tuple w_tuple,w.xact_start w_xact_start,w.query_start w_query_start,
now()-w.query_start w_locktime,w.query w_query  
from t_wait w,t_run r where
  r.locktype is not distinct from w.locktype and
  r.database is not distinct from w.database and
  r.relation is not distinct from w.relation and
  r.page is not distinct from w.page and
  r.tuple is not distinct from w.tuple and
  r.classid is not distinct from w.classid and
  r.objid is not distinct from w.objid and
  r.objsubid is not distinct from w.objsubid and
  r.transactionid is not distinct from w.transactionid and
  r.pid <> w.pid
  order by 
  ((  case w.mode
    when 'INVALID' then 0
    when 'AccessShareLock' then 1
    when 'RowShareLock' then 2
    when 'RowExclusiveLock' then 3
    when 'ShareUpdateExclusiveLock' then 4
    when 'ShareLock' then 5
    when 'ShareRowExclusiveLock' then 6
    when 'ExclusiveLock' then 7
    when 'AccessExclusiveLock' then 8
    else 0
  end  ) + 
  (  case r.mode
    when 'INVALID' then 0
    when 'AccessShareLock' then 1
    when 'RowShareLock' then 2
    when 'RowExclusiveLock' then 3
    when 'ShareUpdateExclusiveLock' then 4
    when 'ShareLock' then 5
    when 'ShareRowExclusiveLock' then 6
    when 'ExclusiveLock' then 7
    when 'AccessExclusiveLock' then 8
    else 0
  end  )) desc,r.xact_start;

end;
