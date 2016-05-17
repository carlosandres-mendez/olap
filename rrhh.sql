--- En este esquema: personas, direcciones, departamentos y empleados

--ejecitar desde la conección de parámetro

grant select, update, delete, insert, references on cantones to rrhh;
grant select, update, delete, insert, references on distritos to rrhh;
grant select, update, delete, insert, references on provincias to rrhh;

--ejecutar e4sto para que ventas pueda ver personas 
grant select, update, delete, insert, references on personas to ventas;
grant select, update, delete, insert, references on personasjuridicas to ventas;
grant select, update, delete, insert, references on vendedores to ventas;
grant select, update, delete, insert, references on personasfisicas to ventas;


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
           foreign key(IdPerfisica)
           references personasfisicas(IdPerfisica))
tablespace rrhh_tbs;

--alter table empleados add constraint fk_empleado_perfisica foreign key(IdEmpleado)
--           references personasfisicas(IdPerfisica) -- constraint repetido

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
Calidad     		int,
Semestre 			varchar(30) NOT NULL,
Año 				date,
	CONSTRAINT pk_IdEvaluacion_IdEmpleado PRIMARY KEY (IdEvaluacion, IdEmpleado),
	CONSTRAINT fk_IdEmpleado
		 foreign key (IdEmpleado)
		 references empleados(IdEmpleado))
    tablespace rrhh_tbs;

  
CREATE TABLE pagos(
IdEmpleado 			varchar(30) NOT NULL,
Mes 				varchar(30) NOT NULL,
Año 				int,
monto				int,
	CONSTRAINT pk_pagos PRIMARY KEY (IdEmpleado, Mes, Año),
	CONSTRAINT fk_IdEmpleado_pagogos
		 foreign key (IdEmpleado)
		 references empleados(IdEmpleado))
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
 



