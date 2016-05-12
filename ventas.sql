

--creación de tablas
create table clientes(
IdCliente     varchar2(30) NOT NULL,
IdPersona     varchar2(30) NOT NULL,
Profesion     varchar2(60),
Nivel_Aca     varchar2(60),
CONSTRAINT pk_clientes PRIMARY KEY (IdCliente),
CONSTRAINT fk_perfisica_clientes 
           foreign key(IdPersona)
           references rrhh.personas(IdPersona))
tablespace ventas_tbs;

create table proveedores(
IdProveedor     varchar2(30) NOT NULL,
IdPerjuridica   varchar2(30) NOT NULL,
Nombre     		varchar2(60),
CONSTRAINT pk_proveedores PRIMARY KEY (IdProveedor),
CONSTRAINT fk_perjuridica_proveedores
           foreign key(IdPerjuridica)
           references rrhh.personasjuridicas(IdPerjuridica))
tablespace ventas_tbs;

create table tiposeguro(
IdSeguro 	varchar2(30) NOT NULL,
Nombre 		varchar2(100),
Prima 		decimal(10,2),
Vigencia	date,
CONSTRAINT pk_tiposeguro PRIMARY KEY (IdSeguro))
tablespace ventas_tbs;

create table cobertura(
IdCobertura varchar2(30) NOT NULL,
IdSeguro	varchar2(30) NOT NULL,
Nombre		varchar2(100),
Monto 		decimal(10,2),
Descripcion varchar2(200),
CONSTRAINT pk_cobertura PRIMARY KEY (IdCobertura,IdSeguro),
CONSTRAINT fk_tiposeguro_coberturas 
           foreign key(IdSeguro)
           references tiposeguro(IdSeguro))
tablespace ventas_tbs;

create table polizas(
NumPoliza 			varchar2(30) NOT NULL,
IdSeguro 			varchar2(30),
NombreBeneficiario	varchar2(100),
PrimaTotal			decimal(10,2),
Fecha				date,
MontoAsegurado		decimal(10,2),
Moneda 				varchar2(30),
IdVendedor     		varchar2(30),
IdCliente     		varchar2(30),
CONSTRAINT pk_polizas PRIMARY KEY (NumPoliza),
CONSTRAINT fk_tiposeguro_polizas 
           foreign key(IdSeguro)
           references tiposeguro(IdSeguro),
CONSTRAINT fk_poliza_vendedor
			foreign key(IdVendedor)
			references rrhh.vendedores(IdVendedor),
CONSTRAINT fk_poliza_cliente
			foreign key(IdCliente)
			references clientes(IdCliente))
tablespace ventas_tbs;


create table beneficiarios(
IdBeneficiario 		varchar2(30) NOT NULL,
IdPersona     		varchar2(30) NOT NULL,
RelacionConCliente  varchar2(30),
CONSTRAINT pk_beneficiarios PRIMARY KEY (IdBeneficiario),
CONSTRAINT fk_perfisica_beneficiarios 
           foreign key(IdBeneficiario)
           references rrhh.personas(IdPersona))
tablespace ventas_tbs;




--- insertar en clientes

--insertar clientes físicos

declare
  cursor personafisi is
  select IDPERFISICA
  from   rrhh.personasfisicas
  where rownum<=100000;
  
begin
  for perf in personafisi loop    
        insert into clientes values(perf.IDPERFISICA, perf.IDPERFISICA, (SELECT DBMS_RANDOM.string('u', 1) FROM dual), (SELECT DBMS_RANDOM.string('u', 1) FROM dual));
  end loop;
end;

select count(*) from clientes;

---insertar lientes juridicos
declare
  cursor personafisi is
  select IDPERJURIDICA
  from   RRHH.PERSONASJURIDICAS
  where rownum<=50;
  
begin
  for perf in personafisi loop    
        insert into clientes values(perf.IDPERJURIDICA, perf.IDPERJURIDICA, (SELECT DBMS_RANDOM.string('u', 1) FROM dual), (SELECT DBMS_RANDOM.string('u', 1) FROM dual));
  end loop;
end;








