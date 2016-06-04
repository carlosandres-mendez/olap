
grant select, update, delete, insert, references on cantones to rrhh;
grant select, update, delete, insert, references on distritos to rrhh;
grant select, update, delete, insert, references on provincias to rrhh;

--ejecutar e4sto para que ventas pueda ver personas 
grant select, update, delete, insert, references on personas to ventas;
grant select, update, delete, insert, references on personasjuridicas to ventas;
grant select, update, delete, insert, references on vendedores to ventas;
grant select, update, delete, insert, references on personasfisicas to ventas;
grant select, update, delete, insert, references on empleados to ventas;
-- entregado 
select * from departamentos;
select * from DEPARTAMENTOS_SEDE;
select * from sedes;  -- hace falta rellenar datos

select * from empleados;  -- falta rellenar supervisor
select * from vendedores; -- tabla que tienen id empleado id vendedor
select * from personasjuridicas;  -- esta tabla tiene pura basura letras random 
select * from personasfisicas;
select * from personas; 

-- no entregado
select * from dirpersonas;
select * from evaluacion_emp;
select * from telefonos;
select * from pagos;


-- falta crera tabla clima organizacional 

-- Segun Wikipedia: Clima Organizacional
-- Es el ambiente generado por las emociones de los miembros de un grupo u organizaci�n, el cual est� 
-- relacionado con la motivaci�n de los empleados.
-- En el nivel individual se le conoce principalmente como clima psicol�gico.
-- El clima psicol�gico se refiere a las percepciones de los trabajadores del ambiente de trabajo,
-- captura las representaciones psicol�gicas significativas hechas por los trabajadores referentes 
-- a la estructura, procesos y eventos que suceden en la organizaci�n
CREATE TABLE clima_org(
IdEvaluacion		int NOT NULL
IdEmpleado 			varchar(30) NOT NULL,
Comunicacion		int,
Liderazgo		    int,
Pertenencia			int,
Motivacion      int,
Semestre 			  varchar(30) NOT NULL),
A�o 				    date;
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
      vA�oIngreso     int;
      vA�oAux         int;
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

      select to_char(i.FecIngreso,'yyyy') into vA�oIngreso from dual;
      select to_char(i.FecIngreso,'mm') into vMesIngreso from dual;

      vA�oAux := vA�oIngreso;

      WHILE vA�oAux < 2017 LOOP

        IF vA�oAux != vA�oIngreso OR vMesIngreso < 7 THEN
          select trunc(dbms_random.value(20,100)) into  vComunicacion from  dual;
          select trunc(dbms_random.value(30,100)) into  vLiderazgo    from  dual;
          select trunc(dbms_random.value(30,100)) into  vPertenencia  from  dual;
          select trunc(dbms_random.value( 0,100)) into  vMotivacion   from  dual;

          vIdEvaluacion := climaid.nextval;
          insert into evaluacion_emp (vIdEvaluacion, IdEmpleado, Comunicacion, Liderazgo, Pertenencia, Motivacion, Semestre, A�o)
          values (vIdEvaluacion, i.IdEmpleado, vPuntualidad, vRendimiento, vPertenencia, vMotivacion, 'I', vA�oAux);

        END IF;

        IF vA�oAux != 2016 THEN
          select trunc(dbms_random.value(20,100)) into  vComunicacion from  dual;
          select trunc(dbms_random.value(30,100)) into  vLiderazgo    from  dual;
          select trunc(dbms_random.value(30,100)) into  vPertenencia  from  dual;
          select trunc(dbms_random.value( 0,100)) into  vMotivacion   from  dual;

          vIdEvaluacion := climaid.nextval;
          insert into evaluacion_emp (vIdEvaluacion, IdEmpleado, Comunicacion, Liderazgo, Pertenencia, Motivacion, Semestre, A�o)
          values (vIdEvaluacion, i.IdEmpleado, vPuntualidad, vRendimiento, vPertenencia, vMotivacion, 'II', vA�oAux);
        END IF;  

        vA�oAux := vA�oAux + 1;

      END LOOP;

      EXIT WHEN c1%NOTFOUND; 
   END LOOP;
   commit;
END;


  