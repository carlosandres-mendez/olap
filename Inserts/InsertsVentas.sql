
-- inserts para clientes y facturas (polizas) y detfacturas (coberturas)
-- inserts para coberturas (seguros y tipos de seguro)

CREATE SEQUENCE clienteid
  MINVALUE 1
  MAXVALUE 999999999999999999999999999
  START WITH 1
  INCREMENT BY 1
  CACHE 20;

CREATE SEQUENCE polizaid
  MINVALUE 1
  MAXVALUE 999999999999999999999999999
  START WITH 1
  INCREMENT BY 1
  CACHE 20;

-- insercion de clientes ojo minimo 100 mil

insert into clientes
select to_char(clienteid.nextval), idpersona, null 
from (
select *
from   parametros.personas
order by dbms_random.value) r1
where rownum < 100001;

-- insercion proveedores

-- insercion tiposeguro
-- IdSeguro Nombre Prima Vigencia
-- Ojo* Cambiar en tabla: Vigencia es solo un varchar 

insert into TipoSeguro values ('ASC','Asistencia en Carretera',100,'anual');
insert into TipoSeguro values ('CKC','Cero Kilometros Colectiva',70,'semestral');
insert into TipoSeguro values ('CKI','Cero Kilometros Individual',60,'semestral');
insert into TipoSeguro values ('SOA','Obligatorio de Automóviles',100,'anual');
insert into TipoSeguro values ('VDA','Voluntario de Automóviles',60,'anual');
insert into TipoSeguro values ('SVI','Su Vida',70,'semestral');

insert into TipoSeguro values ('HCC','Hogar Comprensivo Colones',67,'anual');
insert into TipoSeguro values ('MED','INS Medical',95,'anual');
insert into TipoSeguro values ('DPT','Daños a la Propiedad de Terceros',70,'anual');
insert into TipoSeguro values ('INC','Contra Incendio',80,'anual');
insert into TipoSeguro values ('ROB','Contra Robo',80,'anual');

insert into TipoSeguro values ('ACC','De Accidentes',70,'anual');
insert into TipoSeguro values ('ACE','Accidentes para Estudiantes',100,'anual');
insert into TipoSeguro values ('ACU','Accidentes para Universitarios',90,'semestral');
insert into TipoSeguro values ('VJR','Viajeros',50,'anual');
insert into TipoSeguro values ('FID','Fidelidad Individual',55,'semestral');
insert into TipoSeguro values ('GFU','Gastos Funerarios',100,'semestral');
insert into TipoSeguro values ('GME','Gastos Médicos',80,'anual');
insert into TipoSeguro values ('RDT','Riesgos del Trabajo',95,'anual');
insert into TipoSeguro values ('PRO','Protección',90,'anual');
insert into TipoSeguro values ('VID','Vida',70,'anual');
insert into TipoSeguro values ('SAL','Salud',70,'anual');
insert into TipoSeguro values ('TSI','Tarjeta Segura Individual',100,'semestral');

-- Cursor para insertar fechas en vigencia de tipo seguro 

--- POR HACER


-- insercion cobertura
-- IdCobertura, IdSeguro, Nombre, Monto,Descripcion
-- Recordemos que este monto es el dinero que le dan a uno si pasa el accidente 
-- lo que paga el comprador del seguro es un porcentaje pequeño semestral o anual de ese monto
-- aclaracion: RCE es Responsabilidad Civil Extracontractual

insert into coberturas values ('A','ACC','RCE POR LESIÓN Y/O MUERTE DE PERSONAS',2000000,'Descripcion');
insert into coberturas values ('A','ACE','RCE POR LESIÓN Y/O MUERTE DE PERSONAS',1500000,'Descripcion');
insert into coberturas values ('A','ACU','RCE POR LESIÓN Y/O MUERTE DE PERSONAS',1500000,'Descripcion');
insert into coberturas values ('A','GFU','RCE POR LESIÓN Y/O MUERTE DE PERSONAS',1000000,'Descripcion');
insert into coberturas values ('A','SVI','RCE POR LESIÓN Y/O MUERTE DE PERSONAS',3000000,'Descripcion');
insert into coberturas values ('A','VJR','RCE POR LESIÓN Y/O MUERTE DE PERSONAS',2800000,'Descripcion');
insert into coberturas values ('A','GME','RCE POR LESIÓN Y/O MUERTE DE PERSONAS',1700500,'Descripcion');

