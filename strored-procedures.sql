###USUARIOS###
#Procedimiento que valida el Usuaro que inicia sesión en RUIPI
DELIMITER //


CREATE PROCEDURE userValidator(in_password VARCHAR(45), in_username VARCHAR(45))
BEGIN

SELECT pe.id_persona, pe.nombre, pe.apellido, pe.email, pe.tipo_documento, pe.numero_documento,
 pe.celular, pe.fecha_nacimiento, pe.ciudad_origen, pe.departamento_origen, pe.direccion,
 pe.fecha_registro, pe.activo, pe.ultima_actualizacion, u.id_usuario, u.username, u.password, u.cargo, u.area,
 u.id_persona, u.id_empresa, u.id_tipo_usuario FROM Persona AS pe INNER JOIN Usuario AS u 
 ON pe.id_persona=u.id_persona WHERE password = in_password AND username = in_username;

END
//
DELIMITER ;


#Procedimiento que inserta en las tablas Persona y Usuario los datos correspondientes a un nuevo Usuario
DELIMITER //

CREATE PROCEDURE insertUser(in_name VARCHAR(45), in_apellido VARCHAR(45), in_tipo_documento VARCHAR(45),
 in_numero_documento VARCHAR(45), in_fecha_naciemiento DATE, in_ciudad_origen VARCHAR(45), 
 in_departamento_origen VARCHAR(45), in_email TEXT(45), in_celular VARCHAR(15), in_direccion TEXT(150),
 in_fecha_registro VARCHAR (45), in_ultima_actualizacion VARCHAR(45), in_activo TINYINT,

 in_username VARCHAR(45), in_password VARCHAR (45), in_cargo VARCHAR(45), in_area VARCHAR(45),
 in_id_persona INT, in_id_empresa INT, in_id_tipo_usuario INT)

BEGIN

    DECLARE errno INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
    GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO;
    SELECT errno AS MYSQL_ERROR;
    ROLLBACK;
    END;

    START TRANSACTION;

		INSERT INTO Persona (nombre, apellido, tipo_documento, numero_documento, fecha_nacimiento, 
		 ciudad_origen, departamento_origen, email, celular, direccion, fecha_registro, 
		 ultima_actualizacion, activo ) VALUES (in_name, in_apellido, in_tipo_documento,
		 in_numero_documento, in_fecha_naciemiento, in_ciudad_origen, in_departamento_origen,
		 in_email, in_celular, in_direccion, in_fecha_registro, in_ultima_actualizacion, true);
 
		 INSERT INTO Usuario (username, password, cargo, area, id_persona, id_empresa, id_tipo_usuario) 
		  VALUES (in_username, in_password, in_cargo, in_area, last_insert_id(),1, in_id_tipo_usuario);

    COMMIT WORK;

END
//
DELIMITER ;


#Procedimiento que selecciona las coinsidencias de la busqueda de un Paciente por su nombre o parte de él
DELIMITER //

CREATE PROCEDURE selectUser(in_id_usuario INT)
BEGIN

SELECT pe.id_persona, pe.nombre, pe.apellido, pe.email, pe.tipo_documento, pe.numero_documento,
 pe.celular, pe.fecha_nacimiento, pe.ciudad_origen, pe.departamento_origen, pe.direccion,
 pe.fecha_registro, pe.ultima_actualizacion, u.id_usuario, u.username, u.password, u.cargo, u.area,
 u.id_empresa, u.id_tipo_usuario 
 FROM Persona AS pe INNER JOIN Usuario AS u ON pe.id_persona=u.id_persona 
 WHERE id_usuario=in_id_usuario;

END
//
DELIMITER ;


#Procedimiento que actualiza algún registro de un Usuario existente
DELIMITER //

CREATE PROCEDURE updateUser(in_name VARCHAR(45), in_apellido VARCHAR(45), in_tipo_documento VARCHAR(45),
 in_numero_documento VARCHAR(45), in_fecha_naciemiento DATE, in_ciudad_origen VARCHAR(45), 
 in_departamento_origen VARCHAR(45), in_email TEXT(45), in_celular VARCHAR(15), in_direccion TEXT(150),
 in_fecha_registro VARCHAR (150), in_ultima_actualizacion VARCHAR(45), 

 in_username VARCHAR(45),  in_password VARCHAR (45), in_cargo VARCHAR(45), in_area VARCHAR(45),
 in_id_tipo_usuario INT, in_id_usuario INT)
