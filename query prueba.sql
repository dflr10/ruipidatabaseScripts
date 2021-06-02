delete from paciente  where id_paciente=1;
delete from persona where id_persona=2;
delete from persona  where id_persona=4;
delete from paciente where id_paciente=4;

ALTER TABLE Paciente AUTO_INCREMENT = 1;

ALTER TABLE Persona AUTO_INCREMENT = 1;

ALTER TABLE Usuario AUTO_INCREMENT = 1;

ALTER TABLE Tipo_usuario AUTO_INCREMENT = 1;

delete from usuario where id_usuario=1;


#Querys para la nueva forma de la base de datos
#Buscar un paciente con pydt
SELECT pe.id_persona, pe.nombre, pe.apellido,pe.email, pe.tipo_documento, pe.numero_documento, pe.celular,
 pe.fecha_nacimiento,pe.ciudad_origen, pe.departamento_origen, pe.direccion,pa.id_paciente, pa.huella,
 pa.rh, pa.gestante, pa.sexo, pa.etnia, pa.comunidad, pa.municipio,pa.fecha_registro, pa.id_persona, pa.id_programaPyDT,
 pydt.id_programaPyDT, pydt.nombre_programaPyDT FROM Persona AS pe 
 INNER JOIN Paciente AS pa ON pe.id_persona=pa.id_persona
 INNER JOIN programa_PyDT AS pydt ON pa.id_programaPyDT=pydt.id_programaPyDT WHERE id_paciente=1;
 
#Buscar un pacientepor coninsidencia
SELECT pe.id_persona, pe.nombre, pe.apellido,pe.email, pe.tipo_documento, pe.numero_documento, pe.celular,
 pe.fecha_nacimiento,pe.ciudad_origen, pe.departamento_origen, pe.direccion,pa.id_paciente,
 pa.huella, pa.rh, pa.gestante, pa.sexo, pa.etnia, pa.comunidad, pa.municipio, pa.fecha_registro,
 pa.id_persona, pa.id_programaPyDT FROM Persona AS pe INNER JOIN Paciente AS pa ON pe.id_persona=pa.id_persona
WHERE pe.nombre LIKE 'f';

#Buscar todos los datos del paciente
SELECT pe.id_persona, pe.nombre, pe.apellido,pe.email, pe.tipo_documento, pe.numero_documento, pe.celular,
 pe.fecha_nacimiento,pe.ciudad_origen, pe.departamento_origen, pe.direccion,pa.id_paciente,
 pa.huella, pa.rh, pa.gestante, pa.sexo, pa.etnia, pa.comunidad, pa.municipio, pa.fecha_registro,
 pa.id_persona, pa.id_programaPyDT FROM Persona AS pe INNER JOIN Paciente AS pa ON pe.id_persona=pa.id_persona
WHERE pa.id_paciente=1;

#Insertar un nuevo paciente "REQUERE HUELLA"
BEGIN;
INSERT INTO Persona (nombre, apellido, email, tipo_documento, numero_documento,
 celular, fecha_nacimiento, ciudad_origen, departamento_origen, direccion) 
 VALUES ("","","","",123,
 01/01/2000,"","","",123,"");
 
INSERT INTO Paciente (huella, rh, gestante, sexo, etnia, comunidad, municipio, fecha_registro, id_persona)
 VALUES ("","","","","","","",01/01/2000,last_insert_id());
COMMIT; 

#Insertar un Usuario
BEGIN;
INSERT INTO Persona (nombre, apellido, email, tipo_documento, numero_documento,
 celular, fecha_nacimiento, ciudad_origen, departamento_origen, direccion) 
 VALUES ("","","","",123,
 01/01/2000,"","","",123,"");
 
INSERT INTO Usuario (username, password, cargo, area, ultima_sesion, id_persona, id_empresa, id_tipo_usuario)
 VALUES ("admin","1234","","",01/01/2000,last_insert_id(),1, 1);
COMMIT; 

#Validar usuario
SELECT pe.id_persona, pe.nombre, pe.apellido, pe.email, pe.tipo_documento, pe.numero_documento,
 pe.celular, pe.fecha_nacimiento, pe.ciudad_origen, pe.departamento_origen, pe.direccion,
 u.id_usuario, u.username, u.password, u.cargo, u.area, u.ultima_sesion, u.id_persona,
 u.id_empresa, u.id_tipo_usuario FROM Persona AS pe INNER JOIN Usuario AS u ON pe.id_persona=u.id_persona WHERE username='medico' AND password=1234;
 

