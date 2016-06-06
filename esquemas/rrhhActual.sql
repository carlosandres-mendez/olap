select * from personasfisicas; 
select * from personasjuridicas; -- falta 

grant select, references on cantones to rrhh;
grant select, references on distritos to rrhh;
grant select, references on provincias to rrhh;

--ejecutar e4sto para que ventas pueda ver personas 
grant select, references on personas to ventas;
grant select, references on personasjuridicas to ventas;
grant select, references on vendedores to ventas;
grant select, references on personasfisicas to ventas;
grant select, references on empleados to ventas;
-- entregado 
select * from departamentos;
select * from DEPARTAMENTOS_SEDE;
select * from sedes;  -- hace falta rellenar datos

select * from empleados;  -- falta rellenar supervisor
select * from vendedores; -- tabla que tienen id empleado id vendedor
select * from personasjuridicas;  -- esta tabla tiene pura basura letras random 
select * from personasfisicas;
select * from personas; 
select * from telefonos;
select * from pagos; -- necesita insertar empleados 

-- no entregado
select * from dirpersonas;
select * from evaluacion_emp;

CREATE TABLE clima_org(
IdEvaluacion		int NOT NULL
IdEmpleado 			varchar(30) NOT NULL,
Comunicacion		int,
Liderazgo		    int,
Pertenencia			int,
Motivacion      int,
Semestre 			  varchar(30) NOT NULL),
Año 				    date;
	CONSTRAINT pk_IdEvaluacion_IdEmpleado PRIMARY KEY (IdEvaluacion, IdEmpleado),
	CONSTRAINT fk_IdEmpleado
		 foreign key (IdEmpleado)
		 references empleados(IdEmpleado)
    tablespace data_tbs;

select * from clima_org;

-- Procedimiento para llenar ClIMA ORGANIZACIONAL

-- Se supone que todos los empleados se mantienen trabajando actualmente en la empresa
-- y ya les realizaron una encuesta de clima organizacional en el I semestre de 2016.

CREATE SEQUENCE climaid
  MINVALUE 1
  MAXVALUE 999999999999999999999999999
  START WITH 1
  INCREMENT BY 1
  CACHE 20;

Create or Replace procedure LlenarClimaOrganizacional
is
Declare
      vIdEvaluacion   varchar2(30);
      vAñoIngreso     int;
      vAñoAux         int;
      vMesIngreso     int;
      vComunicacion   int;
      vLiderazgo      int;
      vPertenencia    int;
      vMotivacion     int;
      cursor c1 is
             SELECT IdEmpleado, FecIngreso
             FROM   empleados;
BEGIN
   FOR i in c1
   LOOP

      select to_char(i.FecIngreso,'yyyy') into vAñoIngreso from dual;
      select to_char(i.FecIngreso,'mm') into vMesIngreso from dual;

      vAñoAux := vAñoIngreso;

      WHILE vAñoAux < 2017 LOOP

        IF vAñoAux != vAñoIngreso OR vMesIngreso < 7 THEN
          select trunc(dbms_random.value(20,100)) into  vComunicacion from  dual;
          select trunc(dbms_random.value(30,100)) into  vLiderazgo    from  dual;
          select trunc(dbms_random.value(30,100)) into  vPertenencia  from  dual;
          select trunc(dbms_random.value( 0,100)) into  vMotivacion   from  dual;

          vIdEvaluacion := climaid.nextval;
          insert into evaluacion_emp (vIdEvaluacion, IdEmpleado, Comunicacion, Liderazgo, Pertenencia, Motivacion, Semestre, Año)
          values (vIdEvaluacion, i.IdEmpleado, vPuntualidad, vRendimiento, vPertenencia, vMotivacion, 'I', vAñoAux);

        END IF;

        IF vAñoAux != 2016 THEN
          select trunc(dbms_random.value(20,100)) into  vComunicacion from  dual;
          select trunc(dbms_random.value(30,100)) into  vLiderazgo    from  dual;
          select trunc(dbms_random.value(30,100)) into  vPertenencia  from  dual;
          select trunc(dbms_random.value( 0,100)) into  vMotivacion   from  dual;

          vIdEvaluacion := climaid.nextval;
          insert into evaluacion_emp (vIdEvaluacion, IdEmpleado, Comunicacion, Liderazgo, Pertenencia, Motivacion, Semestre, Año)
          values (vIdEvaluacion, i.IdEmpleado, vPuntualidad, vRendimiento, vPertenencia, vMotivacion, 'II', vAñoAux);
        END IF;  

        vAñoAux := vAñoAux + 1;

      END LOOP;

      EXIT WHEN c1%NOTFOUND; 
   END LOOP;
   commit;
