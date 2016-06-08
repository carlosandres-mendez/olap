
CREATE TABLE personas
( IdPersona varchar(30),
  TipoPersona varchar(01) NOT NULL,
  CONSTRAINT pk_personas PRIMARY KEY (IdPersona))


create table personasjuridicas(
IdPerJuridica  	varchar(30) NOT NULL,
CONSTRAINT pk_personasjuridicas PRIMARY KEY (IdPerJuridica),
CONSTRAINT fk_perjuridica_persona 
           foreign key(IdPerJuridica)
           references personas(IdPersona))

create table personasfisicas(
IdPerfisica  varchar(30) NOT NULL,
Nombre       varchar(100),
Apellido1    varchar(100),
Apellido2    varchar(100),
Sexo         varchar(01),
FecNacimiento date,
EstCivil     varchar(01),
CONSTRAINT pk_personasfisicas PRIMARY KEY (IdPerfisica),
CONSTRAINT fk_perfisica_persona 
           foreign key(IdPerfisica)
           references personas(IdPersona))

create table empleados(
IdEmpleado 	varchar(30) NOT NULL,
IdPerfisica varchar(30) NOT NULL,
Salario		decimal(10,2),
Comision	decimal(10,2),
FecIngreso  date,
IdDepartamento varchar(30),
Supervisor	varchar(30),
IdSede		varchar(30),
CONSTRAINT pf_empleados PRIMARY KEY (IdEmpleado),
CONSTRAINT fk_empleado_perfisica
           foreign key(IdPerfisica)
           references personasfisicas(IdPerfisica))

--alter table empleados add constraint fk_empleado_perfisica foreign key(IdEmpleado)
--           references personasfisicas(IdPerfisica) -- constraint repetido

create table telefonos(
IdPersona  varchar(30),
Tipotelefono varchar(50),
Telefono     varchar(13),
CONSTRAINT pk_telefonos PRIMARY KEY (IdPersona,Tipotelefono),
CONSTRAINT fk_telefonos_personas
           foreign key(IdPersona)
           references personas(IdPersona))


create table dirpersonas (
IdPersona    varchar(30) NOT NULL,
IdTipoDir    varchar(10),
IdProvincia  varchar(10),
IdCanton     varchar(10),
IdDistrito   varchar(10),
Detalle      varchar(200),
  CONSTRAINT pk_direcciones PRIMARY KEY (IdPersona, IdTipoDir),
  CONSTRAINT fk_dirpersonas_personas
             foreign key (idpersona)
             references personas(idpersona),
  CONSTRAINT fk_dirpersonas_provincias
             foreign key (idprovincia)
             references provincias(idprovincia),
  CONSTRAINT fk_dirpersonas_cantones
             foreign key (idprovincia, idcanton)
             references cantones(idprovincia, idcanton),
  CONSTRAINT fk_dirpersonas_distritos
             foreign key (idprovincia, idcanton, iddistrito)
             references distritos(idprovincia, idcanton, iddistrito))


create table vendedores(
IdVendedor     	varchar(30) NOT NULL,
IdEmpleado     	varchar(30) NOT NULL,
CONSTRAINT pk_vendedores PRIMARY KEY (IdVendedor),
CONSTRAINT fk_vendedor_empleado 
           foreign key(IdEmpleado)
           references empleados(IdEmpleado))


create table departamentos(
IdDepartamento varchar(30) NOT NULL,
Nombre varchar(50),
IdDescripcion  varchar(200),
IdGerente varchar(30),
CONSTRAINT pk_departamentos PRIMARY KEY (IdDepartamento),
CONSTRAINT fk_depto_empleado FOREIGN KEY (IdGerente)
							references empleados(IdEmpleado))


create table sedes (
IdSede    	varchar(30) NOT NULL,
Nombre    	varchar(100),
IdProvincia varchar(10),
IdCanton    varchar(10),
IdDistrito  varchar(10),
Direccion   varchar(200),
Telefono    varchar(13),
Email    	varchar(30),
Licencia    varchar(50),
Apartado    varchar(50),
PagWeb    	varchar(50),
Administrador	varchar(30),
  CONSTRAINT pk_sedes PRIMARY KEY (IdSede),
  CONSTRAINT fk_dirper_prov_sedes
             foreign key (idprovincia)
             references provincias(idprovincia),
  CONSTRAINT fk_dirper_canton_sedes
             foreign key (idprovincia, idcanton)
             references cantones(idprovincia, idcanton),
  CONSTRAINT fk_dirper_distritos_sedes
             foreign key (idprovincia, idcanton, iddistrito)
             references distritos(idprovincia, idcanton, iddistrito),
  CONSTRAINT fk_sede_empleado
  			 foreign key(Administrador)
  			 references empleados(IdEmpleado))
  

create table departamentos_sede (
IdDep   varchar(30) NOT NULL,
IdSede  varchar(30) NOT NULL,
  CONSTRAINT pk_departamento_sede PRIMARY KEY (IdDep, IdSede),
  CONSTRAINT fk_departamentos_sede
             foreign key (IdDep)
             references departamentos(IdDepartamento),
  CONSTRAINT fk_sede_pertenece
             foreign key (IdSede)
             references sedes(IdSede))
    
 
CREATE TABLE evaluacion_emp(
IdEvaluacion		varchar(30) NOT NULL,
IdEmpleado 			varchar(30) NOT NULL,
Puntualidad			int,
Rendimiento			int,
Calidad     		int,
Semestre 			varchar(30) NOT NULL,
Año 				int,
	CONSTRAINT pk_IdEvaluacion_IdEmpleado PRIMARY KEY (IdEvaluacion, IdEmpleado),
	CONSTRAINT fk_IdEmpleado
		 foreign key (IdEmpleado)
		 references empleados(IdEmpleado))
  
