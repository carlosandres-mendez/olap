
  
--Tabla tiposeguro permanece igual. 
drop table polizas;    -- nueva tabla - polizasINS
drop table cobertura;   -- nueva tabla - coberturasINS
drop table clientes, clientes2; -- nueva tabla clientesINS
drop table proveedores; 
drop table beneficiarios; 


-- SELECTS 

select * from coberturasINS;
select * from rrhh.empleados; -- tiene idsede pero se refiere a la tabla sucursal 
select * from tiposeguro;
select * from polizasINS;
select * from beneficiariosINS;
truncate table polizasINS;
select * from rrhh.vendedores; 
select * from proveedoresins; -- calos 

-- creacion de la tabla clientesINS segun buena definicion, aunque sin FK a persona por issue
create table clientesINS(
IdCliente     varchar2(30) NOT NULL,
IdPersona     varchar2(30) NOT NULL,
Profesion     varchar2(60),
Nivel_Aca     varchar2(60),
CONSTRAINT pk_clientesins PRIMARY KEY (IdCliente), --yo descomenté este constraint (carlos)
CONSTRAINT fk_persona_clientes foreign key(IdPersona) references rrhh.personas(IdPersona))
tablespace data_tbs;

drop table clientesINS;
select * from clientesINS;
select count(*) from clientesINS; -- hay 100 000 clientes 
select * from rrhh.personas;  -- isssue

--- insertar en clientes creacion de secuencia  y cursor para insertarlos 
--drop sequence clientesid;  puede ser necesario (carlos)
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
        -- insert into clientesINS values(i.IDPERSONA, clientesid.nextval, null, null);
         insert into clientesINS values(clientesid.nextval, i.IDPERSONA, null, null);
  end loop;
end;

-- falta updates para insertar profesion y nivel academico 

select * from rrhh.vendedores; -- rrhh  hay 131 vendedores
select * from sucursal;  -- ojo, donde rayos metemos sucursal --- nombre malo deberia ser sede 
select * from rrhh.empleados;
select * from vendedor;

-- ///////////////////////////////////////////////////////////////////////////////////////////
-- no entregado 
commit;
select * from proveedoresINS;

grant select, references on personas to ventas;  -- correr esto en rrhh
grant select, references on personasjuridicas to ventas;  -- correr esto en rrhh

create table proveedoresINS(
IdProveedor     varchar2(30) NOT NULL,
IdPerjuridica   varchar2(30) NOT NULL,
Nombre     		varchar2(60),
CONSTRAINT pk_proveedoresins PRIMARY KEY (IdProveedor), --ya existen las personasjuridicas se puede descomentar(carlos)
CONSTRAINT fk_perjuridica_proveedores foreign key(IdPerjuridica) references rrhh.personasjuridicas(IdPerjuridica))
tablespace ventas_tbs;
CREATE SEQUENCE proveedoresid
  MINVALUE 1
  MAXVALUE 999999999999999999999999999
  START WITH 1
  INCREMENT BY 1
  CACHE 20; 
/*
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
*/
create table relacionFamiliar(
relacion 		varchar2(30)
);

insert into relacionFamiliar values('Padre/Madre');
insert into relacionFamiliar values('Esposo/Esposa');
insert into relacionFamiliar values('Hijo/Hija');
insert into relacionFamiliar values('Hermano/Hermana');
insert into relacionFamiliar values('Otro');


select * from beneficiariosINS;
drop table beneficiariosINS;

create table beneficiariosINS(
IdBeneficiario 		varchar2(30) NOT NULL,
IdPerFisica       varchar2(30) NOT NULL,
RelacionConCliente  varchar2(30),
NumPoliza         varchar2(30) NOT NULL,   
CONSTRAINT pk_beneficiariosins PRIMARY KEY (IdBeneficiario),
CONSTRAINT fk_perfisica_beneficiariosins foreign key(IdBeneficiario) references rrhh.personasfisicas(IdPerFisica),
CONSTRAINT fk_numpoliza_beneficiariosins foreign key (numPoliza) references ventas.polizasINS(numPoliza))
tablespace ventas_tbs;

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
  where rownum<=10000;
  vnumpoliza        varchar2(30);
  vrelacion   varchar2(30);