END;

---
--- Procedimiento para llenar telefonos
---
Create or Replace procedure LlenarTelefonos
is
  CURSOR c1 is
      SELECT idpersona
      FROM personas;  
      
   vIdPersona varchar2(30);
   vTipoTelefono  varchar2(50);
   vTelefonoFijo varchar2(13);
   vTelefonoMovil varchar2(13);
   
BEGIN
   for i in c1 loop
      vIdPersona :=i.idpersona;
      
      select trunc(dbms_random.value(20000000,29999999))
      into vTelefonoFijo
      from dual;
      
      select trunc(dbms_random.value(60000000,99999999))
      into vTelefonoMovil
      from dual;
      
       insert into Telefonos values(vIdPersona, 'Fijo', vTelefonoFijo);
       insert into Telefonos values(vIdPersona, 'Movil', vTelefonoMovil);
   end loop;
END;

execute LlenarTelefonos;
select * from telefonos;

--- Carlos: pongo Año como INT y cambio Mes x Semestre
drop table "RRHH"."PAGOS";
  CREATE TABLE "RRHH"."PAGOS" 
   (  IdEmpleado VARCHAR2(30 BYTE) NOT NULL ENABLE, 
  Semestre VARCHAR2(30 BYTE) NOT NULL ENABLE, 
  Año INT, 
  Monto NUMBER(*,0), 
   CONSTRAINT "PK_PAGOS" PRIMARY KEY (IdEmpleado, Semestre, Año), 
   CONSTRAINT "FK_IDEMPLEADO_PAGOGOS" FOREIGN KEY (IdEmpleado)
    REFERENCES "RRHH"."EMPLEADOS" (IdEmpleado) ENABLE
   ) TABLESPACE "RRHH_TBS";
---
--- Procedimiento para llenar Pagos
---

-- Tienen que estar lleno el campo de salario de cada empleado en la tabla de empleado
-- Y esta bueno, solo que introduce los datos en un orden extraño
-- si lo quieren probar hagan la consulta de pagos con order by 
Create or Replace procedure LlenarPagos
is
  CURSOR c1 is
      SELECT idempleado, salario
      FROM empleados;  
    
   cursor c2 (pAño int) is
      
      SELECT idempleado,monto
      FROM pagos
      where año= pAño and semestre ='I'; 
      
   vIdEmpleado varchar2(30);
   vSalarioViejo  decimal(10,2);
   vSalarioNuevo  decimal(10,2);
   vAño int;
   
BEGIN
    vAño:=2010;
   for i in c1 loop
      vIdEmpleado :=i.idempleado;
      vSalarioViejo := i.salario;
      vSalarioNuevo:= vSalarioViejo+(vSalarioViejo*0.05);  
      
      insert into Pagos values(vIdEmpleado, 'I', vAño, vSalarioNuevo);
    end loop;
    loop
          for j in c2(vAño) loop
            vIdEmpleado :=j.idempleado;
            vSalarioViejo := j.monto;    
            vSalarioNuevo:= vSalarioViejo+(vSalarioViejo*0.05);
            
             insert into Pagos values(vIdEmpleado, 'II', vAño, vSalarioNuevo);
             vAño:=vAño+1;
             
            if vAño <2016 then
              vSalarioViejo:=vSalarioNuevo;
              vSalarioNuevo:= vSalarioViejo+(vSalarioViejo*0.05);
              insert into Pagos values(vIdEmpleado, 'I', vAño, vSalarioNuevo);
            end if;
            vAño:=vAño-1;
        end loop;
        vAño:=vAño+1;
      exit when vAño >2015;
  end loop;
    
