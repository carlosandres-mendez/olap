--- En este esquema: Polizas, seguros, coberturas

--- Se conecta con el usuario ventas;

create table clientes(
IdCliente     varchar2(30),
IdPerfisica   varchar2(30),
FecNac	      date,
Profesion     varchar2(60),
Nivel_Aca     varchar2(60),
CONSTRAINT pk_clientes PRIMARY KEY (IdCliente),
CONSTRAINT fk_perfisica_clientes 
           foreign key(IdPerfisica)
           references rrhh.personasfisicas(IdPerfisica))
tablespace ventas_tbs;


create table tiposeguro(
IdSeguro 	varchar2(30),
Nombre 		varchar2(100),
Prima 		decimal(10,2),
Vigencia	date,
CONSTRAINT pk_tiposeguro PRIMARY KEY (IdSeguro))
tablespace ventas_tbs;


create table cobertura(
IdCobertura varchar2(30),
Nombre		varchar2(100),
Monto 		decimal(10,2),
Descripcion varchar2(200),
CONSTRAINT pk_cobertura PRIMARY KEY (IdCobertura))
tablespace ventas_tbs;



create table polizas(
NumPoliza 			varchar2(30),
IdSeguro 			varchar2(30),
NombreBeneficiario	varchar2(100),
PrimaTotal			decimal(10,2),
Fecha				date,
MontoAsegurado		decimal(10,2),
Moneda 				varchar2(30),
CONSTRAINT pk_polizas PRIMARY KEY (NumPoliza),
CONSTRAINT fk_tiposeguro_polizas 
           foreign key(IdSeguro)
           references tiposeguro(IdSeguro))
tablespace ventas_tbs;