begin
  for i in m 
  loop    
      select numpoliza
      into  vnumpoliza
      from (select numpoliza
            FROM polizasINS 
            order by dbms_random.value) 
      where rownum = 1;
      select relacion
      into  vrelacion
      from (select relacion 
            FROM RELACIONFAMILIAR 
            order by dbms_random.value) 
      where rownum = 1;
        --insert into beneficiariosINS values(i.IDPERFISICA, clientesid.nextval, vrelacion,vnumpoliza );
          insert into beneficiariosINS values(beneficiarioid.nextval, i.IDPERFISICA, vrelacion,vnumpoliza );
  end loop;
end;


create table tiposeguro(
IdSeguro 	varchar2(30) NOT NULL,
Nombre 		varchar2(100),
Vigencia	varchar2(30),
CONSTRAINT pk_tiposeguro PRIMARY KEY (IdSeguro))
tablespace data_tbs;

ALTER TABLE tiposeguro
drop column prima; 

create table coberturasINS(
IdCobertura varchar2(30) NOT NULL,
IdSeguro	varchar2(30) NOT NULL,
Nombre		varchar2(100),
Tarifa 		decimal(10,2),
Descripcion varchar2(200),
CONSTRAINT pk_coberturasIns PRIMARY KEY (IdCobertura,IdSeguro),
CONSTRAINT fk_tiposeguro_coberturasIns 
           foreign key(IdSeguro)
           references tiposeguro(IdSeguro))
tablespace ventas_tbs;

select * from tiposeguro;
insert into TipoSeguro values ('ASC','Asistencia en Carretera',,'anual');
insert into TipoSeguro values ('CKC','Cero Kilometros Colectiva','semestral');
insert into TipoSeguro values ('CKI','Cero Kilometros Individual','semestral');
insert into TipoSeguro values ('SOA','Obligatorio de Automóviles','anual');
insert into TipoSeguro values ('VDA','Voluntario de Automóviles','anual');
insert into TipoSeguro values ('SVI','Su Vida','semestral');
insert into TipoSeguro values ('HCC','Hogar Comprensivo Colones',,'anual');
insert into TipoSeguro values ('MED','INS Medical',,'anual');
insert into TipoSeguro values ('DPT','Daños a la Propiedad de Terceros','anual');
insert into TipoSeguro values ('INC','Contra Incendio','anual');
insert into TipoSeguro values ('ROB','Contra Robo','anual');
insert into TipoSeguro values ('ACC','De Accidentes','anual');
insert into TipoSeguro values ('ACE','Accidentes para Estudiantes','anual');
insert into TipoSeguro values ('ACU','Accidentes para Universitarios','semestral');
insert into TipoSeguro values ('VJR','Viajeros','anual');
insert into TipoSeguro values ('FID','Fidelidad Individual',,'semestral');
insert into TipoSeguro values ('GFU','Gastos Funerarios','semestral');
insert into TipoSeguro values ('GME','Gastos Médicos','anual');
insert into TipoSeguro values ('RDT','Riesgos del Trabajo',,'anual');
insert into TipoSeguro values ('PRO','Protección','anual');
insert into TipoSeguro values ('VID','Vida','anual');
insert into TipoSeguro values ('SAL','Salud','anual');
insert into TipoSeguro values ('TSI','Tarjeta Segura Individual','semestral');


