
-- entregado 

select * from clientes;
select * from clientes2;
-- pero esta mal porque tiene una columna categoria rara 
--- ojo tabla clientes es diferente

-- creacion de la tabla clientesINS segun buena definicion, aunque sin FK a persona por issue
create table clientesINS(
IdCliente     varchar2(30) NOT NULL,
IdPersona     varchar2(30) NOT NULL,
Profesion     varchar2(60),
Nivel_Aca     varchar2(60),
CONSTRAINT pk_clientesins PRIMARY KEY (IdCliente))--,
--CONSTRAINT fk_persona_clientes foreign key(IdPersona) references rrhh.personas(IdPersona))
tablespace data_tbs;

drop table clientesINS;
select * from clientesINS;
select count(*) from clientesINS; -- hay 100 000 clientes 
select * from rrhh.personas;  -- isssue

--- insertar en clientes creacion de secuencia  y cursor para insertarlos 

CREATE SEQUENCE clientesid
  MINVALUE 1
  MAXVALUE 999999999999999999999999999
  START WITH 1
  INCREMENT BY 1
  CACHE 20; 
declare
  cursor m is
  select IDPERSONA
  from   rrhh.personas
  where rownum<=100000;
begin
  for i in m loop    
        insert into clientesINS values(i.IDPERSONA, clientesid.nextval, null, null);
  end loop;
end;

-- falta updates para insertar profesion y nivel academico 

select * from rrhh.vendedores; -- rrhh  hay 131 vendedores
select * from sucursal;  -- ojo, donde rayos metemos sucursal --- nombre malo deberia ser sede 


-- ///////////////////////////////////////////////////////////////////////////////////////////
-- no entregado 

select * from proveedoresINS;

create table proveedoresINS(
IdProveedor     varchar2(30) NOT NULL,
IdPerjuridica   varchar2(30) NOT NULL,
Nombre     		varchar2(60),
CONSTRAINT pk_proveedoresins PRIMARY KEY (IdProveedor))--,
--CONSTRAINT fk_perjuridica_proveedores foreign key(IdPerjuridica) references rrhh.personasjuridicas(IdPerjuridica))
tablespace data_tbs;
CREATE SEQUENCE proveedoresid
  MINVALUE 1
  MAXVALUE 999999999999999999999999999
  START WITH 1
  INCREMENT BY 1
  CACHE 20; 

declare
  cursor m is
  select IDPERFISICA
  from   rrhh.personasfisicas
  where rownum<=100000;
begin
  for i in m loop    
        insert into proveedoresINS values(i.IDPERFISICA, clientesid.nextval, null);
  end loop;
end;


-- creacion de tabla beneficiariosINS 
create table beneficiariosINS(
IdBeneficiario 		varchar2(30) NOT NULL,
IdPersona     		varchar2(30) NOT NULL,
RelacionConCliente  varchar2(30),
CONSTRAINT pk_beneficiariosins PRIMARY KEY (IdBeneficiario))--,
--CONSTRAINT fk_perfisica_beneficiarios foreign key(IdBeneficiario) references rrhh.personas(IdPersona))
tablespace data_tbs;
select * from beneficiariosINS; 

-- Creacion de secuencia y los inserts de beneficiarios 
CREATE SEQUENCE beneficiarioid
  MINVALUE 1
  MAXVALUE 999999999999999999999999999
  START WITH 1
  INCREMENT BY 1
  CACHE 20;
declare
  cursor m is
  select IDPERFISICA
  from   rrhh.PERSONASFISICAS
  where rownum<=100000;
begin
  for i in m loop    
        insert into beneficiariosINS values(i.IDPERFISICA, clientesid.nextval, null);
  end loop;
end;


-- updates para beneficiariosINS pues falta relacion ej: padre madre hijo esposa random  


drop table tiposeguro;
drop table cobertura;
drop table polizas;

create table tiposeguro(
IdSeguro 	varchar2(30) NOT NULL,
Nombre 		varchar2(100),
Prima 		decimal(10,2),
Vigencia	varchar2(30),
CONSTRAINT pk_tiposeguro PRIMARY KEY (IdSeguro))
tablespace data_tbs;


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
tablespace data_tbs;


