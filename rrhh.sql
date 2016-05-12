--- En este esquema: personas, direcciones, departamentos y empleados

--ejecitar desde la conecci√≥n de par√°metro

grant select, update, delete, insert, references on cantones to rrhh
grant select, update, delete, insert, references on distritos to rrhh;
grant select, update, delete, insert, references on provincias to rrhh;

--ejecutar e4sto para que ventas pueda ver personas 
grant select, update, delete, insert, references on personas to ventas
grant select, update, delete, insert, references on personasjuridicas to ventas
grant select, update, delete, insert, references on vendedores to ventas
grant select, update, delete, insert, references on personasfisicas to ventas


--- Se conecta con el usuario rrhh;


CREATE TABLE personas
( IdPersona varchar2(30) NOT NULL,
  TipoPersona varchar2(01) NOT NULL,
  CONSTRAINT pk_personas PRIMARY KEY (IdPersona))
  tablespace rrhh_tbs;
  
create table personasjuridicas(
IdPerJuridica  	varchar2(30) NOT NULL,
Nombre       	varchar2(100),
CONSTRAINT pk_personasjuridicas PRIMARY KEY (IdPerJuridica),
CONSTRAINT fk_perjuridica_persona 
           foreign key(IdPerJuridica)
           references personas(IdPersona))
tablespace rrhh_tbs;

create table personasfisicas(
IdPerfisica  varchar2(30) NOT NULL,
Nombre       varchar2(100),
Apellido1    varchar2(100),
Apellido2    varchar2(100),
Sexo         varchar2(01),
FecNacimiento date,
EstCivil     varchar2(01),
CONSTRAINT pk_personasfisicas PRIMARY KEY (IdPerfisica),
CONSTRAINT fk_perfisica_persona 
           foreign key(IdPerfisica)
           references personas(IdPersona))
tablespace rrhh_tbs;


create table empleados(
IdEmpleado 	varchar2(30) NOT NULL,
IdPerfisica varchar2(30) NOT NULL,
Salario		decimal(10,2),
Comision	decimal(10,2),
FecIngreso  date,
IdDepartamento varchar2(30),
Supervisor	varchar2(30),
IdSede		varchar2(30),
CONSTRAINT pf_empleados PRIMARY KEY (IdEmpleado),
CONSTRAINT fk_empleado_perfisica
           foreign key(IdEmpleado)
           references personasfisicas(IdPerfisica))
tablespace rrhh_tbs;

create table telefonos(
IdPersona  varchar2(30),
Tipotelefono varchar2(50),
Telefono     varchar2(13),
CONSTRAINT pk_telefonos PRIMARY KEY (IdPersona,Tipotelefono),
CONSTRAINT fk_telefonos_personas
           foreign key(IdPersona)
           references personas(IdPersona))
tablespace rrhh_tbs;


create table dirpersonas (
IdPersona    varchar2(30) NOT NULL,
IdTipoDir    varchar2(10),
IdProvincia  varchar2(10),
IdCanton     varchar2(10),
IdDistrito   varchar2(10),
Detalle      varchar2(200),
  CONSTRAINT pk_direcciones PRIMARY KEY (IdPersona, IdTipoDir),
  CONSTRAINT fk_dirpersonas_personas
             foreign key (idpersona)
             references personas(idpersona),
  CONSTRAINT fk_dirpersonas_provincias
             foreign key (idprovincia)
             references parametros.provincias(idprovincia),
  CONSTRAINT fk_dirpersonas_cantones
             foreign key (idprovincia, idcanton)
             references parametros.cantones(idprovincia, idcanton),
  CONSTRAINT fk_dirpersonas_distritos
             foreign key (idprovincia, idcanton, iddistrito)
             references parametros.distritos(idprovincia, idcanton, iddistrito))
  tablespace rrhh_tbs;


create table vendedores(
IdVendedor     	varchar2(30) NOT NULL,
IdEmpleado     	varchar2(30) NOT NULL,
CONSTRAINT pk_vendedores PRIMARY KEY (IdVendedor),
CONSTRAINT fk_vendedor_empleado 
           foreign key(IdEmpleado)
           references empleados(IdEmpleado))
tablespace rrhh_tbs;


create table departamentos(
IdDepartamento varchar2(30) NOT NULL,
Nombre varchar2(50),
IdDescripcion  varchar2(200),
IdGerente varchar2(30),
CONSTRAINT pk_departamentos PRIMARY KEY (IdDepartamento),
CONSTRAINT fk_depto_empleado FOREIGN KEY (IdGerente)
							references empleados(IdEmpleado))
tablespace rrhh_tbs;


