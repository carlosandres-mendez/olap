

-- Se debe crear la carpetaC:\oraclexe\curso\olap\

CREATE TABLESPACE parametros_tbs DATAFILE 'C:\oraclexe\curso\olap\parametros.dbf' SIZE 100M;
alter database datafile 'C:\oraclexe\curso\olap\parametros.dbf' autoextend on;

CREATE TABLESPACE rrhh_tbs DATAFILE 'C:\oraclexe\curso\olap\rrhh.dbf' SIZE 100M;
alter database datafile 'C:\oraclexe\curso\olap\rrhh.dbf' autoextend on;

CREATE TABLESPACE ventas_tbs DATAFILE 'C:\oraclexe\curso\olap\ventas.dbf' SIZE 100M;
alter database datafile 'C:\oraclexe\curso\olap\ventas.dbf' autoextend on;

create user parametros
identified by parametros
profile default
temporary tablespace temp
default tablespace parametros_tbs;

grant connect, resource to parametros;

create user rrhh
identified by rrhh
profile default
temporary tablespace temp
default tablespace rrhh_tbs;

grant connect, resource to rrhh;

create user ventas
identified by ventas
profile default
temporary tablespace temp
default tablespace ventas_tbs;

grant connect, resource to ventas;