create table polizas(
NumPoliza 			varchar2(30) NOT NULL,
IdSeguro 			varchar2(30),
IdBeneficiario	varchar2(100),
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
tablespace data_tbs;

select * from tiposeguro;

insert into TipoSeguro values ('ASC','Asistencia en Carretera',100000,'anual');
insert into TipoSeguro values ('CKC','Cero Kilometros Colectiva',7000000.00,'semestral');
insert into TipoSeguro values ('CKI','Cero Kilometros Individual',60000.00,'semestral');
insert into TipoSeguro values ('SOA','Obligatorio de Automóviles',100000.00,'anual');
insert into TipoSeguro values ('VDA','Voluntario de Automóviles',60000.00,'anual');
insert into TipoSeguro values ('SVI','Su Vida',70.00,'semestral');
insert into TipoSeguro values ('HCC','Hogar Comprensivo Colones',670000,'anual');
insert into TipoSeguro values ('MED','INS Medical',95000,'anual');
insert into TipoSeguro values ('DPT','Daños a la Propiedad de Terceros',700000.00,'anual');
insert into TipoSeguro values ('INC','Contra Incendio',800000.00,'anual');
insert into TipoSeguro values ('ROB','Contra Robo',80000.00,'anual');
insert into TipoSeguro values ('ACC','De Accidentes',70000.00,'anual');
insert into TipoSeguro values ('ACE','Accidentes para Estudiantes',10000.00,'anual');
insert into TipoSeguro values ('ACU','Accidentes para Universitarios',90000.00,'semestral');
insert into TipoSeguro values ('VJR','Viajeros',50000.00,'anual');
insert into TipoSeguro values ('FID','Fidelidad Individual',5500000,'semestral');
insert into TipoSeguro values ('GFU','Gastos Funerarios',100000.00,'semestral');
insert into TipoSeguro values ('GME','Gastos Médicos',800.00,'anual');
insert into TipoSeguro values ('RDT','Riesgos del Trabajo',950000,'anual');
insert into TipoSeguro values ('PRO','Protección',90000.00,'anual');
insert into TipoSeguro values ('VID','Vida',70000.00,'anual');
insert into TipoSeguro values ('SAL','Salud',70000.00,'anual');
insert into TipoSeguro values ('TSI','Tarjeta Segura Individual',10000.00,'semestral');



select * from cobertura;

insert into cobertura values ('A','ACC','RCE POR LESIÓN Y/O MUERTE DE PERSONAS',2000000,'Descripcion');
insert into cobertura values ('A','ACE','RCE POR LESIÓN Y/O MUERTE DE PERSONAS',1500000,'Descripcion');
insert into cobertura values ('A','ACU','RCE POR LESIÓN Y/O MUERTE DE PERSONAS',1500000,'Descripcion');
insert into cobertura values ('A','GFU','RCE POR LESIÓN Y/O MUERTE DE PERSONAS',1000000,'Descripcion');
insert into cobertura values ('A','SVI','RCE POR LESIÓN Y/O MUERTE DE PERSONAS',3000000,'Descripcion');
insert into cobertura values ('A','VJR','RCE POR LESIÓN Y/O MUERTE DE PERSONAS',2800000,'Descripcion');
insert into cobertura values ('A','GME','RCE POR LESIÓN Y/O MUERTE DE PERSONAS',1700500,'Descripcion');
insert into cobertura values ('B','HCC','SERVICIOS MEDICOS FAMILIARES BÁSICA',400000,'Descripcion');
insert into cobertura values ('B','FID','SERVICIOS MEDICOS FAMILIARES BÁSICA',300000,'Descripcion');
insert into cobertura values ('B','PRO','SERVICIOS MEDICOS FAMILIARES BÁSICA',450000,'Descripcion');
insert into cobertura values ('C','DPT', 'RCE POR DAÑOS A LA PROPIEDAD DE TERCERAS  PERSONAS.',100,'Descripcion');
insert into cobertura values ('D','ASC', 'COLISIÓN Y/O VUELCO',2000000,'Descripcion');
insert into cobertura values ('D','CKC', 'COLISIÓN Y/O VUELCO',2000000,'Descripcion');
insert into cobertura values ('D','CKI', 'COLISIÓN Y/O VUELCO',2500300,'Descripcion');
insert into cobertura values ('D','SOA', 'COLISIÓN Y/O VUELCO',3100500,'Descripcion');
insert into cobertura values ('D','VDA', 'COLISIÓN Y/O VUELCO',1500000,'Descripcion');
insert into cobertura values ('D','SVI', 'COLISIÓN Y/O VUELCO',1500000,'Descripcion');
insert into cobertura values ('E','RDT', 'GASTOS LEGALES',100000,'Descripcion');
insert into cobertura values ('E','DPT', 'GASTOS LEGALES',1500000,'Descripcion');
insert into cobertura values ('E','FID', 'GASTOS LEGALES',500000,'Descripcion');
insert into cobertura values ('F','ROB', 'ROBO Y/O HURTO',1000000,'Descripcion');
insert into cobertura values ('F','DPT', 'ROBO Y/O HURTO',750000,'Descripcion');
insert into cobertura values ('F','TSI', 'ROBO Y/O HURTO',300000,'Descripcion');
insert into cobertura values ('G','ASC', 'MULTIASISTENCIA AUTOMÓVILES',500000,'Descripcion');
insert into cobertura values ('G','CKC', 'MULTIASISTENCIA AUTOMÓVILES',600000,'Descripcion');
insert into cobertura values ('G','CKI', 'MULTIASISTENCIA AUTOMÓVILES',350000,'Descripcion');
insert into cobertura values ('G','VDA', 'MULTIASISTENCIA AUTOMÓVILES',200000,'Descripcion');
insert into cobertura values ('H','ACE', 'RIESGOS ADICIONALES',100,'Descripcion');
insert into cobertura values ('H','ACC', 'RIESGOS ADICIONALES',100,'Descripcion');
insert into cobertura values ('H','VJR', 'RIESGOS ADICIONALES',100,'Descripcion');
insert into cobertura values ('H','MED', 'RIESGOS ADICIONALES',100,'Descripcion');
insert into cobertura values ('H','ROB', 'RIESGOS ADICIONALES',100,'Descripcion');
insert into cobertura values ('H','SAL', 'RIESGOS ADICIONALES',100,'Descripcion');
insert into cobertura values ('H','TSI', 'RIESGOS ADICIONALES',100,'Descripcion');
insert into cobertura values ('H','PRO', 'RIESGOS ADICIONALES',100,'Descripcion');
insert into cobertura values ('I','DPT', 'RCE EXTENDIDA POR LESION Y/O MUERTE DE PERSONAS Y/O DAÑOS A LA PROPIEDAD DE TERCERAS´PERSONAS',100,'Descripcion');
insert into cobertura values ('J','TSI', 'PÉRDIDAS DE OBJETOS PERSONALES',100,'Descripcion');
insert into cobertura values ('K','ROB', 'INDEMNIZACIÓN PARA TRANSPORTE ALTERNATIVO',100,'Descripcion');
insert into cobertura values ('L','SOA', 'RCEE POR LESIÓN Y/O MUERTE DE PERSONAS Y/O DAÑOS A LA PROPIEDAD DE TERCERAS PERSONAS, POR EL USO DE UN  AUTO SUSTITUTO',100,'Descripcion');
insert into cobertura values ('L','VDA', 'RCEE POR LESIÓN Y/O MUERTE DE PERSONAS Y/O DAÑOS A LA PROPIEDAD DE TERCERAS PERSONAS, POR EL USO DE UN  AUTO SUSTITUTO',100,'Descripcion');
insert into cobertura values ('L','SVI', 'RCEE POR LESIÓN Y/O MUERTE DE PERSONAS Y/O DAÑOS A LA PROPIEDAD DE TERCERAS PERSONAS, POR EL USO DE UN  AUTO SUSTITUTO',100,'Descripcion');
insert into cobertura values ('M','SVI', 'MULTIASISTENCIA EXTENDIDA INDIVIDUAL',100,'Descripcion');
insert into cobertura values ('M','MED', 'MULTIASISTENCIA EXTENDIDA INDIVIDUAL',100,'Descripcion');
insert into cobertura values ('M','FID', 'MULTIASISTENCIA EXTENDIDA INDIVIDUAL',100,'Descripcion');
insert into cobertura values ('M','GFU', 'MULTIASISTENCIA EXTENDIDA INDIVIDUAL',100,'Descripcion');
insert into cobertura values ('N','ASC', 'MULTIASISTENCIA EXTENDIDA COLECTIVA',100,'Descripcion');
insert into cobertura values ('N','PRO', 'MULTIASISTENCIA EXTENDIDA COLECTIVA',100,'Descripcion');
insert into cobertura values ('N','GME', 'MULTIASISTENCIA EXTENDIDA COLECTIVA',100,'Descripcion');
insert into cobertura values ('P','HCC', 'SERVICIOS MÉDICOS FAMILIARES PLUS Y MUERTE DE LOS OCUPANTES DEL  VEHÍCULO ASEGURADO',100,'Descripcion');
insert into cobertura values ('Y','DPT', 'EXTRATERRITORIALIDAD',100,'Descripcion');
insert into cobertura values ('Z','RDT', 'RIESGOS PARTICULARES',100,'Descripcion');
insert into cobertura values ('Z','ACC', 'RIESGOS PARTICULARES',100,'Descripcion');
insert into cobertura values ('Z','RDT', 'RIESGOS PARTICULARES',100,'Descripcion');


CREATE SEQUENCE polizaid
  MINVALUE 1
  MAXVALUE 999999999999999999999999999
  START WITH 1
  INCREMENT BY 1
  CACHE 20;

select * from polizas;
select * from rrhh.empleados; -- tiene idsede pero se refiere a la tabla sucursal 
select * from clientes;
select * from tiposeguro;
select * from polizasINS;
select * from beneficiariosINS;
truncate table polizasINS;



select * from rrhh.vendedores; 
drop table polizasINS; 

create table polizasINS(
NumPoliza 			varchar2(30) NOT NULL,
IdSeguro 			varchar2(30),
IdBeneficiario	varchar2(100),
PrimaTotal			decimal(10,2),
Fecha				date,
MontoAsegurado		decimal(10,2),
IdVendedor     		varchar2(30),
IdCliente     		varchar2(30),
CONSTRAINT pk_polizasins PRIMARY KEY (NumPoliza))--,
--CONSTRAINT fk_tiposeguro_polizas foreign key(IdSeguro) references tiposeguro(IdSeguro),
--CONSTRAINT fk_poliza_vendedor foreign key(IdVendedor) references rrhh.vendedores(IdVendedor),
--CONSTRAINT fk_poliza_cliente foreign key(IdCliente) references clientes(IdCliente))
tablespace data_tbs;

