# PL-SQL-Advanced-
Using PLSQL Dynamic SQL ____ create dynamic Sequence / Trigger pair for each table in your schema, don't forget to drop all sequences and replace all triggers dynamically / your sequence start value should start with the max id + 1 for each table according to it's data - increment by 1 for each table.
___________
Using PLSQL Dynamic SQL
____
create dynamic Sequence / Trigger pair for each table in your schema, don't forget to drop all sequences and replace all triggers dynamically / your sequence start value should start with the max id + 1 for each table according to it's data - increment by 1 for each table.
1.	we needed a cursor to loop over all sequence names to drop the sequence if it’s already existing and replaced with the new one that named as ‘table name _seq’
2.	then, comes the creation of the sequence, we needed to autoincrement only the primary key column of type ‘number’ and “starting from the max”  
3.	 we needed the second cursor to loop over each primary column in each table ..so we joined 2 data dictionary (user_tab_cols & user_cons_columns) to get the name of each primary column of type number and their table name. 
4.	Then we added a trigger to be auto compiled each time the user inserts a new record in any of the tables 
