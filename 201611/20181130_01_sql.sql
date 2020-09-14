-- 初始化
begin; 
CREATE EXTENSION IF NOT EXISTS pg_stat_statements; 

create schema IF NOT EXISTS __rds_pg_stats__; 
set search_path=__rds_pg_stats__,public,pg_catalog; 

-- 全局, pg_db_role_setting  
create table snap_pg_db_role_setting as select 1::int8 snap_id, now() snap_ts, * from pg_db_role_setting; 

-- 全局, 表空间占用  
create table snap_pg_tbs_size as select 1::int8 snap_id, now() snap_ts, spcname, pg_tablespace_location(oid), pg_size_pretty(pg_tablespace_size(oid)) from pg_tablespace where spcname<>'pg_global' order by pg_tablespace_size(oid) desc;  

-- 全局, 数据库空间占用  
create table snap_pg_db_size as select 1::int8 snap_id, now() snap_ts, datname, pg_size_pretty(pg_database_size(oid)) from pg_database order by pg_database_size(oid) desc;  

-- 全局, 当前活跃度  
create table snap_pg_stat_activity as select 1::int8 snap_id, now() snap_ts, state, count(*) from pg_stat_activity group by 1,2,3;  

-- 全局, 总剩余连接数  
create table snap_pg_conn_stats as select 1::int8 snap_id, now() snap_ts, max_conn,used,res_for_super,max_conn-used-res_for_super res_for_normal from (select count(*) used from pg_stat_activity) t1,(select setting::int res_for_super from pg_settings where name=$$superuser_reserved_connections$$) t2,(select setting::int max_conn from pg_settings where name=$$max_connections$$) t3; 

-- 全局, 用户连接数限制  
create table snap_pg_role_conn_limit as select 1::int8 snap_id, now() snap_ts, a.rolname,a.rolconnlimit,b.connects from pg_roles a,(select usename,count(*) connects from pg_stat_activity group by usename) b where a.rolname=b.usename order by b.connects desc;  

-- 全局, 数据库连接限制  
create table snap_pg_db_conn_limit as select 1::int8 snap_id, now() snap_ts, a.datname, a.datconnlimit, b.connects from pg_database a,(select datname,count(*) connects from pg_stat_activity group by datname) b where a.datname=b.datname order by b.connects desc;  

-- 全局, TOP CPU TIME 10 SQL
create table snap_pg_cputime_topsql as select 1::int8 snap_id, now() snap_ts, c.rolname,b.datname,a.total_time/a.calls per_call_time,a.* from pg_stat_statements a,pg_database b,pg_roles c where a.userid=c.oid and a.dbid=b.oid order by a.total_time desc limit 10;  

-- 全局, 数据库统计信息, 回滚比例, 命中比例, 数据块读写时间, 死锁, 复制冲突
create table snap_pg_stat_database as select 1::int8 snap_id, now() snap_ts, datname,round(100*(xact_rollback::numeric/(case when xact_commit > 0 then xact_commit else 1 end + xact_rollback)),2)||$$ %$$ rollback_ratio, round(100*(blks_hit::numeric/(case when blks_read>0 then blks_read else 1 end + blks_hit)),2)||$$ %$$ hit_ratio, blk_read_time, blk_write_time, conflicts, deadlocks from pg_stat_database; 

-- 全局, 检查点, bgwriter 统计信息
create table snap_pg_stat_bgwriter as select 1::int8 snap_id, now() snap_ts,  * from pg_stat_bgwriter; 

-- 全局, archiver 统计信息
create table snap_pg_stat_archiver as select 1::int8 snap_id, now() snap_ts,coalesce(pg_walfile_name(pg_current_wal_insert_lsn()),'-') as now_insert_xlog_file,  * from pg_stat_archiver; 

-- 全局, 数据库年龄
create table snap_pg_database_age as select 1::int8 snap_id, now() snap_ts, datname,age(datfrozenxid),2^31-age(datfrozenxid) age_remain from pg_database order by age(datfrozenxid) desc;

-- 全局, 长事务, 2PC 
create table snap_pg_long_xact as select 1::int8 snap_id, now() snap_ts, datname,usename,query,xact_start,now()-xact_start xact_duration,query_start,now()-query_start query_duration,state from pg_stat_activity where state<>$$idle$$ and (backend_xid is not null or backend_xmin is not null) and now()-xact_start > interval $$30 min$$ order by xact_start;

create table snap_pg_long_2pc as select 1::int8 snap_id, now() snap_ts, name,statement,prepare_time,now()-prepare_time duration,parameter_types,from_sql from pg_prepared_statements where now()-prepare_time > interval $$30 min$$ order by prepare_time;

-- 全局, 用户密码到期时间
create table snap_pg_user_deadline as select 1::int8 snap_id, now() snap_ts, rolname,rolvaliduntil from pg_roles order by rolvaliduntil;

-- 库级, 快照清单
create table snap_list (id serial8 primary key, snap_ts timestamp, snap_level text);  
insert into snap_list (snap_ts, snap_level) values (now(), 'database'); 

-- 库级, pg_stat_statements  
create table snap_pg_stat_statements as select 1::int8 snap_id, now() snap_ts, * from pg_stat_statements; 

-- 库级, 对象空间占用柱状图  
create table snap_pg_rel_space_bucket as select 1::int8 snap_id, now() snap_ts, current_database(), buk this_buk_no, cnt rels_in_this_buk, pg_size_pretty(min) buk_min, pg_size_pretty(max) buk_max from 
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
create table snap_pg_db_rel_size as select 1::int8 snap_id, now() snap_ts, current_database(),b.nspname,c.relname,c.relkind,pg_relation_size(c.oid),a.seq_scan,a.seq_tup_read,a.idx_scan,a.idx_tup_fetch,a.n_tup_ins,a.n_tup_upd,a.n_tup_del,a.n_tup_hot_upd,a.n_live_tup,a.n_dead_tup from pg_stat_all_tables a, pg_class c,pg_namespace b where c.relnamespace=b.oid and c.relkind=$$r$$ and a.relid=c.oid order by pg_relation_size(c.oid) desc limit 5000;  

-- 库级, pg_statio_all_tables  
create table snap_pg_statio_all_tables as select 1::int8 snap_id, now() snap_ts, current_database(),* from pg_statio_all_tables;  

-- 库级, pg_statio_all_indexes  
create table snap_pg_statio_all_indexes as select 1::int8 snap_id, now() snap_ts, current_database(),* from pg_statio_all_indexes;  

-- 库级, 索引数超过4并且SIZE大于10MB的表
create table snap_pg_many_indexes_rel as select 1::int8 snap_id, now() snap_ts, current_database(), t2.nspname, t1.relname, pg_relation_size(t1.oid), t3.idx_cnt from pg_class t1, pg_namespace t2, (select indrelid,count(*) idx_cnt from pg_index group by 1 having count(*)>4) t3 where t1.oid=t3.indrelid and t1.relnamespace=t2.oid and pg_relation_size(t1.oid)/1024/1024.0>10 order by t3.idx_cnt desc; 

-- 库级, 上次快照以来未使用，或者使用较少的索引
create table snap_pg_notused_indexes as select 1::int8 snap_id, now() snap_ts, current_database(),t2.schemaname,t2.relname,t2.indexrelname,t2.idx_scan,t2.idx_tup_read,t2.idx_tup_fetch,pg_relation_size(indexrelid) from pg_stat_all_tables t1,pg_stat_all_indexes t2 where t1.relid=t2.relid and t2.idx_scan<10 and t2.schemaname not in ($$pg_toast$$,$$pg_catalog$$) and indexrelid not in (select conindid from pg_constraint where contype in ($$p$$,$$u$$,$$f$$)) and pg_relation_size(indexrelid)>65536 order by pg_relation_size(indexrelid) desc; 

-- 库级, 表膨胀前10
create table snap_pg_table_bloat as select 1::int8 snap_id, now() snap_ts, 
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
create table snap_pg_index_bloat as select 1::int8 snap_id, now() snap_ts, 
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
create table snap_pg_dead_tup as select 1::int8 snap_id, now() snap_ts, current_database(),schemaname,relname,n_dead_tup from pg_stat_all_tables where n_live_tup>0 and n_dead_tup/n_live_tup>0.2 and schemaname not in ($$pg_toast$$,$$pg_catalog$$) order by n_dead_tup desc limit 10; 

-- 库级, 表年龄前100  
create table snap_pg_rel_age as select 1::int8 snap_id, now() snap_ts, current_database(),rolname,nspname,relkind,relname,age(relfrozenxid),2^31-age(relfrozenxid) age_remain from pg_roles t1 join pg_class t2 on t1.oid=t2.relowner join pg_namespace t3 on t2.relnamespace=t3.oid where t2.relkind in ($$t$$,$$r$$) order by age(relfrozenxid) desc limit 100; 


-- 库级, unlogged table 和 哈希索引
create table snap_pg_unlogged_table as select 1::int8 snap_id, now() snap_ts, current_database(),t3.rolname,t2.nspname,t1.relname from pg_class t1,pg_namespace t2,pg_roles t3 where t1.relnamespace=t2.oid and t1.relowner=t3.oid and t1.relpersistence=$$u$$;

create table snap_pg_hash_idx as select 1::int8 snap_id, now() snap_ts, current_database(),pg_get_indexdef(oid) from pg_class where relkind=$$i$$ and pg_get_indexdef(oid) ~ $$USING hash$$;

-- 库级, 剩余可使用次数不足1000万次的序列检查
 create or replace function sequence_stats(OUT v_datname name, OUT v_role name, OUT v_nspname name, OUT v_relname name, OUT v_times_remain int8) returns setof record as $$
 declare
 begin
  v_datname := current_database();
--  for v_role,v_nspname,v_relname in select rolname,nspname,relname from pg_roles t1 , pg_class t2 , pg_namespace t3 where t1.oid=t2.relowner and t2.relnamespace=t3.oid and t2.relkind='S' 
  select (seqmax-seqmin)/seqincrement from pg_catalog.pg_sequence into v_times_remain; 
