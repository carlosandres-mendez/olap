

--- Se conecta con el usuario parametros;

create table provincias (
idprovincia varchar2(10),
descripcion varchar2(100),
  CONSTRAINT pk_provincia PRIMARY KEY (idprovincia))
  tablespace parametros_tbs;


create table cantones (
idprovincia varchar2(10),
idcanton    varchar2(10),
descripcion varchar2(100),
  CONSTRAINT pk_cantones PRIMARY KEY (idprovincia, idcanton),
    CONSTRAINT fk_cantones_provincia
             foreign key (idprovincia)
             references provincias(idprovincia))
  tablespace parametros_tbs;


create table distritos (
idprovincia varchar2(10),
idcanton    varchar2(10),
iddistrito  varchar2(10),
descripcion varchar2(100),
  CONSTRAINT pk_distritos PRIMARY KEY (idprovincia, idcanton, iddistrito),
    CONSTRAINT fk_distritos_cantones
             foreign key (idprovincia, idcanton)
             references cantones(idprovincia, idcanton))
  tablespace parametros_tbs;