END;

execute LlenarPagos;
  

-- CARLOS
--******* Script para mover dipersonas de parametros a rrhh *******

-- este grant en parametros
grant select , references on cantones to rrhh;
grant select , references on distritos to rrhh;
grant select , references on provincias to rrhh;

drop table RRHH.DIRPERSONAS;

CREATE TABLE "RRHH"."DIRPERSONAS" 
   (  "IDPERSONA" VARCHAR2(30 BYTE), 
  "IDTIPODIR" VARCHAR2(10 BYTE), 
  "IDPROVINCIA" VARCHAR2(10 BYTE), 
  "IDCANTON" VARCHAR2(10 BYTE), 
  "IDDISTRITO" VARCHAR2(10 BYTE), 
  "DETALLE" VARCHAR2(200 BYTE), 
   CONSTRAINT "PK_DIRPERSONAS" PRIMARY KEY ("IDPERSONA", "IDTIPODIR"), 
   CONSTRAINT "FK_DIRPERSONAS_CANTONES" FOREIGN KEY ("IDPROVINCIA", "IDCANTON")
    REFERENCES "PARAMETROS"."CANTONES" ("IDPROVINCIA", "IDCANTON") ENABLE, 
   CONSTRAINT "FK_DIRPERSONAS_DISTRITOS" FOREIGN KEY ("IDPROVINCIA", "IDCANTON", "IDDISTRITO")
    REFERENCES "PARAMETROS"."DISTRITOS" ("IDPROVINCIA", "IDCANTON", "IDDISTRITO") ENABLE, 
   CONSTRAINT "FK_DIRPERSONAS_PERSONAS" FOREIGN KEY ("IDPERSONA")
    REFERENCES "RRHH"."PERSONAS" ("IDPERSONA") ENABLE, 
   CONSTRAINT "FK_DIRPERSONAS_PROVINCIAS" FOREIGN KEY ("IDPROVINCIA")
    REFERENCES "PARAMETROS"."PROVINCIAS" ("IDPROVINCIA") ENABLE
   ) TABLESPACE "RRHH_TBS";

 
-- Insertar en rrhh.dirpersonas (con los datos de parametros.dirpersonas) 
DECLARE
   CURSOR c1 is
      SELECT idpersona FROM rrhh.personas;
   CURSOR c2 (pIdPersona varchar2) is
      select idpersona, idtipodir, idprovincia, idcanton, iddistrito, detalle
      from   parametros.dirpersonas
      where  idpersona = pIdPersona;
BEGIN
   for i in c1 loop
      for j in c2(i.idpersona) loop
          INSERT INTO rrhh.DIRPERSONAS (idpersona, idtipodir, idprovincia, idcanton, iddistrito, detalle) 
            VALUES(j.idpersona, j.idtipodir, j.idprovincia, j.idcanton, j.iddistrito, j.detalle);
          EXIT WHEN c2%NOTFOUND;
      end loop;
      EXIT WHEN c1%NOTFOUND;
   end loop;
END;


--********* Persona Juridica ********
drop table rrhh.personasjuridicas;

create table personasjuridicas(
IdPerJuridica   varchar2(30) NOT NULL,
CONSTRAINT pk_personasjuridicas PRIMARY KEY (IdPerJuridica),
CONSTRAINT fk_perjuridica_persona 
           foreign key(IdPerJuridica)
           references personas(IdPersona)
           ) tablespace rrhh_tbs;

CREATE SEQUENCE perjuridica
  MINVALUE 1
  MAXVALUE 999999999999999999999999999
  START WITH 1
  INCREMENT BY 1
  CACHE 20;

DECLARE
  ID varchar2(30);
BEGIN
FOR i in 1..50 -- por el momento vamos a tener 50 proveedores
  LOOP
    ID := perjuridica.nextval;
    INSERT INTO RRHH.PERSONAS (IDPERSONA, TIPOPERSONA) VALUES(ID,'J');
    INSERT INTO PERSONASJURIDICAS (IDPERJURIDICA) VALUES(ID);
  END LOOP;
END;

