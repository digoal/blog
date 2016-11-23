begin;

-- 生成全局、库级报告 
set search_path=__pg_stats__,public,pg_catalog; 



-- 生成全局报告 
-- 指定ID范围 
create or replace function snap_report_global(i_begin_id int8, i_end_id int8, i_level text default 'global') returns setof text as $$ 

declare 
  v_begin_ts timestamp; 
  v_end_ts timestamp; 
  res text[]; 
  tmp text; 
begin 
  set search_path=__pg_stats__,public,pg_catalog; 

-- 判断 ID 是否存在
perform 1 from snap_list where id = i_begin_id and snap_level=i_level ;
if not found then
  raise notice '% snapshot begin_id : % not exist.', i_level, i_begin_id;
  return;
end if;

perform 1 from snap_list where id = i_end_id and snap_level=i_level ;
if not found then
  raise notice '% snapshot end_id : % not exist.', i_level, i_end_id;
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
res := array_append(res, '  '); 
res := array_append(res, 'database | role | snap_ts | setconfig'); 
res := array_append(res, '---|---|---|---'); 
for tmp in select '```'||datname||'``` | ```'||rolname||'``` | ```'||snap_ts||'``` | '||setconfig::text from snap_pg_db_role_setting t1, pg_database t2, pg_authid t3 where t1.setdatabase=t2.oid and t1.setrole=t3.oid and t1.snap_id >=i_begin_id and t1.snap_id<=i_end_id order by datname,rolname,snap_ts  
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '定制参数需要关注, 优先级高于数据库的启动参数和配置文件中的参数, 特别是排错时需要关注.  '); 
res := array_append(res, '  '); 

res := array_append(res, '## 二、数据库空间使用分析'); 
res := array_append(res, '  '); 

res := array_append(res, '### 1. 表空间使用情况'); 
res := array_append(res, '  '); 
res := array_append(res, 'tablespace | tbs_location | snap_ts | size'); 
res := array_append(res, '---|---|---|---'); 
for tmp in select spcname||' | ```'||pg_tablespace_location||'``` | ```'||snap_ts||'``` | '||pg_size_pretty from snap_pg_tbs_size where snap_id >=i_begin_id and snap_id<=i_end_id order by spcname,pg_tablespace_location,snap_ts 
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '注意检查表空间所在文件系统的剩余空间, (默认表空间在$PGDATA/base目录下), IOPS分配是否均匀, OS的sysstat包可以观察IO使用率.  '); 
res := array_append(res, '  '); 

res := array_append(res, '### 2. 数据库使用情况'); 
res := array_append(res, '  '); 
res := array_append(res, 'database | snap_ts | size'); 
res := array_append(res, '---|---|---'); 
for tmp in select '```'||datname||'``` | ```'||snap_ts||'``` | '||pg_size_pretty from snap_pg_db_size where snap_id >=i_begin_id and snap_id<=i_end_id order by datname, snap_ts
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

res := array_append(res, '### 1. 活跃度'); 
res := array_append(res, '  '); 
res := array_append(res, 'state | snap_ts | connections'); 
res := array_append(res, '---|---|---'); 
for tmp in select state||' | ```'||snap_ts||'``` | '||count from snap_pg_stat_activity where snap_id >=i_begin_id and snap_id<=i_end_id order by state, snap_ts
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '如果active状态很多, 说明数据库比较繁忙. 如果idle in transaction很多, 说明业务逻辑设计可能有问题. 如果idle很多, 可能使用了连接池, 并且可能没有自动回收连接到连接池的最小连接数.  '); 
res := array_append(res, '  '); 

res := array_append(res, '### 2. 剩余连接数'); 
res := array_append(res, '  '); 
res := array_append(res, 'snap_ts | max_enabled_connections | used | res_for_super | res_for_normal'); 
res := array_append(res, '---|---|---|---|---'); 
for tmp in select '```'||snap_ts||'``` | '||max_conn||' | '||used||' | '||res_for_super||' | '||res_for_normal from snap_pg_conn_stats where snap_id >=i_begin_id and snap_id<=i_end_id order by snap_ts 
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '给超级用户和普通用户设置足够的连接, 以免不能登录数据库.  '); 
res := array_append(res, '  '); 