--  LOOP
--    execute 'select (9223372036854775807-last_value)/increment_by from "'||v_nspname||'"."'||v_relname||'" where not is_cycled' into v_times_remain;
--    return next;
--  end loop;
 end;
 $$ language plpgsql;

 create table snap_pg_seq_deadline as select 1::int8 snap_id, now() snap_ts, * from sequence_stats() where v_times_remain is not null and v_times_remain < 10240000 order by v_times_remain limit 10;

-- 库级, 清理未引用的大对象 
create table snap_pg_vacuumlo as select 1::int8 snap_id, now() snap_ts, current_database(), 1::int8 as lo_bloat;

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
create table snap_pg_waiting as 
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

-- 打快照函数
create or replace function snap_global(erase_stats boolean default true) returns void as $_$
declare
 snap_id int8;
 ts timestamp := clock_timestamp();

begin
set search_path=__rds_pg_stats__,public,pg_catalog; 

-- 库级, 快照清单
raise notice '%', ts; 
insert into snap_list (snap_ts, snap_level) values (ts, 'global') returning id into snap_id; 

-- 全局, pg_db_role_setting  
insert into snap_pg_db_role_setting select snap_id, ts snap_ts, * from pg_db_role_setting; 

-- 全局, 表空间占用  
insert into snap_pg_tbs_size select snap_id, ts snap_ts, spcname, case when pg_tablespace_location(oid)='' then '-' else pg_tablespace_location(oid) end, pg_size_pretty(pg_tablespace_size(oid)) from pg_tablespace where spcname<>'pg_global' order by pg_tablespace_size(oid) desc;  

-- 全局, 数据库空间占用  
insert into snap_pg_db_size select snap_id, ts snap_ts, datname, pg_size_pretty(pg_database_size(oid)) from pg_database order by pg_database_size(oid) desc;  

-- 全局, 当前活跃度  
insert into snap_pg_stat_activity select snap_id, ts snap_ts, state, count(*) from pg_stat_activity group by 1,2,3;  

-- 全局, 总剩余连接数  
insert into snap_pg_conn_stats select snap_id, ts snap_ts, max_conn,used,res_for_super,max_conn-used-res_for_super res_for_normal from (select count(*) used from pg_stat_activity) t1,(select setting::int res_for_super from pg_settings where name=$$superuser_reserved_connections$$) t2,(select setting::int max_conn from pg_settings where name=$$max_connections$$) t3; 

-- 全局, 用户连接数限制  
insert into snap_pg_role_conn_limit select snap_id, ts snap_ts, a.rolname,a.rolconnlimit,b.connects from pg_roles a,(select usename,count(*) connects from pg_stat_activity group by usename) b where a.rolname=b.usename order by b.connects desc;  

-- 全局, 数据库连接限制   
insert into snap_pg_db_conn_limit select snap_id, ts snap_ts, a.datname, a.datconnlimit, b.connects from pg_database a,(select datname,count(*) connects from pg_stat_activity group by datname) b where a.datname=b.datname order by b.connects desc;  

-- 全局, TOP CPUTIME 10 SQL 
insert into snap_pg_cputime_topsql select snap_id, ts snap_ts, c.rolname,b.datname,a.total_time/a.calls per_call_time,a.* from pg_stat_statements a,pg_database b,pg_roles c where a.userid=c.oid and a.dbid=b.oid order by a.total_time desc limit 10;  

-- 全局, 数据库统计信息, 回滚比例, 命中比例, 数据块读写时间, 死锁, 复制冲突 
insert into snap_pg_stat_database select snap_id, ts snap_ts, datname,round(100*(xact_rollback::numeric/(case when xact_commit > 0 then xact_commit else 1 end + xact_rollback)),2)||$$ %$$ rollback_ratio, round(100*(blks_hit::numeric/(case when blks_read>0 then blks_read else 1 end + blks_hit)),2)||$$ %$$ hit_ratio, blk_read_time, blk_write_time, conflicts, deadlocks from pg_stat_database; 

-- 全局, 检查点, bgwriter 统计信息 
insert into snap_pg_stat_bgwriter select snap_id, ts snap_ts,  * from pg_stat_bgwriter; 

-- 全局, archiver 统计信息 
insert into snap_pg_stat_archiver select snap_id, ts snap_ts, coalesce(pg_walfile_name(pg_current_wal_insert_lsn()),'-') as now_insert_xlog_file,  * from pg_stat_archiver; 

-- 全局, 数据库年龄 
insert into snap_pg_database_age select snap_id, ts snap_ts, datname,age(datfrozenxid),2^31-age(datfrozenxid) age_remain from pg_database order by age(datfrozenxid) desc;

-- 全局, 长事务, 2PC 
insert into snap_pg_long_xact select snap_id, ts snap_ts, datname,usename,query,xact_start,ts-xact_start xact_duration,query_start,ts-query_start query_duration,state from pg_stat_activity where state<>$$idle$$ and (backend_xid is not null or backend_xmin is not null) and ts-xact_start > interval $$30 min$$ order by xact_start;

insert into snap_pg_long_2pc select snap_id, ts snap_ts, name,statement,prepare_time,ts-prepare_time,parameter_types,from_sql from pg_prepared_statements where ts-prepare_time > interval $$30 min$$ order by prepare_time; 

-- 全局, 用户密码到期时间 
insert into snap_pg_user_deadline select snap_id, ts snap_ts, rolname,rolvaliduntil from pg_roles order by rolvaliduntil;

-- 重置统计信息
if erase_stats then 
  perform pg_stat_reset_shared('bgwriter');
  perform pg_stat_reset_shared('archiver');
  perform pg_stat_statements_reset();
end if;

reset search_path;
end;
$_$ language plpgsql strict;


create or replace function snap_database(erase_stats boolean default true) returns void as $_$
declare
 snap_id int8;
 ts timestamp := clock_timestamp();

begin
set search_path=__rds_pg_stats__,public,pg_catalog; 

-- 库级, 快照清单
raise notice '%', ts;
insert into snap_list (snap_ts, snap_level) values (ts, 'database') returning id into snap_id; 

-- 库级, pg_stat_statements  
insert into snap_pg_stat_statements select snap_id, ts snap_ts, * from pg_stat_statements; 

-- 库级, 对象空间占用柱状图  
insert into snap_pg_rel_space_bucket select snap_id, ts snap_ts, current_database(), buk this_buk_no, cnt rels_in_this_buk, pg_size_pretty(min) buk_min, pg_size_pretty(max) buk_max from 
( 
 select row_number() over (partition by buk order by tsize), tsize, buk, min(tsize) over (partition by buk),max(tsize) over (partition by buk), count(*) over (partition by buk) cnt from 
 ( 
   select pg_relation_size(a.oid) tsize, width_bucket(pg_relation_size(a.oid),tmin-1,tmax+1,10) buk from 
   ( 
     select min(pg_relation_size(a.oid)) tmin, max(pg_relation_size(a.oid)) tmax from pg_class a, pg_namespace c where a.relnamespace=c.oid and nspname !~ $$^pg_$$ and nspname<>$$information_schema$$ 
   ) t, pg_class a, pg_namespace c where a.relnamespace=c.oid and nspname !~ $$^pg_$$ and nspname<>$$information_schema$$ 
 ) t 
) t where row_number=1;  

-- 库级, 空间占用前5000的表  
insert into snap_pg_db_rel_size select snap_id, ts snap_ts, current_database(),b.nspname,c.relname,c.relkind,pg_relation_size(c.oid),a.seq_scan,a.seq_tup_read,a.idx_scan,a.idx_tup_fetch,a.n_tup_ins,a.n_tup_upd,a.n_tup_del,a.n_tup_hot_upd,a.n_live_tup,a.n_dead_tup from pg_stat_all_tables a, pg_class c,pg_namespace b where c.relnamespace=b.oid and c.relkind=$$r$$ and a.relid=c.oid order by pg_relation_size(c.oid) desc limit 5000;  

-- 库级, pg_statio_all_tables  
insert into snap_pg_statio_all_tables select snap_id, ts snap_ts, current_database(),* from pg_statio_all_tables;  

-- 库级, pg_statio_all_indexes  
insert into snap_pg_statio_all_indexes select snap_id, ts snap_ts, current_database(),* from pg_statio_all_indexes;  

-- 库级, 索引数超过4并且SIZE大于10MB的表
insert into snap_pg_many_indexes_rel select snap_id, ts snap_ts, current_database(), t2.nspname, t1.relname, pg_relation_size(t1.oid), t3.idx_cnt from pg_class t1, pg_namespace t2, (select indrelid,count(*) idx_cnt from pg_index group by 1 having count(*)>4) t3 where t1.oid=t3.indrelid and t1.relnamespace=t2.oid and pg_relation_size(t1.oid)/1024/1024.0>10 order by t3.idx_cnt desc; 

-- 库级, 上次巡检以来未使用，或者使用较少的索引
insert into snap_pg_notused_indexes select snap_id, ts snap_ts, current_database(),t2.schemaname,t2.relname,t2.indexrelname,t2.idx_scan,t2.idx_tup_read,t2.idx_tup_fetch,pg_relation_size(indexrelid) from pg_stat_all_tables t1,pg_stat_all_indexes t2 where t1.relid=t2.relid and t2.idx_scan<10 and t2.schemaname not in ($$pg_toast$$,$$pg_catalog$$) and indexrelid not in (select conindid from pg_constraint where contype in ($$p$$,$$u$$,$$f$$)) and pg_relation_size(indexrelid)>65536 order by pg_relation_size(indexrelid) desc; 