CREATE TABLE pagos(
IdEmpleado 			varchar(30) NOT NULL,
Semestre 				varchar(30) NOT NULL,
Año 				int,
monto				int,
	CONSTRAINT pk_pagos PRIMARY KEY (IdEmpleado, Semestre, Año),
	CONSTRAINT fk_IdEmpleado_pagogos
		 foreign key (IdEmpleado)
		 references empleados(IdEmpleado))
    

alter table empleados add CONSTRAINT fk_empleado_empleado
			foreign key(Supervisor)
			references empleados(IdEmpleado);
      
alter table empleados add CONSTRAINT fk_empleado_departamento 
			foreign key(IdDepartamento)
			references departamentos(IdDepartamento);

alter table empleados add CONSTRAINT fk_empleado_sede
			foreign key(IdSede)
			references sedes(IdSede);
			
			
create table provincias (
idprovincia varchar(10) NOT NULL,
descripcion varchar(100),
  CONSTRAINT pk_provincia PRIMARY KEY (idprovincia))


create table cantones (
idprovincia varchar(10) NOT NULL,
idcanton    varchar(10) NOT NULL,
descripcion varchar(100),
  CONSTRAINT pk_cantones PRIMARY KEY (idprovincia, idcanton),
    CONSTRAINT fk_cantones_provincia
             foreign key (idprovincia)
             references provincias(idprovincia))


create table distritos (
idprovincia varchar(10) NOT NULL,
idcanton    varchar(10) NOT NULL,
iddistrito  varchar(10) NOT NULL,
descripcion varchar(100),
  CONSTRAINT pk_distritos PRIMARY KEY (idprovincia, idcanton, iddistrito),
    CONSTRAINT fk_distritos_cantones
             foreign key (idprovincia, idcanton)
             references cantones(idprovincia, idcanton))
  
  
create table clientes(
IdCliente     varchar(30) NOT NULL,
IdPersona     varchar(30) NOT NULL,
Profesion     varchar(60),
Nivel_Aca     varchar(60),
CONSTRAINT pk_clientes PRIMARY KEY (IdCliente),
CONSTRAINT fk_perfisica_clientes 
           foreign key(IdPersona)
           references personas(IdPersona))

create table proveedores(
IdProveedor     varchar(30) NOT NULL,
IdPerjuridica   varchar(30) NOT NULL,
Nombre     		varchar(60),
CONSTRAINT pk_proveedores PRIMARY KEY (IdProveedor),
CONSTRAINT fk_perjuridica_proveedores
           foreign key(IdPerjuridica)
           references personasjuridicas(IdPerjuridica))

create table tiposeguro(
IdSeguro 	varchar(30) NOT NULL,
Nombre 		varchar(100),
Vigencia	date,
CONSTRAINT pk_tiposeguro PRIMARY KEY (IdSeguro))

drop table cobertura

create table cobertura(
IdCobertura varchar(30) NOT NULL,
IdSeguro	varchar(30) NOT NULL,
Nombre		varchar(100),
Tarifa 		decimal(10,2),
Descripcion varchar(200),
CONSTRAINT pk_cobertura PRIMARY KEY (IdCobertura,IdSeguro),
CONSTRAINT fk_tiposeguro_coberturas 
           foreign key(IdSeguro)
           references tiposeguro(IdSeguro))


create table polizas(
NumPoliza 			varchar(30) NOT NULL,
IdSeguro 			varchar(30),
PrimaTotal			decimal(10,2),
Fecha				date,
MontoAsegurado		decimal(10,2),
IdVendedor     		varchar(30),
IdCliente     		varchar(30),
CONSTRAINT pk_polizas PRIMARY KEY (NumPoliza),
CONSTRAINT fk_tiposeguro_polizas 
           foreign key(IdSeguro)
           references tiposeguro(IdSeguro),
CONSTRAINT fk_poliza_vendedor
			foreign key(IdVendedor)
			references vendedores(IdVendedor),
CONSTRAINT fk_poliza_cliente
			foreign key(IdCliente)
			references clientes(IdCliente))


create table beneficiarios(
IdBeneficiario 		varchar(30) NOT NULL,
IdPersona     		varchar(30) NOT NULL,
RelacionConCliente  varchar(30),
NumPoliza         varchar(30) NOT NULL,    
CONSTRAINT pk_beneficiariosins PRIMARY KEY (IdBeneficiario),
CONSTRAINT fk_perfisica_beneficiariosins foreign key(IdBeneficiario) references personasfisicas(IdPerFisica),
CONSTRAINT fk_numpoliza_beneficiariosins foreign key (numPoliza) references polizas(numPoliza))


CREATE TABLE clima_org(
IdEvaluacion		varchar(30) NOT NULL,
IdEmpleado 			varchar(30) NOT NULL,
Comunicacion		int,
Liderazgo		    int,
Pertenencia			int,
Motivacion      int,
Semestre 			  varchar(30) NOT NULL,
Año 				    int,
	CONSTRAINT pk_IdClima_IdEmpleado PRIMARY KEY (IdEvaluacion, IdEmpleado),
	CONSTRAINT fk_IdEmpleadoClima
		 foreign key (IdEmpleado)
		 references empleados(IdEmpleado))


CREATE TABLE Tiempo (
       TiempoID         int NOT NULL,
       Fecha            date NOT NULL,
       Año              int NOT NULL,
       MesID            int NOT NULL,
       Mes              varchar(10) NOT NULL,
       Cuarto           int NOT NULL,
       Semana           int NOT NULL,
       NumDiaSemana     int NOT NULL,
       DiaSemana        varchar(15) NOT NULL
);
ALTER TABLE Tiempo
       ADD PRIMARY KEY (TiempoID);