insert into coberturasINS values ('A','ACC','RCE POR LESIÓN Y/O MUERTE DE PERSONAS',15,'Descripcion');
insert into coberturasINS values ('A','ACE','RCE POR LESIÓN Y/O MUERTE DE PERSONAS',16,'Descripcion');
insert into coberturasINS values ('A','ACU','RCE POR LESIÓN Y/O MUERTE DE PERSONAS',30,'Descripcion');
insert into coberturasINS values ('A','GFU','RCE POR LESIÓN Y/O MUERTE DE PERSONAS',23,'Descripcion');
insert into coberturasINS values ('A','SVI','RCE POR LESIÓN Y/O MUERTE DE PERSONAS',24,'Descripcion');
insert into coberturasINS values ('A','VJR','RCE POR LESIÓN Y/O MUERTE DE PERSONAS',10,'Descripcion');
insert into coberturasINS values ('A','GME','RCE POR LESIÓN Y/O MUERTE DE PERSONAS',12,'Descripcion');
insert into coberturasINS values ('A','INC','RCE POR LESIÓN Y/O MUERTE DE PERSONAS',20,'Descripcion');
insert into coberturasINS values ('B','HCC','SERVICIOS MEDICOS FAMILIARES BÁSICA',17,'Descripcion');
insert into coberturasINS values ('B','FID','SERVICIOS MEDICOS FAMILIARES BÁSICA',14,'Descripcion');
insert into coberturasINS values ('B','PRO','SERVICIOS MEDICOS FAMILIARES BÁSICA',13,'Descripcion');
insert into coberturasINS values ('C','DPT', 'RCE POR DAÑOS A LA PROPIEDAD DE TERCERAS  PERSONAS.',15,'Descripcion');
insert into coberturasINS values ('D','ASC', 'COLISIÓN Y/O VUELCO',16,'Descripcion');
insert into coberturasINS values ('D','CKC', 'COLISIÓN Y/O VUELCO',13,'Descripcion');
insert into coberturasINS values ('D','CKI', 'COLISIÓN Y/O VUELCO',15,'Descripcion');
insert into coberturasINS values ('D','SOA', 'COLISIÓN Y/O VUELCO',13,'Descripcion');
insert into coberturasINS values ('D','VDA', 'COLISIÓN Y/O VUELCO',16,'Descripcion');
insert into coberturasINS values ('D','SVI', 'COLISIÓN Y/O VUELCO',15,'Descripcion');
insert into coberturasINS values ('E','RDT', 'GASTOS LEGALES',4,'Descripcion');
insert into coberturasINS values ('E','DPT', 'GASTOS LEGALES',5,'Descripcion');
insert into coberturasINS values ('E','FID', 'GASTOS LEGALES',6,'Descripcion');
insert into coberturasINS values ('F','ROB', 'ROBO Y/O HURTO',10,'Descripcion');
insert into coberturasINS values ('F','DPT', 'ROBO Y/O HURTO',9,'Descripcion');
insert into coberturasINS values ('F','TSI', 'ROBO Y/O HURTO',7,'Descripcion');
insert into coberturasINS values ('G','ASC', 'MULTIASISTENCIA AUTOMÓVILES',7,'Descripcion');
insert into coberturasINS values ('G','CKC', 'MULTIASISTENCIA AUTOMÓVILES',7,'Descripcion');
insert into coberturasINS values ('G','CKI', 'MULTIASISTENCIA AUTOMÓVILES',8,'Descripcion');
insert into coberturasINS values ('G','VDA', 'MULTIASISTENCIA AUTOMÓVILES',10,'Descripcion');
insert into coberturasINS values ('H','ACE', 'RIESGOS ADICIONALES',9,'Descripcion');
insert into coberturasINS values ('H','ACC', 'RIESGOS ADICIONALES',9,'Descripcion');
insert into coberturasINS values ('H','VJR', 'RIESGOS ADICIONALES',5,'Descripcion');
insert into coberturasINS values ('H','MED', 'RIESGOS ADICIONALES',17,'Descripcion');
insert into coberturasINS values ('H','ROB', 'RIESGOS ADICIONALES',8,'Descripcion');
insert into coberturasINS values ('H','SAL', 'RIESGOS ADICIONALES',12,'Descripcion');
insert into coberturasINS values ('H','TSI', 'RIESGOS ADICIONALES',9,'Descripcion');
insert into coberturasINS values ('H','PRO', 'RIESGOS ADICIONALES',6,'Descripcion');
insert into coberturasINS values ('I','DPT', 'RCE EXTENDIDA POR LESION Y/O MUERTE DE PERSONAS Y/O DAÑOS A LA PROPIEDAD DE TERCERAS´PERSONAS',15,'Descripcion');
insert into coberturasINS values ('J','TSI', 'PÉRDIDAS DE OBJETOS PERSONALES',5,'Descripcion');
insert into coberturasINS values ('K','ROB', 'INDEMNIZACIÓN PARA TRANSPORTE ALTERNATIVO',4,'Descripcion');
insert into coberturasINS values ('L','SOA', 'RCEE POR LESIÓN Y/O MUERTE DE PERSONAS Y/O DAÑOS A LA PROPIEDAD DE TERCERAS PERSONAS, POR EL USO DE UN  AUTO SUSTITUTO',10,'Descripcion');
insert into coberturasINS values ('L','VDA', 'RCEE POR LESIÓN Y/O MUERTE DE PERSONAS Y/O DAÑOS A LA PROPIEDAD DE TERCERAS PERSONAS, POR EL USO DE UN  AUTO SUSTITUTO',9,'Descripcion');
insert into coberturasINS values ('L','SVI', 'RCEE POR LESIÓN Y/O MUERTE DE PERSONAS Y/O DAÑOS A LA PROPIEDAD DE TERCERAS PERSONAS, POR EL USO DE UN  AUTO SUSTITUTO',9,'Descripcion');
insert into coberturasINS values ('M','SVI', 'MULTIASISTENCIA EXTENDIDA INDIVIDUAL',11,'Descripcion');
insert into coberturasINS values ('M','MED', 'MULTIASISTENCIA EXTENDIDA INDIVIDUAL',10,'Descripcion');
insert into coberturasINS values ('M','FID', 'MULTIASISTENCIA EXTENDIDA INDIVIDUAL',7,'Descripcion');
insert into coberturasINS values ('M','GFU', 'MULTIASISTENCIA EXTENDIDA INDIVIDUAL',5,'Descripcion');
insert into coberturasINS values ('N','ASC', 'MULTIASISTENCIA EXTENDIDA COLECTIVA',9,'Descripcion');
insert into coberturasINS values ('N','PRO', 'MULTIASISTENCIA EXTENDIDA COLECTIVA',10,'Descripcion');
insert into coberturasINS values ('N','INC', 'MULTIASISTENCIA EXTENDIDA COLECTIVA',10,'Descripcion');
insert into coberturasINS values ('N','GME', 'MULTIASISTENCIA EXTENDIDA COLECTIVA',5,'Descripcion');
insert into coberturasINS values ('P','HCC', 'SERVICIOS MÉDICOS FAMILIARES PLUS Y MUERTE DE LOS OCUPANTES DEL  VEHÍCULO ASEGURADO',8,'Descripcion');
insert into coberturasINS values ('Y','DPT', 'EXTRATERRITORIALIDAD',15,'Descripcion');
insert into coberturasINS values ('Z','RDT', 'RIESGOS PARTICULARES',19,'Descripcion');
insert into coberturasINS values ('Z','ACC', 'RIESGOS PARTICULARES',16,'Descripcion');
insert into coberturasINS values ('Z','ACE', 'RIESGOS PARTICULARES',15,'Descripcion');
insert into coberturasINS values ('Z','INC', 'RIESGOS PARTICULARES',15,'Descripcion');
drop sequence polizaid;
CREATE SEQUENCE polizaid
  MINVALUE 1
  MAXVALUE 999999999999999999999999999
  START WITH 1
  INCREMENT BY 1
  CACHE 20;