BEGIN

UPDATE persona AS pe, usuario AS u SET pe.nombre=in_name, pe.apellido=in_apellido, 
 pe.tipo_documento=in_tipo_documento, pe.numero_documento=in_numero_documento, 
 pe.fecha_nacimiento=in_fecha_naciemiento, pe.ciudad_origen=in_ciudad_origen,
 pe.departamento_origen=in_departamento_origen, pe.email=in_email, pe.celular=in_celular,
 pe.direccion=in_direccion, pe.fecha_registro=in_fecha_registro, pe.ultima_actualizacion=in_ultima_actualizacion,
 u.username=in_username, u.password=in_password, u.cargo=in_cargo, u.area=in_area, 
 u.id_tipo_usuario=in_id_tipo_usuario
 WHERE pe.id_persona = u.id_persona AND u.id_usuario=in_id_usuario;

END
//
DELIMITER ;


#Procedimiento que realiza una comprovación de que exista al menos un usuario Administrador en la base de datos
DELIMITER //

CREATE PROCEDURE adminUsers()
BEGIN

SELECT pe.activo, pe.id_persona, u.id_usuario, u.id_tipo_usuario FROM persona AS pe INNER JOIN usuario AS u 
ON pe.id_persona=u.id_persona WHERE pe.activo=1 AND u.id_tipo_usuario=1;

END
//
DELIMITER ;


#Procedimiento que realiza un soft delete de un Usuario
DELIMITER //

CREATE PROCEDURE deleteUser(in_id_usuario INT)
BEGIN

 UPDATE persona AS pe, usuario AS u SET  pe.activo=false WHERE pe.id_persona = u.id_persona
 AND u.id_usuario=in_id_usuario;

END
//
DELIMITER ;


#Consulta todos los datos de los Usuarios activos
DELIMITER //

CREATE PROCEDURE showAllUsers( )
BEGIN

SELECT pe.nombre, pe.apellido, pe.tipo_documento, pe.numero_documento, 
 pe.fecha_nacimiento, pe.ciudad_origen, pe.departamento_origen, pe.email, pe.celular,
 pe.direccion, pe.fecha_registro, pe.ultima_actualizacion, pe.activo, u.id_usuario, u.username, u.password, 
 u.cargo, u.area,  u.id_tipo_usuario FROM persona AS pe INNER JOIN usuario AS u ON pe.id_persona=u.id_persona
 WHERE pe.activo=1; 

END
//
DELIMITER ;


#Cuenta en número de usuarios registrados a partir de un username enviado como parámetro max=1 y min=0
DELIMITER //

CREATE PROCEDURE alreadyRegisteredUser(in_username VARCHAR(45))
BEGIN

SELECT  COUNT(id_usuario), pe.activo, pe.id_persona, u.id_usuario, u.username 
FROM persona AS pe INNER JOIN usuario AS u 
ON pe.id_persona=u.id_persona WHERE pe.activo=1 AND u.username=in_username;

END
//
DELIMITER ;

#consulta el password según el nombre de usuario pasado cmo parámetro
DELIMITER //

CREATE PROCEDURE getPasswordEncrypted(in_username VARCHAR(45))
BEGIN

SELECT  password 
FROM usuario 
WHERE username=in_username;

END
//
DELIMITER ;


#Cuenta cuántos usuarios tipo administrador existen en la base de datos actualmente
DELIMITER //

CREATE PROCEDURE counterUSerAdmin()
BEGIN

SELECT  id_tipo_usuario
FROM usuario 
WHERE id_tipo_usuario=1;

END
//
DELIMITER ;


#Verificar que la entidad Empresa contenga datos
DELIMITER //

CREATE PROCEDURE counterEnterpriseInfo()
BEGIN

SELECT  id_empresa
FROM Empresa 
WHERE id_empresa=1;

END
//
DELIMITER ;


#Procedimiento que inserta en las tablas Persona y Usuario los datos correspondientes a un primer Usuario Administrador
DELIMITER //