insert into coberturas values ('B','HCC','SERVICIOS MEDICOS FAMILIARES BÁSICA',400000,'Descripcion');
insert into coberturas values ('B','FID','SERVICIOS MEDICOS FAMILIARES BÁSICA',300000,'Descripcion');
insert into coberturas values ('B','PRO','SERVICIOS MEDICOS FAMILIARES BÁSICA',450000,'Descripcion');

insert into coberturas values ('C','DPT', 'RCE POR DAÑOS A LA PROPIEDAD DE TERCERAS  PERSONAS.',100,'Descripcion');

insert into coberturas values ('D','ASC', 'COLISIÓN Y/O VUELCO',2000000,'Descripcion');
insert into coberturas values ('D','CKC', 'COLISIÓN Y/O VUELCO',2000000,'Descripcion');
insert into coberturas values ('D','CKI', 'COLISIÓN Y/O VUELCO',2500300,'Descripcion');
insert into coberturas values ('D','SOA', 'COLISIÓN Y/O VUELCO',3100500,'Descripcion');
insert into coberturas values ('D','VDA', 'COLISIÓN Y/O VUELCO',1500000,'Descripcion');
insert into coberturas values ('D','SVI', 'COLISIÓN Y/O VUELCO',1500000,'Descripcion');

insert into coberturas values ('E','RDT', 'GASTOS LEGALES',100000,'Descripcion');
insert into coberturas values ('E','DPT', 'GASTOS LEGALES',1500000,'Descripcion');
insert into coberturas values ('E','FID', 'GASTOS LEGALES',500000,'Descripcion');

insert into coberturas values ('F','ROB', 'ROBO Y/O HURTO',1000000,'Descripcion');
insert into coberturas values ('F','DPT', 'ROBO Y/O HURTO',750000,'Descripcion');
insert into coberturas values ('F','TSI', 'ROBO Y/O HURTO',300000,'Descripcion');

insert into coberturas values ('G','ASC', 'MULTIASISTENCIA AUTOMÓVILES',500000,'Descripcion');
insert into coberturas values ('G','CKC', 'MULTIASISTENCIA AUTOMÓVILES',600000,'Descripcion');
insert into coberturas values ('G','CKI', 'MULTIASISTENCIA AUTOMÓVILES',350000,'Descripcion');
insert into coberturas values ('G','VDA', 'MULTIASISTENCIA AUTOMÓVILES',200000,'Descripcion');

-- EN PROCESO
insert into coberturas values ('H','ACE', 'RIESGOS ADICIONALES',100,'Descripcion');
insert into coberturas values ('H','ACC', 'RIESGOS ADICIONALES',100,'Descripcion');
insert into coberturas values ('H','VJR', 'RIESGOS ADICIONALES',100,'Descripcion');
insert into coberturas values ('H','MED', 'RIESGOS ADICIONALES',100,'Descripcion');
insert into coberturas values ('H','ROB', 'RIESGOS ADICIONALES',100,'Descripcion');
insert into coberturas values ('H','SAL', 'RIESGOS ADICIONALES',100,'Descripcion');
insert into coberturas values ('H','TSI', 'RIESGOS ADICIONALES',100,'Descripcion');
insert into coberturas values ('H','PRO', 'RIESGOS ADICIONALES',100,'Descripcion');



insert into coberturas values ('I','DPT', 'RCE EXTENDIDA POR LESION Y/O MUERTE DE PERSONAS Y/O DAÑOS A LA PROPIEDAD DE TERCERAS´PERSONAS',100,'Descripcion');

insert into coberturas values ('J','TSI', 'PÉRDIDAS DE OBJETOS PERSONALES',100,'Descripcion');
insert into coberturas values ('K','ROB', 'INDEMNIZACIÓN PARA TRANSPORTE ALTERNATIVO',100,'Descripcion');

insert into coberturas values ('L','SOA', 'RCEE POR LESIÓN Y/O MUERTE DE PERSONAS Y/O DAÑOS A LA PROPIEDAD DE TERCERAS PERSONAS, POR EL USO DE UN  AUTO SUSTITUTO',100,'Descripcion');
insert into coberturas values ('L','VDA', 'RCEE POR LESIÓN Y/O MUERTE DE PERSONAS Y/O DAÑOS A LA PROPIEDAD DE TERCERAS PERSONAS, POR EL USO DE UN  AUTO SUSTITUTO',100,'Descripcion');
insert into coberturas values ('L','SVI', 'RCEE POR LESIÓN Y/O MUERTE DE PERSONAS Y/O DAÑOS A LA PROPIEDAD DE TERCERAS PERSONAS, POR EL USO DE UN  AUTO SUSTITUTO',100,'Descripcion');