-- 库级, 表膨胀前10
insert into snap_pg_table_bloat select snap_id, ts snap_ts, 
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
insert into snap_pg_index_bloat select snap_id, ts snap_ts, 
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
insert into snap_pg_dead_tup select snap_id, ts snap_ts, current_database(),schemaname,relname,n_dead_tup from pg_stat_all_tables where n_live_tup>0 and (n_dead_tup/n_live_tup)>0.2 and schemaname not in ($$pg_toast$$,$$pg_catalog$$) order by n_dead_tup desc limit 10;

-- 库级, 表年龄前100
insert into snap_pg_rel_age select snap_id, ts snap_ts, current_database(),rolname,nspname,relkind,relname,age(relfrozenxid),2^31-age(relfrozenxid) age_remain from pg_roles t1 join pg_class t2 on t1.oid=t2.relowner join pg_namespace t3 on t2.relnamespace=t3.oid where t2.relkind in ($$t$$,$$r$$) order by age(relfrozenxid) desc limit 100;


-- 库级, unlogged table 和 哈希索引
insert into snap_pg_unlogged_table select snap_id, ts snap_ts, current_database(),t3.rolname,t2.nspname,t1.relname from pg_class t1,pg_namespace t2,pg_roles t3 where t1.relnamespace=t2.oid and t1.relowner=t3.oid and t1.relpersistence=$$u$$;

insert into snap_pg_hash_idx select snap_id, ts snap_ts, current_database(),pg_get_indexdef(oid) from pg_class where relkind=$$i$$ and pg_get_indexdef(oid) ~ $$USING hash$$;

-- 库级, 剩余可使用次数不足1000万次的序列检查
insert into snap_pg_seq_deadline select snap_id, ts snap_ts, * from sequence_stats() where v_times_remain is not null and v_times_remain < 10240000 order by v_times_remain limit 10;

-- 库级, 清理未引用的大对象 
perform vacuumlo(snap_id) ;

-- 库级, 锁等待
insert into snap_pg_waiting 
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
snap_id, ts snap_ts, 
r.locktype, r.mode r_mode,r.usename r_user,r.datname r_db,
r.relation::regclass,r.pid r_pid,
r.page r_page,r.tuple r_tuple,r.xact_start r_xact_start,
r.query_start r_query_start,
ts-r.query_start r_locktime,r.query r_query,w.mode w_mode,
w.pid w_pid,w.page w_page,
w.tuple w_tuple,w.xact_start w_xact_start,w.query_start w_query_start,
ts-w.query_start w_locktime,w.query w_query  
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

-- 重置统计信息
if erase_stats then 
  perform pg_stat_reset();
end if;

reset search_path;
end;
$_$ language plpgsql strict;

-- 清理快照函数 

-- 清理库级、全局快照
-- 3种清理快照的方法

create or replace function snap_delete_data(i_snap_id int8) returns void as $$ 
declare
begin
  set search_path=__rds_pg_stats__,public,pg_catalog; 

  delete from snap_list where id=i_snap_id;
  delete from snap_pg_conn_stats where snap_id=i_snap_id;      
  delete from snap_pg_cputime_topsql where snap_id=i_snap_id;        
  delete from snap_pg_database_age where snap_id=i_snap_id;          
  delete from snap_pg_db_conn_limit where snap_id=i_snap_id;         
  delete from snap_pg_db_rel_size where snap_id=i_snap_id;           
  delete from snap_pg_db_role_setting where snap_id=i_snap_id;       
  delete from snap_pg_db_size where snap_id=i_snap_id;               
  delete from snap_pg_dead_tup where snap_id=i_snap_id;              
  delete from snap_pg_hash_idx where snap_id=i_snap_id;              
  delete from snap_pg_index_bloat where snap_id=i_snap_id;           
  delete from snap_pg_long_2pc where snap_id=i_snap_id;              
  delete from snap_pg_long_xact where snap_id=i_snap_id;             
  delete from snap_pg_many_indexes_rel where snap_id=i_snap_id;      
  delete from snap_pg_notused_indexes where snap_id=i_snap_id;       
  delete from snap_pg_rel_age where snap_id=i_snap_id;               
  delete from snap_pg_rel_space_bucket where snap_id=i_snap_id;      
  delete from snap_pg_role_conn_limit where snap_id=i_snap_id;       
  delete from snap_pg_seq_deadline where snap_id=i_snap_id;          
  delete from snap_pg_stat_activity where snap_id=i_snap_id;         
  delete from snap_pg_stat_archiver where snap_id=i_snap_id;      
  delete from snap_pg_stat_bgwriter where snap_id=i_snap_id;         
  delete from snap_pg_stat_database where snap_id=i_snap_id;         
  delete from snap_pg_stat_statements where snap_id=i_snap_id;  
  delete from snap_pg_statio_all_indexes where snap_id=i_snap_id;              
  delete from snap_pg_statio_all_tables where snap_id=i_snap_id;  
  delete from snap_pg_table_bloat where snap_id=i_snap_id;           
  delete from snap_pg_tbs_size where snap_id=i_snap_id;              
  delete from snap_pg_unlogged_table where snap_id=i_snap_id;        
  delete from snap_pg_user_deadline where snap_id=i_snap_id;         
  delete from snap_pg_vacuumlo where snap_id=i_snap_id;              
  delete from snap_pg_waiting where snap_id=i_snap_id;           

  reset search_path;
end;
$$ language plpgsql strict; 

-- 删除指定snap_id以前的快照数据
create or replace function snap_delete(i_snap_id int8) returns void as $$ 
declare
  v_snap_id int8;
begin
  set search_path=__rds_pg_stats__,public,pg_catalog; 
  
  for v_snap_id in select id from snap_list where id<i_snap_id order by id 
  loop
    perform snap_delete_data(v_snap_id);
  end loop;

  reset search_path;

end;
$$ language plpgsql strict;


-- 删除指定时间以前的快照数据
create or replace function snap_delete(i_snap_ts timestamp) returns void as $$ 
declare
  v_snap_id int8;
begin
  set search_path=__rds_pg_stats__,public,pg_catalog; 

  for v_snap_id in select id from snap_list where snap_ts<i_snap_ts order by id 
  loop
    perform snap_delete_data(v_snap_id);
  end loop;

  reset search_path;

end;
$$ language plpgsql strict;


-- 保留最近几个快照
create or replace function snap_delete(i_reserved int) returns void as $$ 
declare
  v_snap_id int8;
begin
  set search_path=__rds_pg_stats__,public,pg_catalog; 

  if i_reserved < 1 then
    raise notice 'You must give a value >=1';
    reset search_path;
    return;
  end if;

  for v_snap_id in select id from snap_list where id < (select id from snap_list order by id desc limit 1 offset 2) order by id 
  loop
    perform snap_delete_data(v_snap_id);
  end loop;

  reset search_path;

end;
$$ language plpgsql strict;



-- 生成诊断报告函数
-- 生成全局报告 
-- 指定ID范围 

create or replace function snap_report_global(i_begin_id int8, i_end_id int8, i_level text default 'global') returns setof text as $$ 

declare 
  v_begin_ts timestamp; 
  v_end_ts timestamp; 
  res text[]; 
  tmp text; 
  version text := '9.4';
begin 
  set search_path=__rds_pg_stats__,public,pg_catalog; 
  

-- 判断 ID 是否存在
perform 1 from snap_list where id = i_begin_id and snap_level=i_level ;
if not found then
  raise notice '% snapshot begin_id : % not exist.', i_level, i_begin_id;
  reset search_path;
  return;
end if;

perform 1 from snap_list where id = i_end_id and snap_level=i_level ;
if not found then
  raise notice '% snapshot end_id : % not exist.', i_level, i_end_id;
  reset search_path;
  return;
end if;

-- 生成报告时间段, 如果没有前序快照, 默认往前加1小时
select snap_ts into v_begin_ts from snap_list where id<i_begin_id order by id desc limit 1; 
if not found then
  select snap_ts - interval '1 hour' into v_begin_ts from snap_list where id=i_begin_id;
end if;

select snap_ts into v_end_ts from snap_list where id=i_end_id; 

res := array[format('## 报告时间段: ```%s``` ~ ```%s```    ', v_begin_ts, v_end_ts)]; 
res := array_append(res, '  '); 

res := array_append(res, '## 一、数据库定制参数信息'); 
res := array_append(res, '  '); 

res := array_append(res, '### 1. 用户或数据库级别定制参数'); 
res := array_append(res, '这种设置请务必符合业务需求需要，注意这些参数往往成为隐患。  '); 
res := array_append(res, '  '); 
res := array_append(res, 'database | role | snap_ts | setconfig'); 
res := array_append(res, '---|---|---|---'); 
for tmp in select '```'||coalesce(datname,'-')||'``` | ```'||coalesce(rolname,'-')||'``` | ```'||snap_ts||'``` | '||coalesce(setconfig::text,'-') from snap_pg_db_role_setting t1, pg_database t2, pg_roles t3 where t1.setdatabase=t2.oid and t1.setrole=t3.oid and t1.snap_id >=i_begin_id and t1.snap_id<=i_end_id order by datname,rolname,snap_ts  
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 

res := array_append(res, '## 二、数据库空间使用分析'); 
res := array_append(res, '  '); 

res := array_append(res, '### 1. 表空间在该时段的变化情况'); 
res := array_append(res, '  '); 
res := array_append(res, 'tablespace | tbs_location | snap_ts | size'); 
res := array_append(res, '---|---|---|---'); 
for tmp in select coalesce(spcname,'-')||' | ```'||coalesce(pg_tablespace_location,'-')||'``` | ```'||snap_ts||'``` | '||coalesce(pg_size_pretty,'-') from snap_pg_tbs_size where snap_id >=i_begin_id and snap_id<=i_end_id order by spcname,pg_tablespace_location,snap_ts 
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '注意检查表空间所在文件系统的剩余空间, (默认表空间在$PGDATA/base目录下), IOPS分配是否均匀, OS的sysstat包可以观察IO使用率.  '); 
res := array_append(res, '  '); 

