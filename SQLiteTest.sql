/*
 * Example of a scrpit for sqlite3 database
 * farley balasuriya - 16:10 05.05.2005
 *
 * note: run with 'sqlite3 test.db < SQLiteTest.sql'
 *
 */


-- create the hosts table
create table hosts
(
hostname varchar(20) NOT NULL PRIMARY KEY,
ip varchar(20),
fqdn varchar(40)
);




-- insert some data
insert into hosts values ("sqsaaa01", "192.168.0.1", "sqsaaa01.questor.intra");
insert into hosts values ("sqsaaa02", "192.168.0.2", "sqsaaa02.questor.intra");
insert into hosts values ("sqsaaa03", "192.168.0.3", "sqsaaa03.questor.intra");


-- query the data back
select * from hosts where hostname like 'sqs%';