-- cursor que llena num poliza, id seguro, y id cliente 

Declare
      vidpoliza varchar2(30);
      CURSOR c1 is
      SELECT idcliente, idpersona FROM clientesINS where rownum < 5000;  -- por cada cliente haremos varias polizas
      CURSOR c2 is
      select idseguro, prima
      from tiposeguro
      where rownum = trunc(dbms_random.value(1,22));
BEGIN
   FOR i in c1
   LOOP
      for j in c2 loop
          vidpoliza := polizaid.nextval;
          insert into polizasINS (numpoliza, idseguro, idbeneficiario, primatotal, fecha, montoasegurado,idvendedor, idcliente)
          values (vidpoliza, -- numpoliza de secuencia 
                  j.idseguro,     -- idseguro de tiposeguro
                  null,     -- idbenef de beneficiario ASIGNADO DESPUES RANDOM 
                  null,     -- primatotal calculada de prima sacada de tipo seguro y se calcula segun monto asegurado.  (osea dejar esta para el final)
                  null,     -- fecha inventada
                  null,     -- montoasegurado random 
                  null,     -- idvendedor de vendedor   ASIGNADO DESPUES RANDOM 
                  i.idcliente     -- id cliente de cliente 
                  );
        END LOOP;
   END LOOP;
   commit;