create table sedes (
IdSede    	varchar2(30) NOT NULL,
Nombre    	varchar2(100),
IdProvincia varchar2(10),
IdCanton    varchar2(10),
IdDistrito  varchar2(10),
Direccion   varchar2(200),
Telefono    varchar2(13),
Email    	varchar2(30),
Licencia    varchar2(50),
Apartado    varchar2(50),
PagWeb    	varchar2(50),
Administrador	varchar2(30),
  CONSTRAINT pk_sedes PRIMARY KEY (IdSede),
  CONSTRAINT fk_dirper_prov_sedes
             foreign key (idprovincia)
             references parametros.provincias(idprovincia),
  CONSTRAINT fk_dirper_canton_sedes
             foreign key (idprovincia, idcanton)
             references parametros.cantones(idprovincia, idcanton),
  CONSTRAINT fk_dirper_distritos_sedes
             foreign key (idprovincia, idcanton, iddistrito)
             references parametros.distritos(idprovincia, idcanton, iddistrito),
  CONSTRAINT fk_sede_empleado
  			 foreign key(Administrador)
  			 references empleados(IdEmpleado))
  tablespace rrhh_tbs;


create table departamentos_sede (
IdDep   varchar2(30) NOT NULL,
IdSede  varchar2(30) NOT NULL,
  CONSTRAINT pk_departamento_sede PRIMARY KEY (IdDep, IdSede),
  CONSTRAINT fk_departamentos_sede
             foreign key (IdDep)
             references departamentos(IdDepartamento),
  CONSTRAINT fk_sede_pertenece
             foreign key (IdSede)
             references sedes(IdSede))
  tablespace rrhh_tbs;
  
 
CREATE TABLE evaluacion_emp(
IdEvaluacion		int NOT NULL,
IdEmpleado 			varchar(30) NOT NULL,
Puntualidad			int,
Rendimiento			int,
Proactividad		int,
Semestre 			varchar(30) NOT NULL,
A√±o 				int,
	CONSTRAINT pk_IdEvaluacion_IdEmpleado PRIMARY KEY (IdEvaluacion, IdEmpleado),
	CONSTRAINT fk_IdEmpleado
		 foreign key (IdEmpleado)
		 references empleados(IdEmpleado))
    tablespace rrhh_tbs;

  
CREATE TABLE pagos(
IdEmpleado 			varchar(30) NOT NULL,
Semestre 			varchar(30) NOT NULL,
A√±o 				int,
monto				int,
	CONSTRAINT pk_pagos PRIMARY KEY (IdEmpleado, Semestre, A√±o),
	CONSTRAINT fk_IdEmpleado_pagogos
		 foreign key (IdEmpleado)
		 references empleados(IdEmpleado));
    tablespace rrhh_tbs;

	
alter table empleados add CONSTRAINT fk_empleado_empleado
			foreign key(Supervisor)
			references empleados(IdEmpleado);
      
alter table empleados add CONSTRAINT fk_empleado_departamento 
			foreign key(IdDepartamento)
			references departamentos(IdDepartamento);

alter table empleados add CONSTRAINT fk_empleado_sede
			foreign key(IdSede)
			references sedes(IdSede);
 
-- no recuerdo bien si esta tabla era la que por ejemplo decia... 
-- si un empleado habia faltado muchas veces por incapacidad.. o vendia poco..
-- Hay que arreglar esta tabla y pasarla al diagrama. 
CREATE TABLE clima_org(
IdEvaluacion		int NOT NULL
IdEmpleado 			varchar(30) NOT NULL,
Constancia			int,
Calidad_trabajo		int,
Dinamismo			int,
Semestre 			varchar(30) NOT NULL),
A√±o 				int;
	CONSTRAINT pk_IdEvaluacion_IdEmpleado PRIMARY KEY (IdEvaluacion, IdEmpleado),
	CONSTRAINT fk_IdEmpleado
		 foreign key (IdEmpleado)
		 references empleados(IdEmpleado)
    tablespace rrhh_tbs;
  
  
  
  --inserciones en personasFÌsicas
  
  --fechas aleatorias 
  CREATE TABLE fechas_aleatorias (fecha DATE);
  
  delete fechas_aleatorias

DECLARE
  sd    NUMBER;
  dias  NUMBER := 10000;  --max de dias que se suman/restan a sysdate
  dia   DATE;
BEGIN
  -- inicializacion del seed
  SELECT to_char(systimestamp,'FF') INTO sd FROM dual;
  dbms_random.initialize(sd);

  FOR i in 1..5000
  LOOP
    dia := TRUNC(sysdate) - dbms_random.value(-dias,dias);
    INSERT INTO fechas_aleatorias VALUES (dia);
  END LOOP;
END;

select * from fechas_aleatorias

SELECT fecha FROM
( SELECT fecha FROM fechas_aleatorias
ORDER BY dbms_random.value )
WHERE rownum = 1

--- para generar el estado civil

create table estadoCivil(
  letra varchar(1) primary key
)
insert into estadoCivil (letra) values('S');
insert into estadoCivil values('C');
insert into estadoCivil values('D');
insert into estadoCivil values('V');

select * from estadocivil

--end 
  