res := array_append(res, '### 2. 数据库在该时段的变化情况'); 
res := array_append(res, '  '); 
res := array_append(res, 'database | snap_ts | size'); 
res := array_append(res, '---|---|---'); 
for tmp in select '```'||coalesce(datname,'-')||'``` | ```'||snap_ts||'``` | '||coalesce(pg_size_pretty,'-') from snap_pg_db_size where snap_id >=i_begin_id and snap_id<=i_end_id order by datname, snap_ts
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '注意检查数据库的大小, 是否需要清理历史数据.  '); 
res := array_append(res, '  '); 

res := array_append(res, '## 三、数据库连接分析'); 
res := array_append(res, '  '); 

res := array_append(res, '### 1. 活跃度在该时段的变化'); 
res := array_append(res, '  '); 
res := array_append(res, 'state | snap_ts | connections'); 
res := array_append(res, '---|---|---'); 
for tmp in select coalesce(state,'-')||' | ```'||snap_ts||'``` | '||coalesce(count,-1) from snap_pg_stat_activity where snap_id >=i_begin_id and snap_id<=i_end_id order by state, snap_ts
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '如果active状态很多, 说明数据库比较繁忙. 如果idle in transaction很多, 说明业务逻辑设计可能有问题. 如果idle很多, 可能使用了连接池, 并且可能没有自动回收连接到连接池的最小连接数.  '); 
res := array_append(res, '  '); 

res := array_append(res, '### 2. 剩余连接数在该时段的变化'); 
res := array_append(res, '  '); 
res := array_append(res, 'snap_ts | max_enabled_connections | used | res_for_super | res_for_normal'); 
res := array_append(res, '---|---|---|---|---'); 
for tmp in select '```'||snap_ts||'``` | '||coalesce(max_conn,-1)||' | '||coalesce(used,-1)||' | '||coalesce(res_for_super,-1)||' | '||coalesce(res_for_normal,-1) from snap_pg_conn_stats where snap_id >=i_begin_id and snap_id<=i_end_id order by snap_ts 
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '给超级用户和普通用户设置足够的连接, 以免不能登录数据库.  '); 
res := array_append(res, '  '); 

res := array_append(res, '### 3. 用户连接数限制在该时段的变化'); 
res := array_append(res, '  '); 
res := array_append(res, 'rolename | snap_ts | conn_limit | connects'); 
res := array_append(res, '---|---|---|---'); 
for tmp in select '```'||coalesce(rolname,'-')||'``` | ```'||snap_ts||'``` | '||coalesce(rolconnlimit,-1)||' | '||coalesce(connects,-1) from snap_pg_role_conn_limit where snap_id >=i_begin_id and snap_id<=i_end_id order by rolname, snap_ts  
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '给用户设置足够的连接数, alter role ... CONNECTION LIMIT .  '); 
res := array_append(res, '  '); 

res := array_append(res, '### 4. 数据库连接限制在该时段的变化'); 
res := array_append(res, '  '); 
res := array_append(res, 'database | snap_ts | conn_limit | connects'); 
res := array_append(res, '---|---|---|---'); 
for tmp in select '```'||coalesce(datname,'-')||'``` | ```'||snap_ts||'``` | '||coalesce(datconnlimit,-1)||' | '||coalesce(connects,-1) from snap_pg_db_conn_limit where snap_id >=i_begin_id and snap_id<=i_end_id order by datname, snap_ts  
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '给数据库设置足够的连接数, alter database ... CONNECTION LIMIT .  '); 
res := array_append(res, '  '); 

res := array_append(res, '## 四、数据库性能分析'); 
res := array_append(res, '  '); 

res := array_append(res, '### 1. TOP 10 SQL : total_cpu_time'); 
res := array_append(res, '  '); 


-- res := array_append(res, 'rolename | database | calls | total_ms | min_ms | max_ms | mean_ms | stddev_ms | rows | shared_blks_hit | shared_blks_read | shared_blks_dirtied | shared_blks_written | local_blks_hit | local_blks_read | local_blks_dirtied | shared_blks_written | temp_blks_read | temp_blks_written | blk_read_time | blk_write_time | query'); 

-- res := array_append(res, '---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---'); 

-- for tmp in select '```'||coalesce(rolname,'-')||'``` | ```'||coalesce(datname,'-')||'``` | '||coalesce(sum(calls),-1)||' | '||coalesce(sum(total_time),-1)||' | '||coalesce(avg(min_time),-1)||' | '||coalesce(avg(max_time),-1)||' | '||coalesce(avg(mean_time),-1)||' | '||coalesce(avg(stddev_time),-1)||' | '||coalesce(sum(rows),-1)||' | '||coalesce(sum(shared_blks_hit),-1)||' | '||coalesce(sum(shared_blks_read),-1)||' | '||coalesce(sum(shared_blks_dirtied),-1)||' | '||coalesce(sum(shared_blks_written),-1)||' | '||coalesce(sum(local_blks_hit),-1)||' | '||coalesce(sum(local_blks_read),-1)||' | '||coalesce(sum(local_blks_dirtied),-1)||' | '||coalesce(sum(local_blks_written),-1)||' | '||coalesce(sum(temp_blks_read),-1)||' | '||coalesce(sum(temp_blks_written),-1)||' | '||coalesce(sum(blk_read_time),-1)||' | '||coalesce(sum(blk_write_time),-1)||' |  ```'||coalesce(replace(regexp_replace(query,'\n',' ','g'), '|', '&#124;'),'-')||'```' from snap_pg_cputime_topsql where snap_id >=i_begin_id and snap_id<=i_end_id group by rolname,datname,query   order by sum(total_time) desc nulls last limit 10 

res := array_append(res, 'rolename | database | calls | total_ms | rows | shared_blks_hit | shared_blks_read | shared_blks_dirtied | shared_blks_written | local_blks_hit | local_blks_read | local_blks_dirtied | shared_blks_written | temp_blks_read | temp_blks_written | blk_read_time | blk_write_time | query'); 

res := array_append(res, '---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---'); 

for tmp in select '```'||coalesce(rolname,'-')||'``` | ```'||coalesce(datname,'-')||'``` | '||coalesce(sum(calls),-1)||' | '||coalesce(sum(total_time),-1)||' | '||coalesce(sum(rows),-1)||' | '||coalesce(sum(shared_blks_hit),-1)||' | '||coalesce(sum(shared_blks_read),-1)||' | '||coalesce(sum(shared_blks_dirtied),-1)||' | '||coalesce(sum(shared_blks_written),-1)||' | '||coalesce(sum(local_blks_hit),-1)||' | '||coalesce(sum(local_blks_read),-1)||' | '||coalesce(sum(local_blks_dirtied),-1)||' | '||coalesce(sum(local_blks_written),-1)||' | '||coalesce(sum(temp_blks_read),-1)||' | '||coalesce(sum(temp_blks_written),-1)||' | '||coalesce(sum(blk_read_time),-1)||' | '||coalesce(sum(blk_write_time),-1)||' |  ```'||coalesce(replace(regexp_replace(query,'\n',' ','g'), '|', '&#124;'),'-')||'```' from snap_pg_cputime_topsql where snap_id >=i_begin_id and snap_id<=i_end_id group by rolname,datname,query   order by sum(total_time) desc nulls last limit 10 

loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '从最耗时的SQL开始, 检查SQL是否有优化空间, 配合auto_explain插件在csvlog中观察LONG SQL的执行计划是否正确.  '); 
res := array_append(res, '  '); 

res := array_append(res, '### 2. 数据库统计信息, 回滚比例, 命中比例, 数据块读写时间, 死锁, 复制冲突 在该时段的变化'); 
res := array_append(res, '  '); 
res := array_append(res, 'database | snap_ts | rollback_ratio | hit_ratio | blk_read_time | blk_write_time | conflicts | deadlocks'); 
res := array_append(res, '---|---|---|---|---|---|---|---'); 
for tmp in select '```'||coalesce(datname,'-')||'``` | ```'||snap_ts||'``` | '||coalesce(rollback_ratio,'-1')||' | '||coalesce(hit_ratio,'-1')||' | '||coalesce(blk_read_time,-1)||' | '||coalesce(blk_write_time,-1)||' | '||coalesce(conflicts,-1)||' | '||coalesce(deadlocks,-1) from snap_pg_stat_database where snap_id >=i_begin_id and snap_id<=i_end_id order by datname, snap_ts  
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '回滚比例大说明业务逻辑可能有问题, 命中率小说明shared_buffer要加大, 数据块读写时间长说明块设备的IO性能要提升, 死锁次数多说明业务逻辑有问题, 复制冲突次数多说明备库可能在跑LONG SQL.  '); 
res := array_append(res, '  '); 