res := array_append(res, '### 3. 用户连接数限制'); 
res := array_append(res, '  '); 
res := array_append(res, 'rolename | snap_ts | conn_limit | connects'); 
res := array_append(res, '---|---|---|---'); 
for tmp in select '```'||rolname||'``` | ```'||snap_ts||'``` | '||rolconnlimit||' | '||connects from snap_pg_role_conn_limit where snap_id >=i_begin_id and snap_id<=i_end_id order by rolname, snap_ts  
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '给用户设置足够的连接数, alter role ... CONNECTION LIMIT .  '); 
res := array_append(res, '  '); 

res := array_append(res, '### 4. 数据库连接限制'); 
res := array_append(res, '  '); 
res := array_append(res, 'database | snap_ts | conn_limit | connects'); 
res := array_append(res, '---|---|---|---'); 
for tmp in select '```'||datname||'``` | ```'||snap_ts||'``` | '||datconnlimit||' | '||connects from snap_pg_db_conn_limit where snap_id >=i_begin_id and snap_id<=i_end_id order by datname, snap_ts  
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
res := array_append(res, 'rolename | database | calls | total_ms | min_ms | max_ms | mean_ms | stddev_ms | rows | shared_blks_hit | shared_blks_read | shared_blks_dirtied | shared_blks_written | local_blks_hit | local_blks_read | local_blks_dirtied | shared_blks_written | temp_blks_read | temp_blks_written | blk_read_time | blk_write_time | query'); 
res := array_append(res, '---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---'); 
for tmp in select '```'||rolname||'``` | ```'||datname||'``` | '||sum(calls)||' | '||sum(total_time)||' | '||avg(min_time)||' | '||avg(max_time)||' | '||avg(mean_time)||' | '||avg(stddev_time)||' | '||sum(rows)||' | '||sum(shared_blks_hit)||' | '||sum(shared_blks_read)||' | '||sum(shared_blks_dirtied)||' | '||sum(shared_blks_written)||' | '||sum(local_blks_hit)||' | '||sum(local_blks_read)||' | '||sum(local_blks_dirtied)||' | '||sum(local_blks_written)||' | '||sum(temp_blks_read)||' | '||sum(temp_blks_written)||' | '||sum(blk_read_time)||' | '||sum(blk_write_time)||' |  ```'||replace(regexp_replace(query,'\n',' ','g'), '|', '&#124;')||'```' from snap_pg_cputime_topsql where snap_id >=i_begin_id and snap_id<=i_end_id group by rolname,datname,query  
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '检查SQL是否有优化空间, 配合auto_explain插件在csvlog中观察LONG SQL的执行计划是否正确.  '); 
res := array_append(res, '  '); 

res := array_append(res, '### 2. 数据库统计信息, 回滚比例, 命中比例, 数据块读写时间, 死锁, 复制冲突'); 
res := array_append(res, '  '); 
res := array_append(res, 'database | snap_ts | rollback_ratio | hit_ratio | blk_read_time | blk_write_time | conflicts | deadlocks'); 
res := array_append(res, '---|---|---|---|---|---|---|---'); 
for tmp in select '```'||datname||'``` | ```'||snap_ts||'``` | '||rollback_ratio||' | '||hit_ratio||' | '||blk_read_time||' | '||blk_write_time||' | '||conflicts||' | '||deadlocks from snap_pg_stat_database where snap_id >=i_begin_id and snap_id<=i_end_id order by datname, snap_ts  
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
for tmp in select sum(checkpoints_timed)||' | '||sum(checkpoints_req)||' | '||sum(checkpoint_write_time)||' | '||sum(checkpoint_sync_time)||' | '||sum(buffers_checkpoint)||' | '||sum(buffers_clean)||' | '||sum(maxwritten_clean)||' | '||sum(buffers_backend)||' | '||sum(buffers_backend_fsync)||' | '||sum(buffers_alloc) from snap_pg_stat_bgwriter where snap_id >=i_begin_id and snap_id<=i_end_id  
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
for tmp in select archived_count||' | '||last_archived_wal||' | '||last_archived_time||' | '||failed_count||' | '||last_failed_wal||' | '||last_failed_time||' | '||pg_xlogfile_name(pg_current_xlog_insert_location()) from snap_pg_stat_archiver where snap_id=i_end_id   
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, 'last_archived_wal和now_insert_xlog_file相差很多, 说明失败的归档很多.  '); 
res := array_append(res, '  '); 

