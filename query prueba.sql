delete from paciente  where id_paciente=1;
delete from paciente where id_paciente=2;
delete from paciente  where id_paciente=3;
delete from paciente where id_paciente=4;


delete from usuario where id_usuario=1;

delete from tipo_usuario where id_tipo_usuario=1;
delete from tipo_usuario where id_tipo_usuario=2;
delete from tipo_usuario where id_tipo_usuario=3;

begin;
insert into usuario (username, password, idtipo_usuario) values ('basic','1234',3);
commit;

#quierys para lanueva forma de la base de datos
#validar usuario
SELECT pe.id_persona, pe.nombre, pe.apellido, pe.email, pe.tipo_documento, pe.numero_documento,
                pe.celular, pe.fecha_nacimiento, pe.ciudad_origen, pe.departamento_origen, pe.direccion,
                u.id_usuario, u.username, u.password, u.cargo, u.area, u.ultima_sesion, u.Persona_id_persona,
                u.Empresa_id_empresa, u.Tipo_usuario_id_tipo_usuario
                FROM Persona AS pe INNER JOIN Usuario AS u ON pe.id_persona=u.Persona_id_persona;


#Ingresar datos de tipos de usuario
INSERT INTO Tipo_usuario (nombre_tipo_usuario) VALUES ('Administrador');
INSERT INTO Tipo_usuario (nombre_tipo_usuario) VALUES ('Médico');
INSERT INTO Tipo_usuario (nombre_tipo_usuario) VALUES ('Recepción');
#Ingresar empresa
INSERT INTO Empresa (nombre_empresa,nit) VALUES('Gnawindua Ette Ennaka IPS',123456789);
#Ingresar datos de persona
INSERT INTO Persona (nombre, apellido) VALUES ('daniel','lozada');
#Ingresar datos de paciente
INSERT INTO Usuario (username, password,Persona_id_persona, Empresa_id_empresa,Tipo_usuario_id_tipo_usuario) VALUES ('admin','1234',last_insert_id(),1,1);

select * from paciente;

select * from usuario;

select * from tipo_usuario;

select * from persona;


ALTER TABLE paciente AUTO_INCREMENT = 1;

ALTER TABLE usuario AUTO_INCREMENT = 1;

ALTER TABLE tipo_usuario AUTO_INCREMENT = 1;

insert into usuario (username, password, idtipo_usuario) values ('user','1234',2);

insert into tipo_usuario (nombre_tipo_usuario) values ('superusuario');
insert into tipo_usuario (nombre_tipo_usuario) values ('estandar');
insert into tipo_usuario (nombre_tipo_usuario) values ('basico');


#Base de datos STOCKMS

select * from tipo_usuario;
select * from persona;
select * from usuario;

ALTER TABLE usuario AUTO_INCREMENT = 1;

delete from usuario where idusuario=2;

insert into persona (nombre, apellidos, cc) values ('daniel','lozada',1152686122);
insert into usuario (username, password, tipo_usuario_idtipo_usuario,persona_idpersona) values ('user','1234',1,1);

insert into tipo_usuario (nombre_tipo) values ('administrador');
insert into tipo_usuario (nombre_tipo) values ('empleado');