
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

        IF vAñoAux != vAñoIngreso OR vMesIngreso < 7 THEN
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

-- Segun Wikipedia: Clima Organizacional
-- Es el ambiente generado por las emociones de los miembros de un grupo u organización, el cual está 
-- relacionado con la motivación de los empleados.
-- En el nivel individual se le conoce principalmente como clima psicológico.
-- El clima psicológico se refiere a las percepciones de los trabajadores del ambiente de trabajo,
-- captura las representaciones psicológicas significativas hechas por los trabajadores referentes 
-- a la estructura, procesos y eventos que suceden en la organización
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
    tablespace rrhh_tbs;
  
  
  
  --inserciones en personasFísicas
  
  --fechas aleatorias 
  CREATE TABLE fechas_aleatorias (fecha DATE);
  
  delete fechas_aleatorias

DECLARE
  sd    NUMBER;
  dias  NUMBER := 10000;  --max de dias que se suman/restan a sysdate
  dia   DATE;
BEGIN
  -- inicializacion del seed
  SELECT to_char(systimestamp,'FF') INTO sd FROM dual;
  dbms_random.initialize(sd);

  FOR i in 1..5000
  LOOP
    dia := TRUNC(sysdate) - dbms_random.value(-dias,dias);
    INSERT INTO fechas_aleatorias VALUES (dia);
  END LOOP;
END;

select * from fechas_aleatorias

SELECT fecha FROM
( SELECT fecha FROM fechas_aleatorias
ORDER BY dbms_random.value )
WHERE rownum = 1

--- para generar el estado civil

create table estadoCivil(
  letra varchar(1) primary key
)
insert into estadoCivil (letra) values('S');
insert into estadoCivil values('C');
insert into estadoCivil values('D');
insert into estadoCivil values('V');

select * from estadocivil

--end 
  
declare
  cursor personafisi is
  select cedula, nombre, apellido1, apellido2, 
       decode(sexo, '1','M','F') as sexo
  from   parametros.padron
  where rownum<=110000;
  
begin
  for perf in personafisi loop
    insert into personas values(perf.cedula,'F');
    
        insert into personasfisicas values(perf.cedula, perf.nombre, perf.apellido1, perf.apellido2, perf.sexo, 
    (SELECT fecha FROM
      ( SELECT fecha FROM fechas_aleatorias
      ORDER BY dbms_random.value )
      WHERE rownum = 1), 
      (SELECT letra FROM
      ( SELECT letra FROM estadoCivil
      ORDER BY dbms_random.value )
      WHERE rownum = 1)
      );
  end loop;
end;

select count(*) from personas;

select * from personasfisicas

delete personasfisicas;
delete personas;


-----insertamos en personajuridica

declare idpj varchar2(30);
BEGIN
for i in 1..50 loop
  SELECT 3||DBMS_RANDOM.string('x', 9) into idpj FROM dual;
  insert into personas values(idpj,'J');
  insert into personasjuridicas values(idpj, (SELECT DBMS_RANDOM.string('u', 9) FROM dual));
end loop; 
END;


select * from personasjuridicas

--- insertar en sedes
--secuencia para id autoincremental
CREATE SEQUENCE incrementar_id_sedes
  START WITH 1
  INCREMENT BY 1
  CACHE 100;
  
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Centro de Gestión de Reclamos de Automóviles');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Centro de Gestión de Seguros Personales');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Centro de Servicios Complementarios');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Centro de Servicios Técnicos Profesionales');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Punto de Venta Cañas');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Punto de Venta Escazú');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Punto de Venta Filadelfia');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Punto de Venta Golfito');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Punto de Venta Grecia');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Punto de Venta Jacó');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Punto de Venta Quepos');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Punto de Venta San Antonio de Belén');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Punto de Venta San Marcos de Tarrazú');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Punto de Venta San Sebastián');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Punto de Venta Santa Cruz');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Punto de Venta Sarchí');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Punto de Venta Siquirres');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Punto de Venta Tres Ríos (BCAC)');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede Alajuela');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede Cartago');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede Ciudad Neilly');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede Ciudad Quesada');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede Curridabat');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede Desamparados');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede Guadalupe');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede Guápiles');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede Heredia');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede La Merced');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede Liberia');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede Limón');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede Nicoya');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede Pavas');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede Pérez Zeledón');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede Puntarenas');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede San José');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede San Pedro');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede San Ramón');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede Tibás');
 insert into sedes (idsede,nombre) values(incrementar_id_sedes.nextval,'Sede Turrialba');