select * from polizasINS;
create table polizasINS(
NumPoliza 			varchar2(30) NOT NULL,
IdSeguro 			varchar2(30),
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

ALTER TABLE polizasINS
drop column idbeneficiario; 

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

-- incluyendo fechas en polizas 

Declare
      CURSOR c1 is
      SELECT numpoliza FROM polizasINS;
      vfecha         date;
BEGIN
   FOR i in c1
   LOOP
      select fecha
      into   vfecha
      from ( select fecha
             from   parametros.fechas
             where  fecha between to_date('01012010','ddmmyyyy') and to_date ('31122015','ddmmyyyy')
             order by dbms_random.value)
      where rownum  = 1;
      update polizasINS set fecha = vfecha
      where numpoliza = i.numpoliza; 
   END LOOP;
END;

-- insertando montoAsegurado
Declare
      CURSOR c1 is
      SELECT numpoliza FROM polizasINS;
      vmonto         decimal(10,2);
BEGIN
   FOR i in c1
   LOOP
      select trunc(DBMS_RANDOM.Value(300000,25000000)) 
      into  vmonto
      from DUAL;
      update polizasINS set montoasegurado = vmonto
      where numpoliza = i.numpoliza; 
   END LOOP;
END;

-- incluyendo beneficiarios 
select * from polizasINS;
select * from coberturasINS;
Declare
      CURSOR c1 is
      SELECT numpoliza, idseguro, montoasegurado FROM polizasINS;  
      CURSOR c2 is
      select idCobertura, idseguro,tarifa 
      from coberturasINS;
BEGIN
   FOR i in c1
   LOOP
      FOR j in c2
      LOOP
      update polizasINS set primaTotal = (i.montoasegurado * (j.tarifa / 1000))
      where numpoliza = i.numpoliza and idseguro = j.idseguro and idseguro = i.idseguro; 
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
select * from proveedoresins;
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

