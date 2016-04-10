--- En este esquema: personas, direcciones, departamentos y empleados

--- Se conecta con el usuario rrhh;

CREATE TABLE personas
( IdPersona varchar2(30) NOT NULL,
  TipoPersona varchar2(01),
  CONSTRAINT pk_personas PRIMARY KEY (IdPersona))
  tablespace rrhh_tbs;
  
create table personasjuridicas(
IdPerJuridica  varchar2(30),
Nombre       varchar2(100),
CONSTRAINT pk_personasjuridicas PRIMARY KEY (IdPerJuridica),
CONSTRAINT fk_perjuridica_persona 
           foreign key(IdPerJuridica)
           references personas(IdPersona))
tablespace rrhh_tbs;

create table personasfisicas(
IdPerfisica  varchar2(30),
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

create table telefonos(
IdPersona  varchar2(30),
Tipotelefono varchar2(50),
Telefono     varchar2(13),
CONSTRAINT pk_telefonos PRIMARY KEY (IdPersona,Tipotelefono),
CONSTRAINT fk_telefonos_personas
           foreign key(IdPersona)
           references personas(IdPersona))
tablespace rrhh_tbs;

create table personasfisicas(
IdPerfisica  varchar2(30),
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

create table dirpersonas (
IdPersona    varchar2(30),
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

create table vendedor(
IdVendedor     varchar2(30),
IdSupervisor     varchar2(30),
IdPerfisica    varchar2(30),
CONSTRAINT pk_empleados PRIMARY KEY (IdEmpleado),
CONSTRAINT fk_supervisor_vendedor 
           foreign key(IdSupervisor)
           references vendedor(IdVendedor))
tablespace rrhh_tbs;

create table departamentos(
IdDepartamento varchar2(30),
Nombre varchar2(50),
IdDescripcion  varchar2(200),
CONSTRAINT pk_departamentos PRIMARY KEY (IdDepartamento))
tablespace rrhh_tbs;

/*
create table empleados(
IdEmpleado     varchar2(30),
IdPerfisica    varchar2(30),
FecIngreso     date,
Categoria      varchar2(05),
IdDepartamento varchar2(30),
CONSTRAINT pk_empleados PRIMARY KEY (IdEmpleado),
CONSTRAINT fk_perfisica_empleados 
           foreign key(IdPerfisica)
           references personasfisicas(IdPerfisica),
CONSTRAINT fk_departamentos_empleados 
           foreign key(IdDepartamento)
           references departamentos(IdDepartamento))
tablespace rrhh_tbs;
*/

create table sedes (
IdSede    varchar2(30),
Nombre    varchar2(100),
IdProvincia  varchar2(10),
IdCanton     varchar2(10),
IdDistrito   varchar2(10),
Direccion     varchar2(200),
Telefono    varchar2(13),
Email    varchar2(30),
Licencia    varchar2(50),
Apartado    varchar2(50),
PagWeb    varchar2(50),
  CONSTRAINT pk_sedes PRIMARY KEY (IdSede),
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

create table pertenecce (
IdVendedor  varchar2(30),
IdDep   varchar2(30),
IdSede  varchar2(30),
  CONSTRAINT pk_direcciones PRIMARY KEY (IdVendedor, IdDep, IdSede),
  CONSTRAINT fk_vendedor_pertenece
             foreign key (IdVendedor)
             references vendedor(idpersona),
  CONSTRAINT fk_departamento_pertenece
             foreign key (IdDep)
             references departamento(idprovincia),
  CONSTRAINT fk_sede_pertenece
             foreign key (IdSede)
             references sede(IdSede))
  tablespace rrhh_tbs;