res := array_append(res, '## 五、数据库年龄分析'); 
res := array_append(res, '  '); 

res := array_append(res, '### 1. 数据库年龄'); 
res := array_append(res, '  '); 
res := array_append(res, 'database | snap_ts | age | age_remain'); 
res := array_append(res, '---|---|---|---'); 
for tmp in select '```'||datname||'``` | ```'||snap_ts||'``` | '||age||' | '||age_remain from snap_pg_database_age where snap_id >=i_begin_id and snap_id<=i_end_id order by datname,snap_ts   
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '数据库的年龄正常情况下应该小于vacuum_freeze_table_age, 如果剩余年龄小于2亿, 建议人为干预, 将LONG SQL或事务杀掉后, 执行vacuum freeze.  '); 
res := array_append(res, '  '); 

res := array_append(res, '### 2. 长事务, 2PC'); 
res := array_append(res, '  '); 
res := array_append(res, 'snap_ts | database | user | query | xact_start | xact_duration | query_start | query_duration | state'); 
res := array_append(res, '---|---|---|---|---|---|---|---|---'); 
for tmp in select '```'||snap_ts||'``` | ```'||datname||'``` | ```'||usename||'``` | ```'||replace(regexp_replace(query,'\n',' ','g'), '|', '&#124;')||'``` | '||xact_start||' | '||xact_duration||' | '||query_start||' | '||query_duration||' | '||state from snap_pg_long_xact where snap_id >=i_begin_id and snap_id<=i_end_id order by snap_ts,datname,usename,query     
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, 'snap_ts | name | statement | prepare_time | duration | parameter_types | from_sql'); 
res := array_append(res, '---|---|---|---|---|---|---|---|---'); 
for tmp in select '```'||snap_ts||'``` | ```'||name||'``` | ```'||replace(regexp_replace(statement,'\n',' ','g'), '|', '&#124;')||'``` | '||prepare_time||' | '||duration||' | '||parameter_types::text||' | '||from_sql from snap_pg_long_2pc where snap_id >=i_begin_id and snap_id<=i_end_id order by snap_ts,prepare_time,name,statement 
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '长事务过程中产生的垃圾, 无法回收, 建议不要在数据库中运行LONG SQL, 或者错开DML高峰时间去运行LONG SQL. 2PC事务一定要记得尽快结束掉, 否则可能会导致数据库膨胀.  '); 
res := array_append(res, '  '); 
res := array_append(res, '参考: http://blog.163.com/digoal@126/blog/static/1638770402015329115636287/   '); 
res := array_append(res, '  '); 

res := array_append(res, '## 六、数据库安全或潜在风险分析'); 
res := array_append(res, '  '); 

res := array_append(res, '### 1. 用户密码到期时间'); 
res := array_append(res, '  '); 
res := array_append(res, 'snap_ts | rolname | rolvaliduntil'); 
res := array_append(res, '---|---|---|---'); 
for tmp in select '```'||snap_ts||'``` | ```'||rolname||'``` | '||rolvaliduntil from snap_pg_user_deadline where snap_id=i_end_id order by snap_ts,rolname   
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '到期后, 用户将无法登陆, 记得修改密码, 同时将密码到期时间延长到某个时间或无限时间, alter role ... VALID UNTIL ''timestamp''.  '); 
res := array_append(res, '  '); 

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
begin 
  set search_path=__pg_stats__,public,pg_catalog; 

