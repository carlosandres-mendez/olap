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


connect parametros/parametros 
grant select on fechas to ventas; 
grant select on personas to ventas; 
grant select , update , delete , insert , references on personasfisicas to rrhh;
grant select , update , delete , insert , references on personasfisicas to ventas;