
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