insert into coberturas values ('M','SVI', 'MULTIASISTENCIA EXTENDIDA INDIVIDUAL',100,'Descripcion');
insert into coberturas values ('M','MED', 'MULTIASISTENCIA EXTENDIDA INDIVIDUAL',100,'Descripcion');
insert into coberturas values ('M','FID', 'MULTIASISTENCIA EXTENDIDA INDIVIDUAL',100,'Descripcion');
insert into coberturas values ('M','GFU', 'MULTIASISTENCIA EXTENDIDA INDIVIDUAL',100,'Descripcion');

insert into coberturas values ('N','ASC', 'MULTIASISTENCIA EXTENDIDA COLECTIVA',100,'Descripcion');
insert into coberturas values ('N','PRO', 'MULTIASISTENCIA EXTENDIDA COLECTIVA',100,'Descripcion');
insert into coberturas values ('N','GME', 'MULTIASISTENCIA EXTENDIDA COLECTIVA',100,'Descripcion');

insert into coberturas values ('P','HCC', 'SERVICIOS MÉDICOS FAMILIARES PLUS Y MUERTE DE LOS OCUPANTES DEL  VEHÍCULO ASEGURADO',100,'Descripcion');

insert into coberturas values ('Y','DPT', 'EXTRATERRITORIALIDAD',100,'Descripcion');

insert into coberturas values ('Z','RDT', 'RIESGOS PARTICULARES',100,'Descripcion');
insert into coberturas values ('Z','ACC', 'RIESGOS PARTICULARES',100,'Descripcion');
insert into coberturas values ('Z','RDT', 'RIESGOS PARTICULARES',100,'Descripcion');


-- cursor insercion polizas  

-- POR HACER
-- podemos ayudarnos con este cursor que hizo el profe 

truncate table polizas;

DECLARE
   CURSOR c1 is
      SELECT idcliente, idpersona FROM clientes where rownum < 2001;
   CURSOR c2 is
      select IdSeguro, Prima, IdCobertura, Monto, Vigencia
      from (
            select IdCobertura, IdSeguro, Monto
            from   coberturas
            order by dbms_random.value) r1
      where rownum = 1 or
            rownum = trunc(dbms_random.value(1,4)); -- cantidad de seguros por cliente  
   vcont          integer;
   vcont2         integer;
   vidcliente     varchar2(30);
   vidpersona     varchar2(30);
   vcantpolizas  integer;
   vNumPoliza     varchar2(30);
   vfecha         date;
   vcantcoberturas integer;
   vcontseguros     integer;
   vcontador      integer;
BEGIN
   dbms_output.put_line ('fecha inicio '||to_char(sysdate,'dd-mm-yyyy:hh:mi:ss'));
   VCONT := 0;
   vcantpolizas := 0;
   FOR i IN c1 LOOP
      vcont := vcont + 1;
      vidpersona := i.idpersona;
      vidcliente := i.idcliente;
      --DBMS_OUTPUT.put_line('idcliente es:'||vidcliente || ' ' || vidpersona);
      vcantpolizas := 0;
      vcont2        := 0;
      select trunc(dbms_random.value(1,10)) 
      into   vcantpolizas
      from   dual;
      loop
          vcont2 := vcont2 + 1;
          select to_char(NumPoliza.nextval) into vNumPoliza from dual;
          select fecha
          into   vfecha
          from ( select fecha
                 from   parametros.fechas
                 where  fecha between to_date('01012010','ddmmyyyy') and to_date ('31122015','ddmmyyyy')
                 order by dbms_random.value)
          where rownum  = 1;
          insert into polizas values (vNumPoliza, vidcliente, null, null,null, vfecha);
          vcontlinea := 0;
          for j in c2 loop
              vcontlinea := vcontlinea + 1;
              select trunc(dbms_random.value(1,10)) 
              into   vcantcoberturas 
              from   dual;
              insert into detfactura
              values (vidfactura, vcontlinea, j.idproducto, vcantcoberturas, null); 
          EXIT WHEN c2%NOTFOUND;
          end loop;
          exit when vcont2 >= vcantfacturas;
      end loop; 
      vcontador := vcontador + 1;
      if vcontador >= 5000 then
         commit;
         vcontador := 0;
      end if;
      EXIT WHEN c1%NOTFOUND;  
   END LOOP;
   commit;
   dbms_output.put_line ('fecha fin '||to_char(sysdate,'dd-mm-yyyy:hh:mi:ss'));   
END;

---
--- cursor para llenar detfactura con montos segun precio coberturas 
---

DECLARE
   CURSOR llenarMontoDetFactura is
      SELECT idproducto, preciounidad FROM coberturas;
      elmontolinea int; 