declare
  cursor personafisi is
  select cedula, nombre, apellido1, apellido2, 
       decode(sexo, '1','M','F') as sexo
  from   parametros.padron
  where rownum<=110000;
  
begin
  for perf in personafisi loop
    insert into personas values(perf.cedula,'F');
    
        insert into personasfisicas values(perf.cedula, perf.nombre, perf.apellido1, perf.apellido2, perf.sexo, 
    (SELECT fecha FROM
      ( SELECT fecha FROM fechas_aleatorias
      ORDER BY dbms_random.value )
      WHERE rownum = 1), 
      (SELECT letra FROM
      ( SELECT letra FROM estadoCivil
      ORDER BY dbms_random.value )
      WHERE rownum = 1)
      );
  end loop;
end;

select count(*) from personas;

select * from personasfisicas

delete personasfisicas;
delete personas;


-----insertamos en personajuridica

declare idpj varchar2(30);
BEGIN
for i in 1..50 loop
  SELECT 3||DBMS_RANDOM.string('x', 9) into idpj FROM dual;
  insert into personas values(idpj,'J');
  insert into personasjuridicas values(idpj, (SELECT DBMS_RANDOM.string('u', 9) FROM dual));
end loop; 
END;


select * from personasjuridicas

--- insertar en sedes
--secuencia para id autoincremental
CREATE SEQUENCE incrementar_id_sedes
  START WITH 1
  INCREMENT BY 1
  CACHE 100;
  
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Centro de GestiÛn de Reclamos de AutomÛviles');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Centro de GestiÛn de Seguros Personales');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Centro de Servicios Complementarios');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Centro de Servicios TÈcnicos Profesionales');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Punto de Venta CaÒas');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Punto de Venta Escaz˙');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Punto de Venta Filadelfia');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Punto de Venta Golfito');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Punto de Venta Grecia');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Punto de Venta JacÛ');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Punto de Venta Quepos');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Punto de Venta San Antonio de BelÈn');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Punto de Venta San Marcos de Tarraz˙');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Punto de Venta San Sebasti·n');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Punto de Venta Santa Cruz');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Punto de Venta SarchÌ');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Punto de Venta Siquirres');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Punto de Venta Tres RÌos (BCAC)');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede Alajuela');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede Cartago');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede Ciudad Neilly');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede Ciudad Quesada');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede Curridabat');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede Desamparados');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede Guadalupe');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede Gu·piles');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede Heredia');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede La Merced');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede Liberia');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede LimÛn');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede Nicoya');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede Pavas');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede PÈrez ZeledÛn');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede Puntarenas');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede San JosÈ');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede San Pedro');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede San RamÛn');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede Tib·s');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede Turrialba');

--insertamos prov, cont y dist
declare
cont int;
  cursor personafisi is
  SELECT idprovincia, idcanton, iddistrito 
  FROM parametros.distritos
  where rownum<=39;
  
begin
cont:=0;
  for perf in personafisi loop   
  cont := cont +1;
        update sedes set idprovincia = perf.idprovincia, idcanton=perf.idcanton,iddistrito=perf.iddistrito
        where idsede=cont;
  end loop;
end;

--administrador
BEGIN
for i in 1..50 loop
  update sedes set administrador=(
  SELECT letra FROM
      ( SELECT letra FROM estadoCivil
      ORDER BY dbms_random.value )
      WHERE rownum = 1)
end loop; 
END;



-----insertamos en departamentos
CREATE SEQUENCE incrementar_id_departamentos
  START WITH 1
  INCREMENT BY 1
  CACHE 100;

insert into departamentos (iddepartamento,nombre) values(incrementar_id_departamentos.nextval,'DirecciÛn de Reaseguros');
insert into departamentos (iddepartamento,nombre) values(incrementar_id_departamentos.nextval,'Recursos Humanos');
insert into departamentos (iddepartamento,nombre) values(incrementar_id_departamentos.nextval,'DirecciÛn de Riesgos o DaÒos');
insert into departamentos (iddepartamento,nombre) values(incrementar_id_departamentos.nextval,'DirecciÛn de Seguros Solidarios');
insert into departamentos (iddepartamento,nombre) values(incrementar_id_departamentos.nextval,'DirecciÛn de Seguros Personales');
insert into departamentos (iddepartamento,nombre) values(incrementar_id_departamentos.nextval,'DirecciÛn tÈcnica de indemnizaciones');
insert into departamentos (iddepartamento,nombre) values(incrementar_id_departamentos.nextval,'DirecciÛn cliente corporativo');
insert into departamentos (iddepartamento,nombre) values(incrementar_id_departamentos.nextval,'DirecciÛn de operaciones');


select * from departamentos_sede

delete departamentos_sede

---insertamos en departamentos_sede
begin
for i in 1..39 loop
  for j in 1..4 loop
    insert into departamentos_sede values(j,i);
  end loop;
end loop;
end;




  
  
  