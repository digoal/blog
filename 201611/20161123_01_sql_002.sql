begin;
-- 创建全局快照
set search_path=__pg_stats__,public,pg_catalog; 


create or replace function snap_global(erase_stats boolean default true) returns void as $_$
declare
 snap_id int8;
 ts timestamp := clock_timestamp();

begin
set search_path=__pg_stats__,public,pg_catalog; 

-- 库级, 快照清单
raise notice '%', ts; 
insert into snap_list (snap_ts, snap_level) values (ts, 'global') returning id into snap_id; 

-- 全局, pg_db_role_setting  
insert into snap_pg_db_role_setting select snap_id, ts snap_ts, * from pg_db_role_setting; 

-- 全局, 表空间占用  
insert into snap_pg_tbs_size select snap_id, ts snap_ts, spcname, case when pg_tablespace_location(oid)='' then '-' else pg_tablespace_location(oid) end, pg_size_pretty(pg_tablespace_size(oid)) from pg_tablespace order by pg_tablespace_size(oid) desc;  

-- 全局, 数据库空间占用  
insert into snap_pg_db_size select snap_id, ts snap_ts, datname, pg_size_pretty(pg_database_size(oid)) from pg_database order by pg_database_size(oid) desc;  

-- 全局, 当前活跃度  
insert into snap_pg_stat_activity select snap_id, ts snap_ts, state, count(*) from pg_stat_activity group by 1,2,3;  

-- 全局, 总剩余连接数  
insert into snap_pg_conn_stats select snap_id, ts snap_ts, max_conn,used,res_for_super,max_conn-used-res_for_super res_for_normal from (select count(*) used from pg_stat_activity) t1,(select setting::int res_for_super from pg_settings where name=$$superuser_reserved_connections$$) t2,(select setting::int max_conn from pg_settings where name=$$max_connections$$) t3; 

-- 全局, 用户连接数限制  
insert into snap_pg_role_conn_limit select snap_id, ts snap_ts, a.rolname,a.rolconnlimit,b.connects from pg_authid a,(select usename,count(*) connects from pg_stat_activity group by usename) b where a.rolname=b.usename order by b.connects desc;  

-- 全局, 数据库连接限制   
insert into snap_pg_db_conn_limit select snap_id, ts snap_ts, a.datname, a.datconnlimit, b.connects from pg_database a,(select datname,count(*) connects from pg_stat_activity group by datname) b where a.datname=b.datname order by b.connects desc;  

-- 全局, TOP CPUTIME 10 SQL 
insert into snap_pg_cputime_topsql select snap_id, ts snap_ts, c.rolname,b.datname,a.total_time/a.calls per_call_time,a.* from pg_stat_statements a,pg_database b,pg_authid c where a.userid=c.oid and a.dbid=b.oid order by a.total_time desc limit 10;  

-- 全局, 数据库统计信息, 回滚比例, 命中比例, 数据块读写时间, 死锁, 复制冲突 
insert into snap_pg_stat_database select snap_id, ts snap_ts, datname,round(100*(xact_rollback::numeric/(case when xact_commit > 0 then xact_commit else 1 end + xact_rollback)),2)||$$ %$$ rollback_ratio, round(100*(blks_hit::numeric/(case when blks_read>0 then blks_read else 1 end + blks_hit)),2)||$$ %$$ hit_ratio, blk_read_time, blk_write_time, conflicts, deadlocks from pg_stat_database; 

-- 全局, 检查点, bgwriter 统计信息 
insert into snap_pg_stat_bgwriter select snap_id, ts snap_ts,  * from pg_stat_bgwriter; 

-- 全局, archiver 统计信息 
insert into snap_pg_stat_archiver select snap_id, ts snap_ts,  * from pg_stat_archiver; 

-- 全局, 数据库年龄 
insert into snap_pg_database_age select snap_id, ts snap_ts, datname,age(datfrozenxid),2^31-age(datfrozenxid) age_remain from pg_database order by age(datfrozenxid) desc;

-- 全局, 长事务, 2PC 
insert into snap_pg_long_xact select snap_id, ts snap_ts, datname,usename,query,xact_start,ts-xact_start xact_duration,query_start,ts-query_start query_duration,state from pg_stat_activity where state<>$$idle$$ and (backend_xid is not null or backend_xmin is not null) and ts-xact_start > interval $$30 min$$ order by xact_start;

insert into snap_pg_long_2pc select snap_id, ts snap_ts, name,statement,prepare_time,ts-prepare_time,parameter_types,from_sql from pg_prepared_statements where ts-prepare_time > interval $$30 min$$ order by prepare_time; 

-- 全局, 用户密码到期时间 
insert into snap_pg_user_deadline select snap_id, ts snap_ts, rolname,rolvaliduntil from pg_authid order by rolvaliduntil;

-- 重置统计信息
if erase_stats then 
  perform pg_stat_reset_shared('bgwriter');
  perform pg_stat_reset_shared('archiver');
  perform pg_stat_statements_reset();
end if;

end;
$_$ language plpgsql strict;






-- 创建库级快照
set search_path=__pg_stats__,public,pg_catalog; 

create or replace function snap_database(erase_stats boolean default true) returns void as $_$
declare
 snap_id int8;
 ts timestamp := clock_timestamp();

begin
set search_path=__pg_stats__,public,pg_catalog; 

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
insert into snap_pg_dead_tup select snap_id, ts snap_ts, current_database(),schemaname,relname,n_dead_tup from pg_stat_all_tables where n_live_tup>0 and n_dead_tup/n_live_tup>0.2 and schemaname not in ($$pg_toast$$,$$pg_catalog$$) order by n_dead_tup desc limit 10;

-- 库级, 表年龄前100
insert into snap_pg_rel_age select snap_id, ts snap_ts, current_database(),rolname,nspname,relkind,relname,age(relfrozenxid),2^31-age(relfrozenxid) age_remain from pg_authid t1 join pg_class t2 on t1.oid=t2.relowner join pg_namespace t3 on t2.relnamespace=t3.oid where t2.relkind in ($$t$$,$$r$$) order by age(relfrozenxid) desc limit 100;


-- 库级, unlogged table 和 哈希索引
insert into snap_pg_unlogged_table select snap_id, ts snap_ts, current_database(),t3.rolname,t2.nspname,t1.relname from pg_class t1,pg_namespace t2,pg_authid t3 where t1.relnamespace=t2.oid and t1.relowner=t3.oid and t1.relpersistence=$$u$$;

insert into snap_pg_hash_idx select snap_id, ts snap_ts, current_database(),pg_get_indexdef(oid) from pg_class where relkind=$$i$$ and pg_get_indexdef(oid) ~ $$USING hash$$;

-- 库级, 剩余可使用次数不足1000万次的序列检查
insert into snap_pg_seq_deadline select snap_id, ts snap_ts, * from f() where v_times_remain is not null and v_times_remain < 10240000 order by v_times_remain limit 10;

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

end;
$_$ language plpgsql strict;

end;