BEGIN
   for i in llenarMontoDetFactura loop
      elmontolinea := i.preciounidad;
      update detfactura SET montolinea = elmontolinea where idproducto = i.idproducto;
      EXIT WHEN llenarMontoDetFactura%NOTFOUND;
   end loop;
END;

---
--- Cursor para llenar factura segun los montos de detfactura
---
DECLARE
   CURSOR llenarMontoFactura is
      SELECT idfactura, numlinea, cantidad, montolinea FROM detfactura;
      elmonto int; 
BEGIN
    update factura set monto = 0; 
   for i in llenarMontoFactura loop
      elmonto := i.cantidad * i.montolinea;
      update factura SET monto = elmonto + monto where idfactura = i.idfactura;
      EXIT WHEN llenarMontoFactura%NOTFOUND;
   end loop;
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
    insert into proveedoresins (idproveedor,idperjuridica) values(vCont,vIdPerjuridica);
  end loop; 
END;

execute LlenarProveedores;

CREATE TABLE NombreProveedores
( 
  idnp int not null,
  nombreProveedor varchar2(50) NOT NULL
);

ALTER TABLE NombreProveedores
ADD CONSTRAINT pk_NombreProveedores PRIMARY KEY (nombreProveedor);

insert into NombreProveedores values(1,'Advanced Cath');
insert into NombreProveedores values(2,'Applied Medical Precision');
insert into NombreProveedores values(3,'Cincotek');
insert into NombreProveedores values(4,'G.Rau ');
insert into NombreProveedores values(5,'International Precision Molds');
insert into NombreProveedores values(6,'Kelpac Medical');
insert into NombreProveedores values(7,'MedConx');
insert into NombreProveedores values(8,'Merrill’s Packaging');
insert into NombreProveedores values(9,'Micro Technologies');
insert into NombreProveedores values(10,'Microbiological Compliance Lab');

insert into NombreProveedores values(11,'National Building Maintenance');
insert into NombreProveedores values(12,'Neometrics');
insert into NombreProveedores values(13,'Oberg Industries');
insert into NombreProveedores values(14,'Okay Industries');
insert into NombreProveedores values(15,'Penn United');
insert into NombreProveedores values(16,'Precision Wire Components');
insert into NombreProveedores values(17,'Prent');
insert into NombreProveedores values(18,'Nelipak');
insert into NombreProveedores values(19,'Specialty Coating Systems');
insert into NombreProveedores values(20,'Veridiam Medical');

insert into NombreProveedores values(21,'Accenture');
insert into NombreProveedores values(22,'Costa Rica Production');
insert into NombreProveedores values(23,'Magma Studios');
insert into NombreProveedores values(24,'Paprika');
insert into NombreProveedores values(25,'Pop Digital');
insert into NombreProveedores values(26,'Possible');
insert into NombreProveedores values(27,'The Hangar Interactive');
insert into NombreProveedores values(28,'Crane');
insert into NombreProveedores values(29,'GNFT ');
insert into NombreProveedores values(30,'L3 Communications');

insert into NombreProveedores values(31,'Panduit');
insert into NombreProveedores values(32,'Promotel');
insert into NombreProveedores values(33,'Suttle');
insert into NombreProveedores values(34,'Eaton');
insert into NombreProveedores values(35,'Havells Sylvania');
insert into NombreProveedores values(36,'Phelps Dodge');
insert into NombreProveedores values(37,'Triquint');
insert into NombreProveedores values(38,'Electrotechnik');
insert into NombreProveedores values(39,'Merlin VMS');
insert into NombreProveedores values(40,'Samtec');

insert into NombreProveedores values(41,'Altanova');
insert into NombreProveedores values(42,'Avionix');
insert into NombreProveedores values(43,'Emerson');
insert into NombreProveedores values(44,'Intel EDC');
insert into NombreProveedores values(45,'National Instruments');
insert into NombreProveedores values(46,'Twin Engines');
insert into NombreProveedores values(47,'Camtronics');
insert into NombreProveedores values(48,'ClamCleat');
insert into NombreProveedores values(49,'General Microcircuits');
insert into NombreProveedores values(50,'Irazu Electronics');

----Llenar os nombres De los proveedores
Create or Replace procedure LlenarNombresProveedores
is
  CURSOR c1 is
      SELECT idproveedor
      FROM ventas.proveedoresins; 
      
      vCont int;

BEGIN
  vCont:=1;
  for i in c1 loop 
                      
  update proveedoresins set nombre = (select nombreproveedor from NombreProveedores where idnp= vCont) where idproveedor= i.idproveedor ;
  end loop; 
