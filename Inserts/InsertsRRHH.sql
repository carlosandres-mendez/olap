
-- En rrhh

-- Ya haber cargado personasfisicas y haberle dado grants a rrhh para select 

set SERVEROUTPUT ON;

CREATE SEQUENCE empleadoid
  MINVALUE 1
  MAXVALUE 999999999999999999999999999
  START WITH 1
  INCREMENT BY 1
  CACHE 20;

Declare
      vcant  int;
      vidempleado varchar2(30);
      cursor c1 is
             SELECT idperfisica
             FROM   parametros.personasfisicas
             where  rownum = 1;
BEGIN
   vcant := 0;
   FOR i in c1
   LOOP
      vidempleado := empleadoid.nextval;
      vcant := vcant + 1;
      insert into empleados (idempleado, idperfisica, fecingreso, categoria, iddepartamento)
      values (vidempleado, 
              i.idperfisica,
              null,
              null,
              null);
   END LOOP;
   commit;
   dbms_output.put_line('la cantidad de personas fisicas es ' || vcant);
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

select * from pagos
order by idempleado,año,semestre;


-- Procedimiento para llenar EvaluacionEmpleados

-- Se supone que todos los empleados se mantienen trabajando actualmente en la empresa
-- y ya les realizaron una evaluación en el I semestre de 2016.

CREATE SEQUENCE evaluacionid
  MINVALUE 1
  MAXVALUE 999999999999999999999999999
  START WITH 1
  INCREMENT BY 1
  CACHE 20;

Create or Replace procedure LlenarEvaluacionEmpleados
is
Declare
      vIdEvaluacion varchar2(30);
      vAñoIngreso int;
      vAñoAux int;
      vMesIngreso int;
      vPuntualidad     int;
      vRendimiento     int;
      vCalidad         int;
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

        IF vAñoAux = vAñoIngreso AND vMesIngreso < 7 THEN
          select trunc(dbms_random.value(60,100)) into  vPuntualidad from  dual;
          select trunc(dbms_random.value(30,100)) into  vRendimiento from  dual;
          select trunc(dbms_random.value(50,100)) into  vCalidad     from  dual;

          vIdEvaluacion := evaluacionid.nextval;
          insert into evaluacion_emp (vIdEvaluacion, IdEmpleado, Puntualidad, Rendimiento, Calidad, Semestre, Año)
          values (vIdEvaluacion, i.IdEmpleado, vPuntualidad, vRendimiento, vCalidad, 'I', vAñoAux);

        END IF;

        IF vAñoAux != 2016 THEN
          select trunc(dbms_random.value(60,100)) into  vPuntualidad from  dual;
          select trunc(dbms_random.value(30,100)) into  vRendimiento from  dual;
          select trunc(dbms_random.value(50,100)) into  vCalidad     from  dual;

          vIdEvaluacion := evaluacionid.nextval;
          insert into evaluacion_emp (vIdEvaluacion, IdEmpleado, Puntualidad, Rendimiento, Calidad, Semestre, Año)
          values (vIdEvaluacion, i.IdEmpleado, vPuntualidad, vRendimiento, vCalidad, 'II', vAñoAux);
        END IF;  

        vAñoAux := vAñoAux + 1;

      END LOOP;

      EXIT WHEN c1%NOTFOUND; 
   END LOOP;
   commit;
END;



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

        IF vAñoAux = vAñoIngreso AND vMesIngreso < 7 THEN
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