
-- inserts para clientes y facturas (polizas) y detfacturas (coberturas)
-- inserts para coberturas (seguros y tipos de seguro)

CREATE SEQUENCE clienteid
  MINVALUE 1
  MAXVALUE 999999999999999999999999999
  START WITH 1
  INCREMENT BY 1
  CACHE 20;

CREATE SEQUENCE facturaid
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
insert into coberturas values ('H','', 'RIESGOS ADICIONALES',100,'Descripcion');
insert into coberturas values ('I','', 'RCE EXTENDIDA POR LESION Y/O MUERTE DE PERSONAS Y/O DAÑOS A LA PROPIEDAD DE TERCERAS´PERSONAS',100,'Descripcion');
insert into coberturas values ('J','', 'PÉRDIDAS DE OBJETOS PERSONALES',100,'Descripcion');
insert into coberturas values ('K','', 'INDEMNIZACIÓN PARA TRANSPORTE ALTERNATIVO',100,'Descripcion');
insert into coberturas values ('L','', 'RCEE POR LESIÓN Y/O MUERTE DE PERSONAS Y/O DAÑOS A LA PROPIEDAD DE TERCERAS PERSONAS, POR EL USO DE UN  AUTO SUSTITUTO',100,'Descripcion');
insert into coberturas values ('M','', 'MULTIASISTENCIA EXTENDIDA',100,'Descripcion');
insert into coberturas values ('N','', 'MULTIASISTENCIA EXTENDIDA',100,'Descripcion');
insert into coberturas values ('P','', 'SERVICIOS MÉDICOS FAMILIARES PLUS Y MUERTE DE LOS OCUPANTES DEL  VEHÍCULO ASEGURADO',100,'Descripcion');
insert into coberturas values ('Y','', 'EXTRATERRITORIALIDAD',100,'Descripcion');
insert into coberturas values ('Z','', 'RIESGOS PARTICULARES',100,'Descripcion');


-- cursor insercion polizas  

-- POR HACER
-- podemos ayudarnos con este cursor que hizo el profe 

truncate table factura;

DECLARE
   CURSOR c1 is
      SELECT idcliente, idpersona FROM clientes where rownum < 2001;
   CURSOR c2 is
      select idproducto, descproducto, unidadmedida, preciounidad
      from (
            select idproducto, descproducto, unidadmedida, preciounidad
            from   coberturas
            order by dbms_random.value) r1
      where rownum = 1 or
            rownum = trunc(dbms_random.value(1,6));
   vcont          integer;
   vcont2         integer;
   vidcliente     varchar2(30);
   vidpersona     varchar2(30);
   vcantfacturas  integer;
   vidfactura     varchar2(30);
   vfecha         date;
   vcantcoberturas integer;
   vcontlinea     integer;
   vcontador      integer;
BEGIN
   dbms_output.put_line ('fecha inicio '||to_char(sysdate,'dd-mm-yyyy:hh:mi:ss'));
   VCONT := 0;
   vcantfacturas := 0;
   FOR i IN c1 LOOP
      vcont := vcont + 1;
      vidpersona := i.idpersona;
      vidcliente := i.idcliente;
      --DBMS_OUTPUT.put_line('idcliente es:'||vidcliente || ' ' || vidpersona);
      vcantfacturas := 0;
      vcont2        := 0;
      select trunc(dbms_random.value(1,10)) 
      into   vcantfacturas 
      from   dual;
      loop
          vcont2 := vcont2 + 1;
          select to_char(facturaid.nextval) into vidfactura from dual;
          select fecha
          into   vfecha
          from ( select fecha
                 from   parametros.fechas
                 where  fecha between to_date('01012010','ddmmyyyy') and to_date ('31122015','ddmmyyyy')
                 order by dbms_random.value)
          where rownum  = 1;
          insert into factura values (vidfactura, vidcliente, null, null,null, vfecha);
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