END;

execute LlenarNombresProveedores;

select * from NombreProveedores;
select * from proveedoresins;
--- insertar en clientes

--insertar clientes físicos

declare
  cursor personafisi is
  select IDPERFISICA
  from   rrhh.personasfisicas
  where rownum<=100000;
  
begin
  for perf in personafisi loop    
        insert into clientesins values(perf.IDPERFISICA, perf.IDPERFISICA, (SELECT DBMS_RANDOM.string('u', 1) FROM dual), (SELECT DBMS_RANDOM.string('u', 1) FROM dual));
  end loop;
end;

select count(*) from clientesins;

---insertar clientes juridicos
declare
  cursor personafisi is
  select IDPERJURIDICA
  from   RRHH.PERSONASJURIDICAS
  where rownum<=50;
  
begin
  for perf in personafisi loop    
        insert into clientesins values(perf.IDPERJURIDICA, perf.IDPERJURIDICA, (SELECT DBMS_RANDOM.string('u', 1) FROM dual), (SELECT DBMS_RANDOM.string('u', 1) FROM dual));
  end loop;
end;

--Para Llenar profesiones y nivel Academico

CREATE TABLE profesiones
( 
  nombreprofesion varchar2(50) NOT NULL
);

CREATE TABLE nivelAcademico
( 
  nombreNivel varchar2(50) NOT NULL
);

ALTER TABLE profesiones
ADD CONSTRAINT pk_profesiones PRIMARY KEY (nombreprofesion);

ALTER TABLE nivelAcademico
ADD CONSTRAINT pk_nivelAcademico PRIMARY KEY (nombreNivel);

insert into profesiones values('médico');
insert into profesiones values('abogado');
insert into profesiones values('biólogo');
insert into profesiones values('cardiólogo');
insert into profesiones values('arquitecto');
insert into profesiones values('geólogo');
insert into profesiones values('gerente de ventas');
insert into profesiones values('dentista');
insert into profesiones values('actor');
insert into profesiones values('patólogo');

insert into profesiones values('contador');
insert into profesiones values('electricista');
insert into profesiones values('topógrafo');
insert into profesiones values('entrenador personal');
insert into profesiones values('químico');
insert into profesiones values('informático');
insert into profesiones values('escultor');
insert into profesiones values('fotógrafo');
insert into profesiones values('albañil');
insert into profesiones values('pintor');

insert into profesiones values('periodista');
insert into profesiones values('veterinario');
insert into profesiones values('astronauta');
insert into profesiones values('físico');
insert into profesiones values('profesor');
insert into profesiones values('gastrónomo');
insert into profesiones values('astrólogo');
insert into profesiones values('pastor');
insert into profesiones values('cantante');
insert into profesiones values('compositor');

insert into profesiones values('juez');
insert into profesiones values('fiscal');
insert into profesiones values('demonólogo');
insert into profesiones values('chef');
insert into profesiones values('publicista');
insert into profesiones values('ingeniero civil');
insert into profesiones values('policia');
insert into profesiones values('investigador privado');
insert into profesiones values('catador profesional');
insert into profesiones values('bombero');

insert into profesiones values('mecánico');
insert into profesiones values('guarda de seguridad');
insert into profesiones values('guardaespaldas');
insert into profesiones values('criminólogo');
insert into profesiones values('detective');
insert into profesiones values('chofer de autobus');
insert into profesiones values('piloto');
insert into profesiones values('pastelero');
insert into profesiones values('psicólogo');
insert into profesiones values('filólogo');

insert into nivelAcademico values('Bachiller');
insert into nivelAcademico values('Licenciado');
insert into nivelAcademico values('Master');
insert into nivelAcademico values('Doctor');


Create or Replace procedure LlenarProfesiones_NivelAcademico
is
  CURSOR c1 is
      SELECT Idcliente
      FROM ventas.clientesins;  
BEGIN
  
  for i in c1 loop 
                      
  update clientesins set profesion = (select nombreprofesion from (
                                      SELECT nombreprofesion
                                      FROM profesiones
                                      ORDER BY dbms_random.value)
                                      where rownum=1)
                      where idcliente= i.Idcliente;
                      
   update clientesins set nivel_aca = (select nombreNivel from (
                                      SELECT nombreNivel
                                      FROM nivelAcademico
                                      ORDER BY dbms_random.value)
                                      where rownum=1)
                      where idcliente= i.Idcliente;
  end loop; 
END;

execute LlenarProfesiones_NivelAcademico;

select * from nivelAcademico;
select * from profesiones;
select * from clientesins;