res := array_append(res, '### 3. 检查点, bgwriter 统计信息'); 
res := array_append(res, '  '); 
res := array_append(res, 'checkpoints_timed | checkpoints_req | checkpoint_write_time | checkpoint_sync_time | buffers_checkpoint | buffers_clean | maxwritten_clean | buffers_backend | buffers_backend_fsync | buffers_alloc'); 
res := array_append(res, '---|---|---|---|---|---|---|---|---|---'); 
for tmp in select coalesce(sum(checkpoints_timed),-1)||' | '||coalesce(sum(checkpoints_req),-1)||' | '||coalesce(sum(checkpoint_write_time),-1)||' | '||coalesce(sum(checkpoint_sync_time),-1)||' | '||coalesce(sum(buffers_checkpoint),-1)||' | '||coalesce(sum(buffers_clean),-1)||' | '||coalesce(sum(maxwritten_clean),-1)||' | '||coalesce(sum(buffers_backend),-1)||' | '||coalesce(sum(buffers_backend_fsync),-1)||' | '||coalesce(sum(buffers_alloc),-1) from snap_pg_stat_bgwriter where snap_id >=i_begin_id and snap_id<=i_end_id  
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 说明'); 
res := array_append(res, '  '); 
res := array_append(res, 'checkpoints_timed , 统计周期内, 发生了多少次调度检查点.  '); 
res := array_append(res, '  '); 
res := array_append(res, 'checkpoints_req , 统计周期内, 发生了多少次人为执行检查点.  '); 
res := array_append(res, '  '); 
res := array_append(res, 'checkpoint_write_time , 检查点过程中, write系统调用的耗时ms.  '); 
res := array_append(res, '  '); 
res := array_append(res, 'checkpoint_sync_time , 检查点过程中, fsync系统调用的耗时ms.  '); 
res := array_append(res, '  '); 
res := array_append(res, 'buffers_checkpoint , 检查点过程中, ckpt进程写出(write)了多少buffer pages.  '); 
res := array_append(res, '  '); 
res := array_append(res, 'buffers_clean , 统计周期内, bgwriter进程写出(write)了多少buffer pages.  '); 
res := array_append(res, '  '); 
res := array_append(res, 'maxwritten_clean , 统计周期内, bgwriter被打断了多少次(由于write的pages超过一个bgwriter调度周期内的阈值).  '); 
res := array_append(res, '  '); 
res := array_append(res, 'buffers_backend , 统计周期内, 有多少pages是被backend process直接write out的.  '); 
res := array_append(res, '  '); 
res := array_append(res, 'buffers_backend_fsync , 统计周期内, 有多少pages是被backend process直接fsync的.  '); 
res := array_append(res, '  '); 
res := array_append(res, 'buffers_alloc , 统计周期内, 指派了多少个pages.  '); 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, 'checkpoint_write_time多说明检查点持续时间长, 检查点过程中产生了较多的脏页.  '); 
res := array_append(res, '  '); 
res := array_append(res, 'checkpoint_sync_time代表检查点开始时的shared buffer中的脏页被同步到磁盘的时间, 如果时间过长, 并且数据库在检查点时性能较差, 考虑一下提升块设备的IOPS能力.  '); 
res := array_append(res, '  '); 
res := array_append(res, 'buffers_backend_fsync太多说明需要加大shared buffer 或者 减小bgwriter_delay参数.  '); 
res := array_append(res, '  '); 
res := array_append(res, 'maxwritten_clean太多说明需要减小调大bgwriter_lru_maxpages和bgwriter_lru_multiplier参数.  '); 
res := array_append(res, '  '); 

res := array_append(res, '### 4. 归档统计信息'); 
res := array_append(res, '  '); 
res := array_append(res, 'archived_count | last_archived_wal | last_archived_time | failed_count | last_failed_wal | last_failed_time | now_insert_xlog_file'); 
res := array_append(res, '---|---|---|---|---|---|---'); 
for tmp in select coalesce(archived_count,-1)||' | '||coalesce(last_archived_wal,'-')||' | ```'||coalesce(last_archived_time,'1970-01-01')||'``` | '||coalesce(failed_count,-1)||' | '||coalesce(last_failed_wal,'-')||' | ```'||coalesce(last_failed_time,'1970-01-01')||'``` | '||coalesce(now_insert_xlog_file,'-') from snap_pg_stat_archiver where snap_id=i_end_id   
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, 'last_archived_wal和now_insert_xlog_file相差很多, 说明失败的归档很多, 或者归档慢, 需要检查原因(IO\CPU\网络等).  '); 
res := array_append(res, '  '); 

res := array_append(res, '## 五、数据库年龄分析'); 
res := array_append(res, '  '); 

res := array_append(res, '### 1. 数据库年龄在该时段的变化'); 
res := array_append(res, '  '); 
res := array_append(res, 'database | snap_ts | age | age_remain'); 
res := array_append(res, '---|---|---|---'); 
for tmp in select '```'||coalesce(datname,'-')||'``` | ```'||snap_ts||'``` | '||coalesce(age,-1)||' | '||coalesce(age_remain,-1) from snap_pg_database_age where snap_id >=i_begin_id and snap_id<=i_end_id order by datname,snap_ts   
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '正常情况下, 数据库的年龄应该小于vacuum_freeze_table_age, 如果剩余年龄小于2亿, 建议人为干预, 将LONG SQL或事务杀掉后, 执行vacuum freeze.  '); 
res := array_append(res, '  '); 

res := array_append(res, '### 2. 长事务, 2PC'); 
res := array_append(res, '  '); 
res := array_append(res, 'snap_ts | database | user | query | xact_start | xact_duration | query_start | query_duration | state'); 
res := array_append(res, '---|---|---|---|---|---|---|---|---'); 
for tmp in select '```'||snap_ts||'``` | ```'||coalesce(datname,'-')||'``` | ```'||coalesce(usename,'-')||'``` | ```'||coalesce(replace(regexp_replace(query,'\n',' ','g'), '|', '&#124;'),'-')||'``` | ```'||coalesce(xact_start,'1970-01-01')||'``` | ```'||coalesce(xact_duration,'0 s')||'``` | ```'||coalesce(query_start,'1970-01-01')||'``` | ```'||coalesce(query_duration,'0 s')||'``` | '||coalesce(state,'-') from snap_pg_long_xact where snap_id >=i_begin_id and snap_id<=i_end_id order by snap_ts,datname,usename,query     
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, 'snap_ts | name | statement | prepare_time | duration | parameter_types | from_sql'); 
res := array_append(res, '---|---|---|---|---|---|---|---|---'); 
for tmp in select '```'||snap_ts||'``` | ```'||coalesce(name,'-')||'``` | ```'||coalesce(replace(regexp_replace(statement,'\n',' ','g'), '|', '&#124;'),'-')||'``` | ```'||coalesce(prepare_time,'1970-01-01')||'``` | ```'||coalesce(duration,'0 s')||'``` | '||coalesce(parameter_types::text,'-')||' | '||coalesce(from_sql,'false') from snap_pg_long_2pc where snap_id >=i_begin_id and snap_id<=i_end_id order by snap_ts,prepare_time,name,statement 
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '长事务过程中产生的垃圾, 无法回收, 建议不要在数据库中运行LONG SQL, 或者错开DML高峰时间去运行LONG SQL. 2PC事务一定要记得尽快结束掉, 否则可能会导致数据库膨胀.  '); 
res := array_append(res, '  '); 
res := array_append(res, '参考: https://github.com/digoal/blog/blob/master/201504/20150429_02.md   '); 
res := array_append(res, '  '); 

res := array_append(res, '## 六、数据库安全或潜在风险分析'); 
res := array_append(res, '  '); 

res := array_append(res, '### 1. 用户密码到期时间'); 
res := array_append(res, '  '); 
res := array_append(res, 'snap_ts | rolname | rolvaliduntil'); 
res := array_append(res, '---|---|---|---'); 
for tmp in select '```'||snap_ts||'``` | ```'||coalesce(rolname,'-')||'``` | ```'||coalesce(rolvaliduntil,'9999-01-01')||'```' from snap_pg_user_deadline where snap_id=i_end_id order by snap_ts,rolname   
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '到期后, 用户将无法登陆, 记得修改密码, 同时将密码到期时间延长到某个时间或无限时间, alter role ... VALID UNTIL ''$timestamp''.  '); 
res := array_append(res, '  '); 

reset search_path;
return query select t from unnest(res) t1(t); 

end; 
$$ language plpgsql strict; 





-- 生成库级报告


-- 指定ID范围 
create or replace function snap_report_database(i_begin_id int8, i_end_id int8, i_level text default 'database') returns setof text as $$ 

declare 
  v_begin_ts timestamp; 
  v_end_ts timestamp; 
  res text[]; 
  tmp text; 
  version text := '9.4';
begin 
  set search_path=__rds_pg_stats__,public,pg_catalog; 

-- 判断 ID 是否存在
perform 1 from snap_list where id = i_begin_id and snap_level=i_level ;
if not found then
  raise notice '% snapshot begin_id : % not exist.', i_level, i_begin_id;
  reset search_path;
  return;
end if;

perform 1 from snap_list where id = i_end_id and snap_level=i_level ;
if not found then
  raise notice '% snapshot end_id : % not exist.', i_level, i_end_id;
  reset search_path;
  return;
end if;

-- 生成报告时间段, 如果没有前序快照, 默认往前加1小时
select snap_ts into v_begin_ts from snap_list where id<i_begin_id order by id desc limit 1; 
if not found then
  select snap_ts - interval '1 hour' into v_begin_ts from snap_list where id=i_begin_id;
end if;

select snap_ts into v_end_ts from snap_list where id=i_end_id; 

res := array[format('## 报告时间段: ```%s``` ~ ```%s```    ', v_begin_ts, v_end_ts)]; 
res := array_append(res, '  '); 

res := array_append(res, '## 一、数据库性能分析'); 
res := array_append(res, '  '); 

res := array_append(res, '### 1. 当前数据库 TOP 10 SQL : total_cpu_time'); 
res := array_append(res, '  '); 

-- res := array_append(res, 'calls | total_ms | min_ms | max_ms | mean_ms | stddev_ms | rows | shared_blks_hit | shared_blks_read | shared_blks_dirtied | shared_blks_written | local_blks_hit | local_blks_read | local_blks_dirtied | shared_blks_written | temp_blks_read | temp_blks_written | blk_read_time | blk_write_time | query'); 
-- res := array_append(res, '---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---'); 
-- for tmp in select coalesce(sum(calls),-1)||' | '||coalesce(sum(total_time),-1)||' | '||coalesce(avg(min_time),-1)||' | '||coalesce(avg(max_time),-1)||' | '||coalesce(avg(mean_time),-1)||' | '||coalesce(avg(stddev_time),-1)||' | '||coalesce(sum(rows),-1)||' | '||coalesce(sum(shared_blks_hit),-1)||' | '||coalesce(sum(shared_blks_read),-1)||' | '||coalesce(sum(shared_blks_dirtied),-1)||' | '||coalesce(sum(shared_blks_written),-1)||' | '||coalesce(sum(local_blks_hit),-1)||' | '||coalesce(sum(local_blks_read),-1)||' | '||coalesce(sum(local_blks_dirtied),-1)||' | '||coalesce(sum(local_blks_written),-1)||' | '||coalesce(sum(temp_blks_read),-1)||' | '||coalesce(sum(temp_blks_written),-1)||' | '||coalesce(sum(blk_read_time),-1)||' | '||coalesce(sum(blk_write_time),-1)||' | ```'||coalesce(replace(regexp_replace(query,'\n',' ','g'), '|', '&#124;'),'-')||'```' from snap_pg_stat_statements where snap_id >=i_begin_id and snap_id<=i_end_id and dbid=(select oid from pg_database where datname=current_database()) group by query order by sum(total_time) desc nulls last limit 10