#UPDATE un usuario
UPDATE persona, usuario SET persona.nombre='Daniel', persona.apellido='Lozada', persona.tipo_documento='C.C.',
	persona.numero_documento=1152686122, persona.fecha_nacimiento=05/18/1992, persona.ciudad_origen='Medellín',
	persona.departamento_origen='Antioquia', persona.email='dafelor.10@gmail.com', persona.celular='3107829850',
	persona.direccion='Carrera 70#80-129', persona.fecha_registro='09-09-2000 20:00', persona.activo= true,
    usuario.username='admin', usuario.password='4Yd0hdndOVo=', usuario.cargo='Gerente', usuario.area='Administración',
    persona.ultima_actualizacion='09-09-2000 20:00' 
    WHERE persona.id_persona = usuario.id_persona AND usuario.id_usuario= 1;
    
#UPDATE la fecha de registro
UPDATE persona, usuario SET persona.fecha_registro='09/09/2000 20:00', persona.ultima_actualizacion='09/09/2000 20:00'
	WHERE persona.id_persona = usuario.id_persona AND usuario.id_usuario= 1;
    
#Ingresar datos de tipos de usuario
INSERT INTO Tipo_usuario (nombre_tipo_usuario) VALUES ('Administrador');
INSERT INTO Tipo_usuario (nombre_tipo_usuario) VALUES ('Médico');
INSERT INTO Tipo_usuario (nombre_tipo_usuario) VALUES ('Recepción');

#Ingresar Programas Prevención y Detección Temprana de Enfermedades
INSERT INTO Programa_PyDT (nombre_programaPyDT) VALUES('Alteraciones de a Agudeza Visual');
INSERT INTO Programa_PyDT (nombre_programaPyDT) VALUES('Alteraciones del Crecimiento y Desarrollo (Menor a 10 Años)');
INSERT INTO Programa_PyDT (nombre_programaPyDT) VALUES('Alteraciones del Desarrollo del Joven (De 10 a 29 Años)');
INSERT INTO Programa_PyDT (nombre_programaPyDT) VALUES('Alteraciones Del Embarazo');
INSERT INTO Programa_PyDT (nombre_programaPyDT) VALUES('Alteraciones en el Adulto (Mayor a 45 Años)');
INSERT INTO Programa_PyDT (nombre_programaPyDT) VALUES('Cáncer de Seno');
INSERT INTO Programa_PyDT (nombre_programaPyDT) VALUES('Atención Específica en Salud Bucal');

#Select con doble inner join
SELECT pe.id_persona, pe.nombre, pe.apellido,
pe.email, pe.tipo_documento, pe.numero_documento, pe.celular, pe.fecha_nacimiento,
pe.ciudad_origen, pe.departamento_origen, pe.direccion,
pa.id_paciente, pa.huella, pa.rh, pa.gestante, pa.sexo, pa.etnia, pa.comunidad, pa.municipio,
pe.fecha_registro, pa.id_persona, pa.id_programaPyDT
FROM Persona AS pe INNER JOIN Paciente AS pa ON pe.id_persona=pa.id_persona
INNER JOIN programa_PyDT AS pydt ON pa.id_programaPyDT=pydt.id_programaPyDT
WHERE id_paciente=1;


#Usando el botón de eliminar a la inversa Paciente
UPDATE persona, paciente SET persona.activo=true 
WHERE persona.id_persona = paciente.id_persona AND paciente.id_paciente= 2;

#Usando el botón de eliminar a la inversa Usuario
UPDATE persona, usuario SET persona.activo=true 
WHERE persona.id_persona = usuario.id_persona AND usuario.id_usuario= 1;

#Datos de prueba!!!!!!!!!!!!
#Ingresar empresa prueba
INSERT INTO Empresa (nombre_empresa,nit) VALUES('Gnawindua Ette Ennaka IPS',123456789);

#Ingresar datos de persona prueba
INSERT INTO Persona (nombre, apellido) VALUES ('daniel','lozada');
INSERT INTO Persona (nombre, apellido) VALUES ('edgar','pava');
INSERT INTO Persona (nombre, apellido) VALUES ('erika','garcía');

#Ingresar datos de usuario deprueba
INSERT INTO Usuario (username, password,id_persona, id_empresa,id_tipo_usuario) VALUES ('admin','1234',last_insert_id(),1,1);
INSERT INTO Usuario (username, password,id_persona, id_empresa,id_tipo_usuario) VALUES ('medico','1234',last_insert_id(),1,2);
INSERT INTO Usuario (username, password,id_persona, id_empresa,id_tipo_usuario) VALUES ('recep','1234',last_insert_id(),1,3);




SELECT * FROM Tipo_usuario;
 
SELECT * FROM Persona;

SELECT * FROM Paciente;

SELECT * FROM Usuario;

SELECT * FROM Programa_PyDT;

SELECT * FROM Empresa;