-- 判断 ID 是否存在
perform 1 from snap_list where id = i_begin_id and snap_level=i_level ;
if not found then
  raise notice '% snapshot begin_id : % not exist.', i_level, i_begin_id;
  return;
end if;

perform 1 from snap_list where id = i_end_id and snap_level=i_level ;
if not found then
  raise notice '% snapshot end_id : % not exist.', i_level, i_end_id;
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
res := array_append(res, 'calls | total_ms | min_ms | max_ms | mean_ms | stddev_ms | rows | shared_blks_hit | shared_blks_read | shared_blks_dirtied | shared_blks_written | local_blks_hit | local_blks_read | local_blks_dirtied | shared_blks_written | temp_blks_read | temp_blks_written | blk_read_time | blk_write_time | query'); 
res := array_append(res, '---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---'); 
for tmp in select sum(calls)||' | '||sum(total_time)||' | '||avg(min_time)||' | '||avg(max_time)||' | '||avg(mean_time)||' | '||avg(stddev_time)||' | '||sum(rows)||' | '||sum(shared_blks_hit)||' | '||sum(shared_blks_read)||' | '||sum(shared_blks_dirtied)||' | '||sum(shared_blks_written)||' | '||sum(local_blks_hit)||' | '||sum(local_blks_read)||' | '||sum(local_blks_dirtied)||' | '||sum(local_blks_written)||' | '||sum(temp_blks_read)||' | '||sum(temp_blks_written)||' | '||sum(blk_read_time)||' | '||sum(blk_write_time)||' | ```'||replace(regexp_replace(query,'\n',' ','g'), '|', '&#124;')||'```' from snap_pg_stat_statements where snap_id >=i_begin_id and snap_id<=i_end_id and dbid=(select oid from pg_database where datname=current_database()) group by query order by sum(total_time) desc limit 10
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
for tmp in select '```'||current_database||'``` | ```'||nspname||'``` | ```'||relname||'``` | '||relkind||' | '||pg_size_pretty(avg(pg_relation_size))||' | '||sum(seq_scan)||' | '||sum(seq_tup_read)||' | '||coalesce(sum(idx_scan),0)||' | '||coalesce(sum(idx_tup_fetch),0)||' | '||sum(n_tup_ins)||' | '||sum(n_tup_upd)||' | '||sum(n_tup_del)||' | '||sum(n_tup_hot_upd)||' | '||avg(n_live_tup)||' | '||avg(n_dead_tup) from snap_pg_db_rel_size where snap_id >=i_begin_id and snap_id<=i_end_id group by current_database,nspname,relname,relkind order by avg(pg_relation_size) desc limit 10  
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
for tmp in select '```'||current_database||'``` | ```'||nspname||'``` | ```'||relname||'``` | '||relkind||' | '||pg_size_pretty(avg(pg_relation_size))||' | '||sum(seq_scan)||' | '||sum(seq_tup_read)||' | '||coalesce(sum(idx_scan),0)||' | '||coalesce(sum(idx_tup_fetch),0)||' | '||sum(n_tup_ins)||' | '||sum(n_tup_upd)||' | '||sum(n_tup_del)||' | '||sum(n_tup_hot_upd)||' | '||avg(n_live_tup)||' | '||avg(n_dead_tup) from snap_pg_db_rel_size where snap_id >=i_begin_id and snap_id<=i_end_id group by current_database,nspname,relname,relkind order by avg(case when seq_tup_read=0 then 1 else seq_tup_read end/case when seq_scan=0 then 1 else seq_scan end) desc limit 10  
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
for tmp in select '```'||current_database||'``` | ```'||schemaname||'``` | ```'||relname||'``` | '||sum(heap_blks_read)||' | '||sum(heap_blks_hit)||' | '||sum(idx_blks_read)||' | '||sum(idx_blks_hit)||' | '||sum(toast_blks_read)||' | '||sum(toast_blks_hit)||' | '||sum(tidx_blks_read)||' | '||sum(tidx_blks_hit) from snap_pg_statio_all_tables where snap_id >=i_begin_id and snap_id<=i_end_id group by current_database,schemaname,relname order by sum(heap_blks_read+idx_blks_read+toast_blks_read+tidx_blks_read) desc limit 10  
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
for tmp in select '```'||current_database||'``` | ```'||schemaname||'``` | ```'||relname||'``` | '||sum(heap_blks_read)||' | '||sum(heap_blks_hit)||' | '||sum(idx_blks_read)||' | '||sum(idx_blks_hit)||' | '||sum(toast_blks_read)||' | '||sum(toast_blks_hit)||' | '||sum(tidx_blks_read)||' | '||sum(tidx_blks_hit) from snap_pg_statio_all_tables where snap_id >=i_begin_id and snap_id<=i_end_id group by current_database,schemaname,relname order by sum(heap_blks_hit+idx_blks_hit+toast_blks_hit+tidx_blks_hit+heap_blks_read+idx_blks_read+toast_blks_read+tidx_blks_read) desc limit 10  
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
for tmp in select '```'||current_database||'``` | ```'||schemaname||'``` | ```'||relname||'``` | ```'||indexrelname||'``` | '||sum(idx_blks_read)||' | '||sum(idx_blks_hit) from snap_pg_statio_all_indexes where snap_id >=i_begin_id and snap_id<=i_end_id group by current_database,schemaname,relname,indexrelname order by sum(idx_blks_read) desc limit 10  
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
for tmp in select '```'||current_database||'``` | ```'||schemaname||'``` | ```'||relname||'``` | ```'||indexrelname||'``` | '||sum(idx_blks_read)||' | '||sum(idx_blks_hit) from snap_pg_statio_all_indexes where snap_id >=i_begin_id and snap_id<=i_end_id group by current_database,schemaname,relname,indexrelname order by sum(idx_blks_read+idx_blks_hit) desc limit 10  
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
for tmp in select '```'||current_database||'``` | ```'||schemaname||'``` | ```'||relname||'``` | ```'||indexrelname||'``` | '||sum(idx_scan)||' | '||sum(idx_tup_read)||' | '||sum(idx_tup_fetch)||' | '||pg_size_pretty(avg(pg_relation_size)) from snap_pg_notused_indexes where snap_id >=i_begin_id and snap_id<=i_end_id group by current_database,schemaname,relname,indexrelname order by sum(idx_scan) limit 10  
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
for tmp in select '```'||current_database||'``` | ```'||nspname||'``` | ```'||relname||'``` | '||pg_size_pretty(avg(pg_relation_size))||' | '||max(idx_cnt) from snap_pg_many_indexes_rel where snap_id >=i_begin_id and snap_id<=i_end_id group by current_database,nspname,relname order by max(idx_cnt) desc limit 20  
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
for tmp in select '```'||snap_ts||'``` | ```'||current_database||'``` | '||this_buk_no||' | '||rels_in_this_buk||' | '||buk_min||' | '||buk_max from snap_pg_rel_space_bucket where snap_id >=i_begin_id and snap_id<=i_end_id order by snap_ts,current_database,this_buk_no 
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
for tmp in select '```'||snap_ts||'``` | ```'||db||'``` | ```'||schemaname||'``` | ```'||tablename||'``` | '||tups||' | '||pages||' | '||otta||' | '||tbloat||' | '||wastedpages||' | '||wastedbytes||' | '||wastedsize||' | '||iname||' | '||itups||' | '||ipages||' | '||iotta||' | '||ibloat||' | '||wastedipages||' | '||wastedibytes||' | '||wastedisize||' | '||totalwastedbytes from snap_pg_table_bloat where snap_id=i_end_id order by wastedbytes desc 
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
res := array_append(res, '参考: http://blog.163.com/digoal@126/blog/static/1638770402015329115636287/.  '); 
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
for tmp in select '```'||snap_ts||'``` | ```'||db||'``` | ```'||schemaname||'``` | ```'||tablename||'``` | '||tups||' | '||pages||' | '||otta||' | '||tbloat||' | '||wastedpages||' | '||wastedbytes||' | '||wastedsize||' | '||iname||' | '||itups||' | '||ipages||' | '||iotta||' | '||ibloat||' | '||wastedipages||' | '||wastedibytes||' | '||wastedisize||' | '||totalwastedbytes from snap_pg_index_bloat where snap_id=i_end_id order by wastedibytes desc 
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
for tmp in select '```'||snap_ts||'``` | ```'||current_database||'``` | ```'||schemaname||'``` | ```'||relname||'``` | '||sum(n_dead_tup) from snap_pg_dead_tup where snap_id >=i_begin_id and snap_id<=i_end_id group by snap_ts,current_database,schemaname,relname order by sum(n_dead_tup) desc limit 10 
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
for tmp in select '```'||current_database||'``` | '||pg_size_pretty(sum(lo_bloat)) from snap_pg_vacuumlo where snap_id >=i_begin_id and snap_id<=i_end_id group by current_database 
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
for tmp in select '```'||snap_ts||'``` | ```'||current_database||'``` | ```'||rolname||'``` | ```'||nspname||'``` | '||relkind||' | ```'||relname||'``` | '||age||' | '||age_remain from snap_pg_rel_age where snap_id=i_end_id and age_remain<500000000 order by age desc limit 100 
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
for tmp in select '```'||snap_ts||'``` | ```'||current_database||'``` | ```'||rolname||'``` | ```'||nspname||'``` | ```'||relname||'```' from snap_pg_unlogged_table where snap_id=i_end_id 
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, 'snap_ts | database | idx'); 
res := array_append(res, '---|---|---'); 
for tmp in select '```'||snap_ts||'``` | ```'||current_database||'``` | ```'||pg_get_indexdef||'```' from snap_pg_hash_idx where snap_id=i_end_id 
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
for tmp in select '```'||snap_ts||'``` | ```'||v_datname||'``` | ```'||v_role||'``` | ```'||v_nspname||'``` | ```'||v_relname||'``` | '||v_times_remain from snap_pg_seq_deadline where snap_id=i_end_id 
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
for tmp in select '```'||snap_ts||'``` | '||locktype||' | '||r_mode||' | '||r_user||' | '||r_db||' | '||relation||' | '||r_pid||' | '||r_page||' | '||r_tuple||' | '||r_xact_start||' | '||r_query_start||' | '||r_locktime||' | ```'||replace(regexp_replace(r_query,'\n',' ','g'), '|', '&#124;')||'``` | '||w_mode||' | '||w_pid||' | '||w_page||' | '||w_tuple||' | '||w_xact_start||' | '||w_query_start||' | '||w_locktime||' | ```'||replace(regexp_replace(w_query,'\n',' ','g'), '|', '&#124;')||'```' from snap_pg_waiting where snap_id>=i_begin_id and snap_id<=i_end_id order by snap_ts,w_locktime desc  
loop 
  res := array_append(res, tmp); 
end loop; 
res := array_append(res, '  '); 
res := array_append(res, '#### 建议'); 
res := array_append(res, '  '); 
res := array_append(res, '锁等待状态, 反映业务逻辑的问题或者SQL性能有问题, 建议深入排查持锁的SQL.  '); 
res := array_append(res, '  '); 

return query select t from unnest(res) t1(t);
end;
$$ language plpgsql strict;

end;