res := array_append(res, 'calls | total_ms | rows | shared_blks_hit | shared_blks_read | shared_blks_dirtied | shared_blks_written | local_blks_hit | local_blks_read | local_blks_dirtied | shared_blks_written | temp_blks_read | temp_blks_written | blk_read_time | blk_write_time | query'); 
res := array_append(res, '---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---'); 
for tmp in select coalesce(sum(calls),-1)||' | '||coalesce(sum(total_time),-1)||' | '||coalesce(sum(rows),-1)||' | '||coalesce(sum(shared_blks_hit),-1)||' | '||coalesce(sum(shared_blks_read),-1)||' | '||coalesce(sum(shared_blks_dirtied),-1)||' | '||coalesce(sum(shared_blks_written),-1)||' | '||coalesce(sum(local_blks_hit),-1)||' | '||coalesce(sum(local_blks_read),-1)||' | '||coalesce(sum(local_blks_dirtied),-1)||' | '||coalesce(sum(local_blks_written),-1)||' | '||coalesce(sum(temp_blks_read),-1)||' | '||coalesce(sum(temp_blks_written),-1)||' | '||coalesce(sum(blk_read_time),-1)||' | '||coalesce(sum(blk_write_time),-1)||' | ```'||coalesce(replace(regexp_replace(query,'\n',' ','g'), '|', '&#124;'),'-')||'```' from snap_pg_stat_statements where snap_id >=i_begin_id and snap_id<=i_end_id and dbid=(select oid from pg_database where datname=current_database()) group by query order by sum(total_time) desc nulls last limit 10

loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '检查SQL是否有优化空间, 配合auto_explain插件在csvlog中观察LONG SQL的执行计划是否正确.  '); 
res := array_append(res, '  '); 

res := array_append(res, '### 2. TOP 10 size 表统计信息'); 
res := array_append(res, '  '); 
res := array_append(res, 'current_database | nspname | relname | relkind | pg_relation_size | seq_scan | seq_tup_read | idx_scan | idx_tup_fetch | n_tup_ins | n_tup_upd | n_tup_del | n_tup_hot_upd | n_live_tup | n_dead_tup'); 
res := array_append(res, '---|---|---|---|---|---|---|---|---|---|---|---|---|---|---'); 
for tmp in select '```'||coalesce(current_database,'-')||'``` | ```'||coalesce(nspname,'-')||'``` | ```'||coalesce(relname,'-')||'``` | '||coalesce(relkind,'-')||' | '||coalesce(pg_size_pretty(avg(pg_relation_size)),'-')||' | '||coalesce(sum(seq_scan),-1)||' | '||coalesce(sum(seq_tup_read),-1)||' | '||coalesce(sum(idx_scan),-1)||' | '||coalesce(sum(idx_tup_fetch),-1)||' | '||coalesce(sum(n_tup_ins),-1)||' | '||coalesce(sum(n_tup_upd),-1)||' | '||coalesce(sum(n_tup_del),-1)||' | '||coalesce(sum(n_tup_hot_upd),-1)||' | '||coalesce(avg(n_live_tup),-1)||' | '||coalesce(avg(n_dead_tup),-1) from snap_pg_db_rel_size where snap_id >=i_begin_id and snap_id<=i_end_id group by current_database,nspname,relname,relkind order by avg(pg_relation_size) desc nulls last limit 10  
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 说明'); 
res := array_append(res, '  '); 
res := array_append(res, 'seq_scan, 全表扫描次数  '); 
res := array_append(res, '  '); 
res := array_append(res, 'seq_tup_read, 全表扫描实际一共读取了多少条记录, 如果平均每次读取的记录数不多, 可能是limit语句造成的  '); 
res := array_append(res, '  '); 
res := array_append(res, 'idx_scan, 索引扫描次数  '); 
res := array_append(res, '  '); 
res := array_append(res, 'idx_tup_fetch, 索引扫描实际获取的记录数, 如果平均每次读取记录数很多, 说明数据库倾向使用索引扫描, 建议观察随机IO的性能看情况调整  '); 
res := array_append(res, '  '); 
res := array_append(res, 'n_tup_ins, 统计周期内, 插入了多少条记录  '); 
res := array_append(res, '  '); 
res := array_append(res, 'n_tup_upd, 统计周期内, 更新了多少条记录  '); 
res := array_append(res, '  '); 
res := array_append(res, 'n_tup_hot_upd, 统计周期内, HOT更新(指更新后的记录依旧在当前PAGE)了多少条记录  '); 
res := array_append(res, '  '); 
res := array_append(res, 'n_live_tup, 该表有多少可用数据  '); 
res := array_append(res, '  '); 
res := array_append(res, 'n_dead_tup, 该表有多少垃圾数据  '); 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '经验值: 单表超过10GB, 并且这个表需要频繁更新 或 删除+插入的话, 建议对表根据业务逻辑进行合理拆分后获得更好的性能, 以及便于对膨胀索引进行维护; 如果是只读的表, 建议适当结合SQL语句进行优化.  '); 
res := array_append(res, '  '); 

res := array_append(res, '### 3. 全表扫描统计 , 平均实际扫描记录数排名前10的表'); 
res := array_append(res, '  '); 
res := array_append(res, 'current_database | nspname | relname | relkind | pg_relation_size | seq_scan | seq_tup_read | idx_scan | idx_tup_fetch | n_tup_ins | n_tup_upd | n_tup_del | n_tup_hot_upd | n_live_tup | n_dead_tup'); 
res := array_append(res, '---|---|---|---|---|---|---|---|---|---|---|---|---|---|---'); 
for tmp in select '```'||coalesce(current_database,'-')||'``` | ```'||coalesce(nspname,'-')||'``` | ```'||coalesce(relname,'-')||'``` | '||coalesce(relkind,'-')||' | '||coalesce(pg_size_pretty(avg(pg_relation_size)),'-')||' | '||coalesce(sum(seq_scan),-1)||' | '||coalesce(sum(seq_tup_read),-1)||' | '||coalesce(sum(idx_scan),-1)||' | '||coalesce(sum(idx_tup_fetch),-1)||' | '||coalesce(sum(n_tup_ins),-1)||' | '||coalesce(sum(n_tup_upd),-1)||' | '||coalesce(sum(n_tup_del),-1)||' | '||coalesce(sum(n_tup_hot_upd),-1)||' | '||coalesce(avg(n_live_tup),-1)||' | '||coalesce(avg(n_dead_tup),-1) from snap_pg_db_rel_size where snap_id >=i_begin_id and snap_id<=i_end_id group by current_database,nspname,relname,relkind order by avg(case when seq_tup_read=0 then 1 else seq_tup_read end/case when seq_scan=0 then 1 else seq_scan end) desc nulls last limit 10  
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 说明'); 
res := array_append(res, '  '); 
res := array_append(res, 'seq_scan, 全表扫描次数  '); 
res := array_append(res, '  '); 
res := array_append(res, 'seq_tup_read, 全表扫描实际一共读取了多少条记录, 如果平均每次读取的记录数不多, 可能是limit语句造成的  '); 
res := array_append(res, '  '); 
res := array_append(res, 'idx_scan, 索引扫描次数  '); 
res := array_append(res, '  '); 
res := array_append(res, 'idx_tup_fetch, 索引扫描实际获取的记录数, 如果平均每次读取记录数很多, 说明数据库倾向使用索引扫描, 建议观察随机IO的性能看情况调整  '); 
res := array_append(res, '  '); 
res := array_append(res, 'n_tup_ins, 统计周期内, 插入了多少条记录  '); 
res := array_append(res, '  '); 
res := array_append(res, 'n_tup_upd, 统计周期内, 更新了多少条记录  '); 
res := array_append(res, '  '); 
res := array_append(res, 'n_tup_hot_upd, 统计周期内, HOT更新(指更新后的记录依旧在当前PAGE)了多少条记录  '); 
res := array_append(res, '  '); 
res := array_append(res, 'n_live_tup, 该表有多少可用数据  '); 
res := array_append(res, '  '); 
res := array_append(res, 'n_dead_tup, 该表有多少垃圾数据  '); 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '平均扫描的记录数如果很多, 建议找到SQL, 并针对性的创建索引(统计分析需求除外).  '); 
res := array_append(res, '  '); 

res := array_append(res, '### 4. 未命中buffer , 热表统计'); 
res := array_append(res, '  '); 
res := array_append(res, 'current_database | schemaname | relname | heap_blks_read | heap_blks_hit | idx_blks_read | idx_blks_hit | toast_blks_read | toast_blks_hit | tidx_blks_read | tidx_blks_hit'); 
res := array_append(res, '---|---|---|---|---|---|---|---|---|---|---'); 
for tmp in select '```'||coalesce(current_database,'-')||'``` | ```'||coalesce(schemaname,'-')||'``` | ```'||coalesce(relname,'-')||'``` | '||coalesce(sum(heap_blks_read),-1)||' | '||coalesce(sum(heap_blks_hit),-1)||' | '||coalesce(sum(idx_blks_read),-1)||' | '||coalesce(sum(idx_blks_hit),-1)||' | '||coalesce(sum(toast_blks_read),-1)||' | '||coalesce(sum(toast_blks_hit),-1)||' | '||coalesce(sum(tidx_blks_read),-1)||' | '||coalesce(sum(tidx_blks_hit),-1) from snap_pg_statio_all_tables where snap_id >=i_begin_id and snap_id<=i_end_id group by current_database,schemaname,relname order by sum(heap_blks_read+idx_blks_read+toast_blks_read+tidx_blks_read) desc nulls last limit 10  
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '如果热表的命中率很低, 说明需要增加shared buffer, 添加内存.  '); 
res := array_append(res, '  '); 