CREATE PROCEDURE insertFirstUser(in_name VARCHAR(45), in_apellido VARCHAR(45), in_tipo_documento VARCHAR(45),
 in_numero_documento VARCHAR(45), in_fecha_naciemiento DATE, in_email TEXT(45), 
 in_celular VARCHAR(15), in_fecha_registro VARCHAR (45), in_ultima_actualizacion VARCHAR(45), in_activo TINYINT,
 in_username VARCHAR(45), in_password VARCHAR (45),
 in_id_persona INT, in_id_empresa INT, in_id_tipo_usuario INT)

BEGIN

    DECLARE errno INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
    GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO;
    SELECT errno AS MYSQL_ERROR;
    ROLLBACK;
    END;

    START TRANSACTION;

		INSERT INTO Persona (nombre, apellido, tipo_documento, numero_documento, fecha_nacimiento, 
		email, celular, fecha_registro, ultima_actualizacion, activo ) VALUES (in_name, in_apellido, 
        in_tipo_documento, in_numero_documento, in_fecha_naciemiento, 
        in_email, in_celular, in_fecha_registro, in_ultima_actualizacion, in_activo);
 
		 INSERT INTO Usuario (username, password, id_persona, id_empresa, id_tipo_usuario) 
		  VALUES (in_username, in_password, last_insert_id(), in_id_empresa, in_id_tipo_usuario);

    COMMIT WORK;

END
//
DELIMITER ;



###PACIENTES###
#Procedimiento que encuentra un Paciente por su ID
DELIMITER //

CREATE PROCEDURE findPatient(in_id int)
BEGIN

SELECT pe.id_persona, pe.nombre, pe.apellido, pe.email, pe.tipo_documento, pe.numero_documento, 
 pe.celular, pe.fecha_nacimiento, pe.ciudad_origen, pe.departamento_origen, pe.direccion, pe.activo, 
 pa.id_paciente, pa.huella, pa.rh, pa.gestante, pa.sexo, pa.etnia, pa.comunidad, pa.municipio, 
 pe.fecha_registro, pe.ultima_actualizacion, pa.id_persona, pa.id_programaPyDT 
 FROM Persona AS pe INNER JOIN Paciente AS pa ON pe.id_persona=pa.id_persona
 INNER JOIN programa_PyDT AS pydt ON pa.id_programaPyDT=pydt.id_programaPyDT
 WHERE id_paciente=in_id;

END
//
DELIMITER ;

#Procedimiento que selecciona las coinsidencias de la busqueda de un Paciente por su nombre o parte de él
DELIMITER //

CREATE PROCEDURE selectPatient(in_name VARCHAR(45))
BEGIN

SELECT pe.id_persona, pe.nombre, pe.apellido,pe.email, pe.tipo_documento, pe.numero_documento, 
 pe.celular, pe.fecha_nacimiento,pe.ciudad_origen, pe.departamento_origen, pe.direccion, pe.activo,
 pa.id_paciente, pa.huella, pa.rh, pa.gestante, pa.sexo, pa.etnia, pa.comunidad, pa.municipio,
 pe.fecha_registro, pe.ultima_actualizacion, pa.id_persona, pa.id_programaPyDT 
 FROM Persona AS pe INNER JOIN Paciente AS pa ON pe.id_persona=pa.id_persona
 WHERE pe.nombre LIKE concat('%', in_name ,'%');

END
//
DELIMITER ;


#Procedimiento que inserta en las tablas Persona y Paciente los datos correspondientes a un nuevo Paceinte
DELIMITER //

CREATE PROCEDURE insertPatient(in_name VARCHAR(45), in_apellido VARCHAR(45), in_tipo_documento VARCHAR(45),
 in_numero_documento VARCHAR(45), in_fecha_naciemiento DATE, in_ciudad_origen VARCHAR(45), 
 in_departamento_origen VARCHAR(45), in_email TEXT(45), in_celular VARCHAR(15), in_direccion TEXT(150),
 in_fecha_registro VARCHAR (45), in_activo TINYINT, in_ultima_actualizacion VARCHAR(45),

 in_huella LONGBLOB, in_sexo VARCHAR(45), in_rh VARCHAR (45), in_gestante VARCHAR(45), in_etnia VARCHAR(45),
 in_comunidad VARCHAR(45), in_munipicio VARCHAR(45), in_programaPyDT INT, in_id_persona INT)