END;

-- generar mismo cursor que llene idvendedor, id beneficiario 

-- 2.0  ojo, beneficiarios es multivalor, la tabla beneficiarios deberia tener columna de numpoliza, 
--
select * from polizasINS;

-- incluyendo vendedores en polizas
Declare
      CURSOR c1 is
      SELECT numpoliza FROM polizasINS;  -- por cada cliente haremos varias polizas
      CURSOR c2 is
      select idvendedor
      from rrhh.vendedores
      where rownum = 1 or
            rownum = trunc(dbms_random.value(1,130));
BEGIN
   FOR i in c1
   LOOP
      FOR j in c2
      LOOP
      update polizasINS set idvendedor = j.idvendedor
      where numpoliza = i.numpoliza; 
     END LOOP;
   END LOOP;
   commit;
END;

commit;

-- incluyendo beneficiarios 
select * from polizasINS;
select * from beneficiariosINS;
Declare
      CURSOR c1 is
      SELECT numpoliza FROM polizasINS;  -- por cada cliente haremos varias polizas
      CURSOR c2 is
      select idbeneficiario
      from beneficiariosINS
      where rownum = 1 or
            rownum = trunc(dbms_random.value(1,130));
BEGIN
   FOR i in c1
   LOOP
      FOR j in c2
      LOOP
      update polizasINS set idbeneficiario = j.idbeneficiario
      where numpoliza = i.numpoliza; 
     END LOOP;
   END LOOP;
   commit;
END;



BEGIN
  FOR i IN 1 .. 5 LOOP
    DBMS_OUTPUT.put_line('date= ' || to_char((to_date('01011960','ddmmyyyy') + DBMS_RANDOM.value(0,18300)),'dd-mm-yyyy'));
  END LOOP;
END;


---
--- Procedimiento para llenar Proveedores
---

Create or Replace procedure LlenarProveedores
is
  CURSOR c1 is
      SELECT IdPerjuridica
      FROM rrhh.personasjuridicas;  
      
  vIdPerjuridica varchar2(30);
  vCont int;
BEGIN
  vCont:=0;
  for i in c1 loop 
    vIdPerjuridica :=i.IdPerjuridica;
    vCont:= vCont+1;
    insert into proveedores values(vCont,vIdPerjuridica,(SELECT DBMS_RANDOM.string('u', 9) FROM dual));
  end loop; 
END;

execute LlenarProveedores;


select * from proveedores;

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

---insertar clientes juridicos
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

  
-- utilizado en otras tablas pero irrelevante pero con datos
select * from fechas;