res := array_append(res, '### 5. 未命中&命中buffer , 热表统计'); 
res := array_append(res, '  '); 
res := array_append(res, 'current_database | schemaname | relname | heap_blks_read | heap_blks_hit | idx_blks_read | idx_blks_hit | toast_blks_read | toast_blks_hit | tidx_blks_read | tidx_blks_hit'); 
res := array_append(res, '---|---|---|---|---|---|---|---|---|---|---'); 
for tmp in select '```'||coalesce(current_database,'-')||'``` | ```'||coalesce(schemaname,'-')||'``` | ```'||coalesce(relname,'-')||'``` | '||coalesce(sum(heap_blks_read),-1)||' | '||coalesce(sum(heap_blks_hit),-1)||' | '||coalesce(sum(idx_blks_read),-1)||' | '||coalesce(sum(idx_blks_hit),-1)||' | '||coalesce(sum(toast_blks_read),-1)||' | '||coalesce(sum(toast_blks_hit),-1)||' | '||coalesce(sum(tidx_blks_read),-1)||' | '||coalesce(sum(tidx_blks_hit),-1) from snap_pg_statio_all_tables where snap_id >=i_begin_id and snap_id<=i_end_id group by current_database,schemaname,relname order by sum(heap_blks_hit+idx_blks_hit+toast_blks_hit+tidx_blks_hit+heap_blks_read+idx_blks_read+toast_blks_read+tidx_blks_read) desc nulls last limit 10  
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '如果热表的命中率很低, 说明需要增加shared buffer, 添加内存.  '); 
res := array_append(res, '  '); 

res := array_append(res, '### 6. 未命中 , 热索引统计'); 
res := array_append(res, '  '); 
res := array_append(res, 'current_database | schemaname | relname | indexrelname | idx_blks_read | idx_blks_hit'); 
res := array_append(res, '---|---|---|---|---|---'); 
for tmp in select '```'||coalesce(current_database,'-')||'``` | ```'||coalesce(schemaname,'-')||'``` | ```'||coalesce(relname,'-')||'``` | ```'||coalesce(indexrelname,'-')||'``` | '||coalesce(sum(idx_blks_read),-1)||' | '||coalesce(sum(idx_blks_hit),-1) from snap_pg_statio_all_indexes where snap_id >=i_begin_id and snap_id<=i_end_id group by current_database,schemaname,relname,indexrelname order by sum(idx_blks_read) desc nulls last limit 10  
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '如果热索引的命中率很低, 说明需要增加shared buffer, 添加内存.  '); 
res := array_append(res, '  '); 

res := array_append(res, '### 7. 未命中&命中buffer , 热索引统计'); 
res := array_append(res, '  '); 
res := array_append(res, 'current_database | schemaname | relname | indexrelname | idx_blks_read | idx_blks_hit'); 
res := array_append(res, '---|---|---|---|---|---'); 
for tmp in select '```'||coalesce(current_database,'-')||'``` | ```'||coalesce(schemaname,'-')||'``` | ```'||coalesce(relname,'-')||'``` | ```'||coalesce(indexrelname,'-')||'``` | '||coalesce(sum(idx_blks_read),-1)||' | '||coalesce(sum(idx_blks_hit),-1) from snap_pg_statio_all_indexes where snap_id >=i_begin_id and snap_id<=i_end_id group by current_database,schemaname,relname,indexrelname order by sum(idx_blks_read+idx_blks_hit) desc nulls last limit 10  
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '如果热索引的命中率很低, 说明需要增加shared buffer, 添加内存.  '); 
res := array_append(res, '  '); 

res := array_append(res, '### 8. 上次巡检以来未使用，或者使用较少的索引'); 
res := array_append(res, '  '); 
res := array_append(res, 'current_database | schemaname | relname | indexrelname | idx_scan | idx_tup_read | idx_tup_fetch | pg_size_pretty'); 
res := array_append(res, '---|---|---|---|---|---'); 
for tmp in select '```'||coalesce(current_database,'-')||'``` | ```'||coalesce(schemaname,'-')||'``` | ```'||coalesce(relname,'-')||'``` | ```'||coalesce(indexrelname,'-')||'``` | '||coalesce(sum(idx_scan),-1)||' | '||coalesce(sum(idx_tup_read),-1)||' | '||coalesce(sum(idx_tup_fetch),-1)||' | '||coalesce(pg_size_pretty(avg(pg_relation_size)),'-') from snap_pg_notused_indexes where snap_id >=i_begin_id and snap_id<=i_end_id group by current_database,schemaname,relname,indexrelname order by sum(idx_scan) nulls last limit 10  
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '建议和应用开发人员确认后, 删除不需要的索引.  '); 
res := array_append(res, '  ');

res := array_append(res, '### 9. 索引数超过4并且SIZE大于10MB的表'); 
res := array_append(res, '  '); 
res := array_append(res, 'current_database | schemaname | relname | pg_size_pretty | idx_cnt'); 
res := array_append(res, '---|---|---|---|---'); 
for tmp in select '```'||coalesce(current_database,'-')||'``` | ```'||coalesce(nspname,'-')||'``` | ```'||coalesce(relname,'-')||'``` | '||coalesce(pg_size_pretty(avg(pg_relation_size)),'-')||' | '||coalesce(max(idx_cnt),-1) from snap_pg_many_indexes_rel where snap_id >=i_begin_id and snap_id<=i_end_id group by current_database,nspname,relname order by max(idx_cnt) desc nulls last limit 20  
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '索引数量太多, 影响表的增删改性能, 建议检查是否有不需要的索引.  '); 
res := array_append(res, '  ');
res := array_append(res, '建议检查pg_stat_all_tables(n_tup_ins,n_tup_upd,n_tup_del,n_tup_hot_upd), 如果确实非常频繁, 建议检查哪些索引是不需要的.  '); 
res := array_append(res, '  ');

res := array_append(res, '## 二、数据库空间使用分析'); 
res := array_append(res, '  '); 

res := array_append(res, '### 1. 用户对象占用空间的柱状图'); 
res := array_append(res, '  '); 
res := array_append(res, 'snap_ts | current_database | this_buk_no | rels_in_this_buk | buk_min | buk_max'); 
res := array_append(res, '---|---|---|---|---|---'); 
for tmp in select '```'||snap_ts||'``` | ```'||coalesce(current_database,'-')||'``` | '||coalesce(this_buk_no,-1)||' | '||coalesce(rels_in_this_buk,-1)||' | '||coalesce(buk_min,'-')||' | '||coalesce(buk_max,'-') from snap_pg_rel_space_bucket where snap_id >=i_begin_id and snap_id<=i_end_id order by snap_ts,current_database,this_buk_no nulls last
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '纵览用户对象大小的柱状分布图, 单容量超过10GB的对象(指排除TOAST的空间还超过10GB)，建议分区, 目前建议使用pg_pathman插件.  '); 
res := array_append(res, '  '); 

res := array_append(res, '## 三、数据库垃圾分析'); 
res := array_append(res, '  '); 

res := array_append(res, '### 1. 表膨胀分析'); 
res := array_append(res, '  '); 
res := array_append(res, 'snap_ts | db | schemaname | tablename | tups | pages | otta | tbloat | wastedpages | wastedbytes | wastedsize | iname | itups | ipages | iotta | ibloat | wastedipages | wastedibytes | wastedisize | totalwastedbytes'); 
res := array_append(res, '---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---'); 
for tmp in select '```'||snap_ts||'``` | ```'||coalesce(db,'-')||'``` | ```'||coalesce(schemaname,'-')||'``` | ```'||coalesce(tablename,'-')||'``` | '||coalesce(tups,-1)||' | '||coalesce(pages,-1)||' | '||coalesce(otta,-1)||' | '||coalesce(tbloat,-1)||' | '||coalesce(wastedpages,-1)||' | '||coalesce(wastedbytes,-1)||' | '||coalesce(wastedsize,'-')||' | '||coalesce(iname,'-')||' | '||coalesce(itups,-1)||' | '||coalesce(ipages,-1)||' | '||coalesce(iotta,-1)||' | '||coalesce(ibloat,-1)||' | '||coalesce(wastedipages,-1)||' | '||coalesce(wastedibytes,-1)||' | '||coalesce(wastedisize,'-')||' | '||coalesce(totalwastedbytes,-1) from snap_pg_table_bloat where snap_id=i_end_id order by wastedbytes desc nulls last 
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '根据浪费的字节数, 设置合适的autovacuum_vacuum_scale_factor, 大表如果频繁的有更新或删除和插入操作, 建议设置较小的autovacuum_vacuum_scale_factor来降低浪费空间.  '); 
res := array_append(res, '  '); 
res := array_append(res, '同时还需要打开autovacuum, 根据服务器的内存大小, CPU核数, 设置足够大的autovacuum_work_mem 或 autovacuum_max_workers 或 maintenance_work_mem, 以及足够小的 autovacuum_naptime.  '); 
res := array_append(res, '  '); 
res := array_append(res, '同时还需要分析是否对大数据库使用了逻辑备份pg_dump, 系统中是否经常有长SQL, 长事务. 这些都有可能导致膨胀.  '); 
res := array_append(res, '  '); 
res := array_append(res, '使用pg_reorg或者vacuum full可以回收膨胀的空间.  '); 
res := array_append(res, '  '); 
res := array_append(res, '参考: https://github.com/digoal/blog/blob/master/201504/20150429_02.md.  '); 
res := array_append(res, '  '); 
res := array_append(res, 'otta评估出的表实际需要页数, iotta评估出的索引实际需要页数.  '); 
res := array_append(res, '  '); 
res := array_append(res, 'bs数据库的块大小.  '); 
res := array_append(res, '  '); 
res := array_append(res, 'tbloat表膨胀倍数, ibloat索引膨胀倍数, wastedpages表浪费了多少个数据块, wastedipages索引浪费了多少个数据块.  '); 
res := array_append(res, '  '); 
res := array_append(res, 'wastedbytes表浪费了多少字节, wastedibytes索引浪费了多少字节.  '); 
res := array_append(res, '  '); 

