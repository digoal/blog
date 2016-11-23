set search_path=__pg_stats__,public,pg_catalog; 

begin;
-- 查询库级、全局快照
select * from snap_list order by id;


-- 清理库级、全局快照
-- 3种清理快照的方法

set search_path=__pg_stats__,public,pg_catalog; 

create or replace function snap_delete_data(i_snap_id int8) returns void as $$ 
declare
begin
  set search_path=__pg_stats__,public,pg_catalog; 

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

end;
$$ language plpgsql strict; 

-- 删除指定snap_id以前的快照数据
create or replace function snap_delete(i_snap_id int8) returns void as $$ 
declare
  v_snap_id int8;
begin
  set search_path=__pg_stats__,public,pg_catalog; 
  
  for v_snap_id in select id from snap_list where id<i_snap_id order by id 
  loop
    perform snap_delete_data(v_snap_id);
  end loop;

end;
$$ language plpgsql strict;


-- 删除指定时间以前的快照数据
create or replace function snap_delete(i_snap_ts timestamp) returns void as $$ 
declare
  v_snap_id int8;
begin
  set search_path=__pg_stats__,public,pg_catalog; 

  for v_snap_id in select id from snap_list where snap_ts<i_snap_ts order by id 
  loop
    perform snap_delete_data(v_snap_id);
  end loop;

end;
$$ language plpgsql strict;


-- 保留最近几个快照
create or replace function snap_delete(i_reserved int) returns void as $$ 
declare
  v_snap_id int8;
begin
  set search_path=__pg_stats__,public,pg_catalog; 

  if i_reserved < 1 then
    raise notice 'You must give a value >=1';
    return;
  end if;

  for v_snap_id in select id from snap_list where id < (select id from snap_list order by id desc limit 1 offset 2) order by id 
  loop
    perform snap_delete_data(v_snap_id);
  end loop;

end;
$$ language plpgsql strict;

end;