BEGIN

    DECLARE errno INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
    GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO;
    SELECT errno AS MYSQL_ERROR;
    ROLLBACK;
    END;

    START TRANSACTION;

		INSERT INTO Persona (nombre, apellido, tipo_documento, numero_documento, fecha_nacimiento, ciudad_origen,
		 departamento_origen, email, celular, direccion, fecha_registro, activo, ultima_actualizacion ) 
		 VALUES (in_name,in_apellido,in_tipo_documento,in_numero_documento,in_fecha_naciemiento,in_ciudad_origen,
		 in_departamento_origen,in_email,in_celular,in_direccion,in_fecha_registro,true,in_ultima_actualizacion);

		INSERT INTO Paciente (huella, sexo, rh, gestante, etnia, comunidad, municipio,
		 id_programaPyDT,  id_persona) VALUES (in_huella,in_sexo,in_rh,in_gestante,in_etnia,in_comunidad,
		 in_munipicio,in_programaPyDT,last_insert_id());

    COMMIT WORK;

END
//
DELIMITER ;


#Procedimiento que actualiza algún registro de un Paciente existente
DELIMITER //

CREATE PROCEDURE updatePatient(in_name VARCHAR(45), in_apellido VARCHAR(45), in_tipo_documento VARCHAR(45),
 in_numero_documento VARCHAR(45), in_fecha_naciemiento DATE, in_ciudad_origen VARCHAR(45), 
 in_departamento_origen VARCHAR(45), in_email TEXT(45), in_celular VARCHAR(15), in_direccion TEXT(150),
 in_ultima_actualizacion VARCHAR(45), 

 in_huella LONGBLOB,  in_rh VARCHAR (45), in_gestante VARCHAR(45), in_sexo VARCHAR(45), in_etnia VARCHAR(45),
 in_comunidad VARCHAR(45), in_munipicio VARCHAR(45), in_programaPyDT INT, in_id_persona INT)
BEGIN

UPDATE Persona AS pe, Paciente AS pa SET pe.nombre=in_name, pe.apellido=in_apellido, pe.tipo_documento=in_tipo_documento,
 pe.numero_documento=in_numero_documento, pe.fecha_nacimiento=in_fecha_naciemiento,
 pe.ciudad_origen=in_ciudad_origen, pe.departamento_origen=in_departamento_origen,
 pe.email=in_email, pe.celular=in_celular, pe.direccion=in_direccion, 
 pe.ultima_actualizacion=in_ultima_actualizacion, pa.huella=in_huella, pa.rh=in_rh, pa.gestante=in_gestante,
 pa.sexo=in_sexo, pa.etnia=in_etnia, pa.comunidad=in_comunidad, pa.municipio=in_munipicio,
 pa.id_programaPyDT=in_programaPyDT WHERE pe.id_persona = pa.id_persona 
 AND pa.id_paciente= in_id_persona;

END
//
DELIMITER ;


#Procedimiento que realiza un soft delete de un Paciente
DELIMITER //

CREATE PROCEDURE deletePatient(in_id_paciente INT)
BEGIN

UPDATE persona AS pe, paciente AS pa SET pe.activo=false WHERE pe.id_persona = pa.id_persona 
AND pa.id_paciente=in_id_paciente;

END
//
DELIMITER ;


##EMPRESA##
##Realiza una inserción de los datos de al empresa a la base de datos
DELIMITER //

CREATE PROCEDURE insertEnterpriseInfo(in_id_empresa INT, in_nit INT, nombre_empresa VARCHAR(45), 
 direccion TEXT(150),  in_ciudad VARCHAR(45), in_departamento VARCHAR(45), in_tel VARCHAR(45),
 in_email TEXT(45), in_web TEXT(100), in_fecha_registro VARCHAR(45))
 
BEGIN

INSERT INTO Empresa (id_empresa, nit, nombre_empresa, direccion_empresa, ciudad_empresa, departamento_empresa,
telefono_empresa, url, email_empresa, fecha_registro) VALUES (in_id_empresa, in_nit, nombre_empresa, direccion,
 in_ciudad, in_departamento, in_tel, in_email, in_web, in_fecha_registro);

END
//
DELIMITER ;