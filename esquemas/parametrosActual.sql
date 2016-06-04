grant select on empleados to ventas; 
grant select , update , delete , insert , references on personasfisicas to rrhh;
grant select , update , delete , insert , references on personasfisicas to ventas;


-- datos ya dados 
select * from cantones;
select * from provincias;
select * from distritos;
select * from fechas;
select * from personas;
select * from personasfisicas;
drop table personasfisicas;


connect parametros/parametros 
grant select on fechas to ventas; 
grant select on personas to ventas; 
grant select , update , delete , insert , references on personasfisicas to rrhh;
grant select , update , delete , insert , references on personasfisicas to ventas;

select * from tiempo;
commit;

CREATE TABLE Tiempo (
       TiempoID         int NOT NULL,
       Fecha            date NOT NULL,
       Año              int NOT NULL,
       MesID            int NOT NULL,
       Mes              varchar2(10) NOT NULL,
       Cuarto           int NOT NULL,
       Semana           int NOT NULL,
       NumDiaSemana     int NOT NULL,
       DiaSemana        varchar2(15) NOT NULL
);
ALTER TABLE Tiempo
       ADD PRIMARY KEY (TiempoID);
      
declare
FechaFin date;
Fecha date;
begin
  Fecha    := to_date('2011-01-01','yyyy-MM-dd');
  FechaFin := to_date('2016-12-31','yyyy-MM-dd');
  
  WHILE Fecha < FechaFin 
  LOOP      DBMS_OUTPUT.PUT_LINE('Mes: ' || TO_CHAR(Fecha,'YYYYMMDD') ); 
  INSERT INTO Tiempo      SELECT      TO_CHAR(Fecha,'YYYYMMDD') AS TIEMPO_ID,
                          Fecha,
                          TO_CHAR(Fecha,'YYYY') AS YEAR,
                          TO_CHAR(Fecha,'YYYYMM') AS MES_ID,
                          TO_CHAR(Fecha,'MON-YY') AS MES,
                          TO_CHAR(Fecha,'YYYYQ') AS TRIMESTRE,
                          TO_CHAR(Fecha, 'YYYYIW') AS SEMANA,
                          TO_CHAR(Fecha,'D'),
                          TO_CHAR(Fecha,'DY') AS DIA_SEMANA
                          FROM DUAL;      
                          SELECT Fecha+1 into Fecha from dual; 
  end loop; 
end;  