--insertamos prov, cont y dist
declare
cont int;
  cursor personafisi is
  SELECT idprovincia, idcanton, iddistrito 
  FROM parametros.distritos
  where rownum<=39;
  
begin
cont:=0;
  for perf in personafisi loop   
  cont := cont +1;
        update sedes set idprovincia = perf.idprovincia, idcanton=perf.idcanton,iddistrito=perf.iddistrito
        where idsede=cont;
  end loop;
end;





-----insertamos en departamentos
CREATE SEQUENCE incrementar_id_departamentos
  START WITH 1
  INCREMENT BY 1
  CACHE 100;

insert into departamentos (iddepartamento,nombre) values(incrementar_id_departamentos.nextval,'Dirección de Reaseguros');
insert into departamentos (iddepartamento,nombre) values(incrementar_id_departamentos.nextval,'Recursos Humanos');
insert into departamentos (iddepartamento,nombre) values(incrementar_id_departamentos.nextval,'Dirección de Riesgos o Daños');
insert into departamentos (iddepartamento,nombre) values(incrementar_id_departamentos.nextval,'Dirección de Seguros Solidarios');
insert into departamentos (iddepartamento,nombre) values(incrementar_id_departamentos.nextval,'Dirección de Seguros Personales');
insert into departamentos (iddepartamento,nombre) values(incrementar_id_departamentos.nextval,'Dirección técnica de indemnizaciones');
insert into departamentos (iddepartamento,nombre) values(incrementar_id_departamentos.nextval,'Dirección cliente corporativo');
insert into departamentos (iddepartamento,nombre) values(incrementar_id_departamentos.nextval,'Dirección de operaciones');


select * from departamentos

--delete departamentos_sede

---insertamos en departamentos_sede
begin
for i in 1..39 loop
  for j in 1..4 loop
    insert into departamentos_sede values(j,i);
  end loop;
end loop;
end;

select * from departamentos_sede
delete departamentos_sede

---insertamos en empleados
CREATE SEQUENCE incrementar_id_perfisicas
  START WITH 1
  INCREMENT BY 1
  CACHE 100;

declare
  cursor personafisi is
  SELECT idperfisica 
  FROM personasfisicas
  where id>100201 and id<=100300;
  
begin
  for emp in personafisi loop   
    insert into empleados (idempleado,idperfisica,salario,comision,fecingreso,iddepartamento,idsede) 
    values(incrementar_id_empleado.nextval, emp.idperfisica, 
    (cast((select dbms_random.value(600000,1600000) num from dual) as decimal(10,0))), 
    (cast((select dbms_random.value(3,10) num from dual) as decimal(4,0))),
    (SELECT fecha FROM( SELECT fecha FROM fechas_aleatorias ORDER BY dbms_random.value ) WHERE rownum = 1),
    (cast((select dbms_random.value(1,4) num from dual) as decimal(4,0))),
    (SELECT idsede FROM( SELECT idsede FROM departamentos_sede ORDER BY dbms_random.value ) WHERE rownum = 1));
  end loop;
end;

select * from empleados

---insertar administrador en sede

select * from sedes
begin
for i in 1..39 loop
    update sedes set administrador = (cast((select dbms_random.value(9,205) num from dual) as decimal(4,0)))where idsede = i;
end loop;
end;


---insertar gerente de departamento

select * from departamentos
begin
for i in 1..39 loop
    update departamentos set idgerente = (cast((select dbms_random.value(9,205) num from dual) as decimal(4,0)))where iddepartamento = i;
end loop;
end;

---insertamos en vendedor 
CREATE SEQUENCE incrementar_id_vendedor
  START WITH 1
  INCREMENT BY 1
  CACHE 100;


begin
for i in 9..139 loop
    insert into vendedores values(incrementar_id_vendedor.nextval,i);
end loop;
end;

select * from vendedores;

