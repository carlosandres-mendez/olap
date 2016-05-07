


--- INDICE
connect parametros/parametros 
grant select on fechas to ventas; 
grant select on personas to ventas; 
grant select , update , delete , insert , references on personasfisicas to rrhh;


-- Crear Tabla Padron y distritos en Parametros

create table padron(
cedula     varchar2(30),
codelec    varchar(10),
sexo       varchar2(01),
fechacaduc date,
junta      varchar2(10),
nombre     varchar2(100),
apellido1  varchar2(100),
apellido2  varchar2(100))
tablespace data_tbs;  

CREATE TABLE distritostse
   (CODIGO     VARCHAR2(6), 
    PROVINCIA  VARCHAR2(100), 
    CANTON     VARCHAR2(100), 
    DISTRITO   VARCHAR2(100)
   )
TABLESPACE DATA_TBS;

-- Cargar el padron respectivo

sqlldr parametros/parametros control=sqlldr-padron.txt log=cargapadron.txt
sqlldr parametros/parametros control=sqlldr-dist.txt log=cargadist.txt

-- Cargar personas

insert into personas
select cedula, 'F'
from   padron;

-- Cargar personasfisicas 

insert into personasfisicas (idperfisica, nombre, apellido1, apellido2, sexo)
select cedula, nombre, apellido1, apellido2, 
       decode(sexo, '1','M','F')
from   padron;

-- insert lugares


truncate table provincias;

INSERT INTO PROVINCIAS
SELECT DISTINCT substr(codigo, 1, 1), provincia
from   distritostse
order by 1, 2;

SELECT *
FROM   PROVINCIAS;

insert into cantones 
SELECT DISTINCT substr(codigo, 1, 1),substr(codigo, 2, 2), canton
from   distritostse
order by 1, 2, 3;

select *
from   cantones;
  
insert into distritos
SELECT DISTINCT substr(codigo, 1, 1),substr(codigo, 2, 2), substr(codigo, 4, length(codigo)), distrito
from   distritostse
order by 1, 2, 3, 4

-- inserts de dirpersonas util para lo de los lugares

insert into  dirpersonas
select cedula, '1',substr(codelec, 1, 1),
                   substr(codelec, 2, 2),
                   substr(codelec, 4, length(codelec)), null
from   padron;

commit;


-- Cargar Beneficiarios
-- idbeneficiario idpersona idrelacionconcliente
-- nota la relacion con cliente es por ejemplo padre madre hermano esposa hijo etc

-- POR HACER 
-- similar a esto y luego en el campo null de la relacion con cliente podemos hacer un prodedimiento
-- donde las filas pares sean por ejemplo padre o madre y las impares esposo o hijo 

CREATE SEQUENCE beneficiarioid
  MINVALUE 1
  MAXVALUE 999999999999999999999999999
  START WITH 1
  INCREMENT BY 1
  CACHE 20;
  
insert into beneficiarios
select to_char(beneficiarioid.nextval), idpersona, null 
from (
select *
from   parametros.personas
order by dbms_random.value) r1
where rownum < 100001;


-- Crear tabla fechas y insertar fechas  esto es util para inserts en ventas (facturas etc)
create table fechas(
fecha date);

select to_char(to_date('19400101','yyyymmdd') + 27500,'yyyy-mm-dd') from dual;

DECLARE
  vcant    NUMBER;
  vfecha   date;
BEGIN
  vfecha := to_date('31121939','ddmmyyyy');
  FOR i in 1..27500
  LOOP
    vfecha := vfecha + 1;
    INSERT INTO fechas values (vfecha);
  END LOOP;
  commit;
END;