res := array_append(res, '### 2. 索引膨胀分析'); 
res := array_append(res, '  '); 
res := array_append(res, 'snap_ts | db | schemaname | tablename | tups | pages | otta | tbloat | wastedpages | wastedbytes | wastedsize | iname | itups | ipages | iotta | ibloat | wastedipages | wastedibytes | wastedisize | totalwastedbytes'); 
res := array_append(res, '---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---'); 
for tmp in select '```'||snap_ts||'``` | ```'||coalesce(db,'-')||'``` | ```'||coalesce(schemaname,'-')||'``` | ```'||coalesce(tablename,'-')||'``` | '||coalesce(tups,-1)||' | '||coalesce(pages,-1)||' | '||coalesce(otta,-1)||' | '||coalesce(tbloat,-1)||' | '||coalesce(wastedpages,-1)||' | '||coalesce(wastedbytes,-1)||' | '||coalesce(wastedsize,'-')||' | '||coalesce(iname,'-')||' | '||coalesce(itups,-1)||' | '||coalesce(ipages,-1)||' | '||coalesce(iotta,-1)||' | '||coalesce(ibloat,-1)||' | '||coalesce(wastedipages,-1)||' | '||coalesce(wastedibytes,-1)||' | '||coalesce(wastedisize,'-')||' | '||coalesce(totalwastedbytes,-1) from snap_pg_index_bloat where snap_id=i_end_id order by wastedibytes desc nulls last 
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '如果索引膨胀太大, 会影响性能, 建议重建索引, create index CONCURRENTLY ... .  '); 
res := array_append(res, '  '); 

res := array_append(res, '### 3. 垃圾记录 TOP 10 表分析'); 
res := array_append(res, '  '); 
res := array_append(res, 'snap_ts | database | schemaname | tablename | n_dead_tup'); 
res := array_append(res, '---|---|---|---|---'); 
for tmp in select '```'||snap_ts||'``` | ```'||coalesce(current_database,'-')||'``` | ```'||coalesce(schemaname,'-')||'``` | ```'||coalesce(relname,'-')||'``` | '||coalesce(sum(n_dead_tup),-1) from snap_pg_dead_tup where snap_id >=i_begin_id and snap_id<=i_end_id group by snap_ts,current_database,schemaname,relname order by sum(n_dead_tup) desc nulls last limit 10 
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '通常垃圾过多, 可能是因为无法回收垃圾, 或者回收垃圾的进程繁忙或没有及时唤醒, 或者没有开启autovacuum, 或在短时间内产生了大量的垃圾.  '); 
res := array_append(res, '  '); 
res := array_append(res, '可以等待autovacuum进行处理, 或者手工执行vacuum table.  '); 
res := array_append(res, '  '); 

res := array_append(res, '### 4. 未引用的大对象分析'); 
res := array_append(res, '  '); 
res := array_append(res, 'snap_ts | database | pg_size_pretty'); 
res := array_append(res, '---|---|---|---|---'); 
for tmp in select '```'||snap_ts||'``` | ```'||coalesce(current_database,'-')||'``` | '||coalesce(pg_size_pretty(lo_bloat),'-') from snap_pg_vacuumlo where snap_id=i_end_id 
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '如果大对象没有被引用时, 建议删除, 否则就类似于内存泄露, 使用vacuumlo可以删除未被引用的大对象, 例如: vacuumlo -l 1000 $db -w或者我写的调用vacuumlo()函数.  '); 
res := array_append(res, '  '); 
res := array_append(res, '应用开发时, 注意及时删除不需要使用的大对象, 使用lo_unlink 或 驱动对应的API.  '); 
res := array_append(res, '  '); 
res := array_append(res, '参考 http://www.postgresql.org/docs/9.4/static/largeobjects.html  '); 
res := array_append(res, '  '); 

res := array_append(res, '## 四、数据库安全或潜在风险分析'); 
res := array_append(res, '  '); 

res := array_append(res, '### 1. 表年龄前100'); 
res := array_append(res, '  '); 
res := array_append(res, 'snap_ts | database | rolname | nspname | relkind | relname | age | age_remain'); 
res := array_append(res, '---|---|---|---|---|---|---|---'); 
for tmp in select '```'||snap_ts||'``` | ```'||coalesce(current_database,'-')||'``` | ```'||coalesce(rolname,'-')||'``` | ```'||coalesce(nspname,'-')||'``` | '||coalesce(relkind,'-')||' | ```'||coalesce(relname,'-')||'``` | '||coalesce(age,-1)||' | '||coalesce(age_remain,-1) from snap_pg_rel_age where snap_id=i_end_id and age_remain<500000000 order by age desc nulls last limit 100 
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '表的年龄正常情况下应该小于vacuum_freeze_table_age, 如果剩余年龄小于2亿, 建议人为干预, 将LONG SQL或事务杀掉后, 执行vacuum freeze.  '); 
res := array_append(res, '  '); 

res := array_append(res, '### 2. unlogged table和hash index'); 
res := array_append(res, '  '); 
res := array_append(res, 'snap_ts | database | rolname | nspname | relname'); 
res := array_append(res, '---|---|---|---|---'); 
for tmp in select '```'||snap_ts||'``` | ```'||coalesce(current_database,'-')||'``` | ```'||coalesce(rolname,'-')||'``` | ```'||coalesce(nspname,'-')||'``` | ```'||coalesce(relname,'-')||'```' from snap_pg_unlogged_table where snap_id=i_end_id 
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, 'snap_ts | database | idx'); 
res := array_append(res, '---|---|---'); 
for tmp in select '```'||snap_ts||'``` | ```'||coalesce(current_database,'-')||'``` | ```'||coalesce(pg_get_indexdef,'-')||'```' from snap_pg_hash_idx where snap_id=i_end_id 
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, 'unlogged table和hash index不记录XLOG, 无法使用流复制或者log shipping的方式复制到standby节点, 如果在standby节点执行某些SQL, 可能导致报错或查不到数据.  '); 
res := array_append(res, '  '); 
res := array_append(res, '在数据库CRASH后无法修复unlogged table和hash index, 不建议使用.  '); 
res := array_append(res, '  '); 
res := array_append(res, 'PITR对unlogged table和hash index也不起作用.  '); 
res := array_append(res, '  '); 

res := array_append(res, '### 3. 剩余可使用次数不足1000万次的序列检查'); 
res := array_append(res, '  '); 
res := array_append(res, 'snap_ts | database | rolname | nspname | relname | times_remain'); 
res := array_append(res, '---|---|---|---|---|---'); 
for tmp in select '```'||snap_ts||'``` | ```'||coalesce(v_datname,'-')||'``` | ```'||coalesce(v_role,'-')||'``` | ```'||coalesce(v_nspname,'-')||'``` | ```'||coalesce(v_relname,'-')||'``` | '||coalesce(v_times_remain,-1) from snap_pg_seq_deadline where snap_id=i_end_id 
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '序列剩余使用次数到了之后, 将无法使用, 报错, 请开发人员关注.  '); 
res := array_append(res, '  '); 

res := array_append(res, '### 4. 锁等待分析'); 
res := array_append(res, '  '); 
res := array_append(res, 'snap_ts | locktype | r_mode | r_user | r_db | relation | r_pid | r_page | r_tuple | r_xact_start | r_query_start | r_locktime | r_query | w_mode | w_pid | w_page | w_tuple | w_xact_start | w_query_start | w_locktime | w_query'); 
res := array_append(res, '---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---'); 
for tmp in select '```'||snap_ts||'``` | '||coalesce(locktype,'-')||' | '||coalesce(r_mode,'-')||' | ```'||coalesce(r_user,'-')||'``` | ```'||coalesce(r_db,'-')||'``` | '||coalesce(relation,-1)||' | '||coalesce(r_pid,-1)||' | '||coalesce(r_page,-1)||' | '||coalesce(r_tuple,-1)||' | ```'||coalesce(r_xact_start,'1970-01-01')||'``` | ```'||coalesce(r_query_start,'1970-01-01')||'``` | ```'||coalesce(r_locktime,'0 s')||'``` | ```'||coalesce(replace(regexp_replace(r_query,'\n',' ','g'), '|', '&#124;'),'-')||'``` | '||coalesce(w_mode,'-')||' | '||coalesce(w_pid,-1)||' | '||coalesce(w_page,-1)||' | '||coalesce(w_tuple,-1)||' | ```'||coalesce(w_xact_start,'1970-01-01')||'``` | ```'||coalesce(w_query_start,'1970-01-01')||'``` | ```'||coalesce(w_locktime,'0 s')||'``` | ```'||coalesce(replace(regexp_replace(w_query,'\n',' ','g'), '|', '&#124;'),'-')||'```' from snap_pg_waiting where snap_id>=i_begin_id and snap_id<=i_end_id order by snap_ts,w_locktime desc nulls last  
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '锁等待状态, 反映业务逻辑的问题或者SQL性能有问题, 建议深入排查持锁的SQL.  '); 
res := array_append(res, '  '); 

reset search_path;
return query select t from unnest(res) t1(t);
end;
$$ language plpgsql strict;





reset search_path;
end;
