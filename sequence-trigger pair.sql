declare
cursor  tbl_constraint is  --joined 2 data dictionary (user table columns + user constraint columns) to add data type 
 select data_type , con.constraint_name , con.column_name, con.table_name 
from user_tab_cols cols ,  USER_CONS_COLUMNS  con
where lower(data_type) ='number' and upper( constraint_name) like '%PK%' and --we filtered to get only columns pk constraints and of type number
COLS.TABLE_NAME=CON.TABLE_NAME and COLS.COLUMN_NAME = CON.COLUMN_NAME;
        
cursor seq_tbl is           -- cursor to loop over each sequence name in hr schema 
        select* from user_sequences;

seq_name varchar2(200);
max_id varchar2(200);
v_max_id number(8,2);
trig_name varchar2(200);
begin 
        for rec_PK in tbl_constraint loop
                  seq_name := rec_PK.table_name||'_seq'; -- create sequence name based on table name 
                  trig_name := rec_PK.table_name||'_trigger'; -- create trigger name  based on table name
            for seq_rec in seq_tbl loop
              
                if seq_rec.sequence_name like upper(seq_name) then 
                execute immediate 'DROP SEQUENCE '||seq_rec.sequence_name; -- if the new sequence name  is already existed then drop it from sequence table
                end if;
                
           end loop;
         
          max_id := 'SELECT MAX ('||rec_pk.column_name||') +1 
                          FROM '||rec_pk.table_name; 
                 execute immediate max_id  into v_max_id;
          execute immediate 'CREATE SEQUENCE '||seq_name||' START WITH '||v_max_id||' INCREMENT BY 1';
          
      execute immediate 'create or replace trigger '||trig_name||' before insert  on '||rec_PK.table_name||'  REFERENCING NEW AS New OLD AS Old  for each row
       begin 
       :new.'||rec_PK.column_name|| ' := ' ||seq_name||'.nextval;
       end;';  
       end loop;
            
          
end;

----------------------------------------------------test-----------------------------------------------------
insert into departments(DEPARTMENT_ID, DEPARTMENT_NAME, LOCATION_ID, MANAGER_ID) values
(126,'IT_ORG',1000,120);
insert into employees ( DEPARTMENT_ID, EMAIL, EMPLOYEE_ID,  HIRE_DATE, JOB_ID, LAST_NAME, MANAGER_ID, SALARY) values
(500,'emp25@telcom.com',264,sysdate,'IT_PROG','ENG MO',101,20000);
insert into locations(location_id,street_address,postal_code,city,state_province,country_id) values
(4000  ,  'giza 65'  ,  '19635'  , 'cairo' ,   'giza'  ,  'EG');
