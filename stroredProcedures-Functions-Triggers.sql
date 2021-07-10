#############################################################################
#									USUARIOS								#
#############################################################################
#Procedimiento que permite validar el Usuaro que inicia sesión en RUIPI
DELIMITER //


CREATE PROCEDURE userValidator(in_password VARCHAR(45), in_username VARCHAR(45))
BEGIN

SELECT pe.id_persona, pe.nombre, pe.apellido, pe.email, pe.tipo_documento, pe.numero_documento,
 pe.celular, pe.fecha_nacimiento, pe.id_departamento, pe.id_municipio,  pe.direccion,
 pe.fecha_registro, pe.activo, pe.ultima_actualizacion, u.id_usuario, u.username, u.password, u.cargo, u.area,
 u.id_persona, u.id_empresa, u.id_tipo_usuario FROM Persona AS pe INNER JOIN Usuario AS u 
 ON pe.id_persona=u.id_persona WHERE password = in_password AND username = in_username;

END
//
DELIMITER ;


#Procedimiento que permite insertar en las tablas Persona y Usuario los datos correspondientes a un nuevo Usuario
DELIMITER //

CREATE PROCEDURE insertUser(in_name VARCHAR(45), in_apellido VARCHAR(45), in_tipo_documento VARCHAR(45),
 in_numero_documento VARCHAR(45), in_fecha_naciemiento DATE, in_id_departamento INT, in_id_municipio INT, 
 in_email TEXT(45), in_celular VARCHAR(15), in_direccion TEXT(150),
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
		 id_departamento, id_municipio,  email, celular, direccion, fecha_registro, 
		 ultima_actualizacion, activo ) VALUES (in_name, in_apellido, in_tipo_documento,
		 in_numero_documento, in_fecha_naciemiento, in_id_departamento, in_id_municipio,
		 in_email, in_celular, in_direccion, in_fecha_registro, in_ultima_actualizacion, true);
 
		 INSERT INTO Usuario (username, password, cargo, area, id_persona, id_empresa, id_tipo_usuario) 
		  VALUES (in_username, in_password, in_cargo, in_area, last_insert_id(),1, in_id_tipo_usuario);

    COMMIT WORK;

END
//
DELIMITER ;


#Procedimiento que permite seleccionar los datos de un Usuario
DELIMITER //

CREATE PROCEDURE selectUser(in_id_usuario INT)
BEGIN

SELECT pe.id_persona, pe.nombre, pe.apellido, pe.email, pe.tipo_documento, pe.numero_documento,
 pe.celular, pe.fecha_nacimiento, pe.id_departamento, pe.id_municipio, pe.direccion,
 pe.fecha_registro, pe.ultima_actualizacion, u.id_usuario, u.username, u.password, u.cargo, u.area,
 u.id_empresa, u.id_tipo_usuario 
 FROM Persona AS pe INNER JOIN Usuario AS u ON pe.id_persona=u.id_persona 
 WHERE id_usuario=in_id_usuario;

END
//
DELIMITER ;


#Procedimiento que permite actualizar algún registro de un Usuario existente
DELIMITER //

CREATE PROCEDURE updateUser(in_name VARCHAR(45), in_apellido VARCHAR(45), in_tipo_documento VARCHAR(45),
 in_numero_documento VARCHAR(45), in_fecha_naciemiento DATE, in_id_departamento INT, in_id_municipio INT, 
 in_email TEXT(45), in_celular VARCHAR(15), in_direccion TEXT(150),
 in_fecha_registro VARCHAR (150), in_ultima_actualizacion VARCHAR(45), 

 in_username VARCHAR(45),  in_password VARCHAR (45), in_cargo VARCHAR(45), in_area VARCHAR(45),
 in_id_tipo_usuario INT, in_id_usuario INT)
BEGIN

UPDATE persona AS pe, usuario AS u SET pe.nombre=in_name, pe.apellido=in_apellido, 
 pe.tipo_documento=in_tipo_documento, pe.numero_documento=in_numero_documento, 
 pe.fecha_nacimiento=in_fecha_naciemiento, pe.id_departamento=in_id_departamento,
 pe.id_municipio=in_id_municipio, pe.email=in_email, pe.celular=in_celular,
 pe.direccion=in_direccion, pe.fecha_registro=in_fecha_registro, pe.ultima_actualizacion=in_ultima_actualizacion,
 u.username=in_username, u.password=in_password, u.cargo=in_cargo, u.area=in_area, 
 u.id_tipo_usuario=in_id_tipo_usuario
 WHERE pe.id_persona = u.id_persona AND u.id_usuario=in_id_usuario;

END
//
DELIMITER ;


#Procedimiento que permite realizar una comprobación de que exista al menos un Usuario Administrador en la base de datos
DELIMITER //

CREATE PROCEDURE adminUsers()
BEGIN

SELECT pe.activo, pe.id_persona, u.id_usuario, u.id_tipo_usuario FROM persona AS pe INNER JOIN usuario AS u 
ON pe.id_persona=u.id_persona WHERE pe.activo=1 AND u.id_tipo_usuario=1;

END
//
DELIMITER ;


#Procedimiento que permite realiza un soft-delete de un Usuario alterando su atributo activo de true a false o 1 a 0
DELIMITER //

CREATE PROCEDURE deleteUser(in_id_usuario INT)
BEGIN

 UPDATE persona AS pe, usuario AS u SET  pe.activo=false WHERE pe.id_persona = u.id_persona
 AND u.id_usuario=in_id_usuario;

END
//
DELIMITER ;


#Procedimiento que permite seleccionar todos los datos de los Usuarios activos
DELIMITER //

CREATE PROCEDURE showAllUsers( )
BEGIN

SELECT pe.nombre, pe.apellido, pe.tipo_documento, pe.numero_documento, 
 pe.fecha_nacimiento,pe.id_departamento, pe.id_municipio, pe.email, pe.celular,
 pe.direccion, pe.fecha_registro, pe.ultima_actualizacion, pe.activo, u.id_usuario, u.username, u.password, 
 u.cargo, u.area,  u.id_tipo_usuario FROM persona AS pe INNER JOIN usuario AS u ON pe.id_persona=u.id_persona
 WHERE pe.activo=1; 

END
//
DELIMITER ;


#Procedimiento que permite contar el número de Usuarios registrados a partir de un username enviado como parámetro con el fin 
#de evitar que hayan dos registrados con el mismo username o que un Usuario quiera registrarse con un username de un Usuario inactivo
DELIMITER //

CREATE PROCEDURE alreadyRegisteredUser(in_username VARCHAR(45))
BEGIN

SELECT  COUNT(id_usuario), pe.activo, pe.id_persona, u.id_usuario, u.username 
FROM persona AS pe INNER JOIN usuario AS u 
ON pe.id_persona=u.id_persona WHERE pe.activo=1 AND u.username=in_username;

END
//
DELIMITER ;


#Procedimiento que permite consultar el password encriptado según el nombre de usuario pasado como parámetro
DELIMITER //

CREATE PROCEDURE getPasswordEncrypted(in_username VARCHAR(45))
BEGIN

SELECT  password 
FROM usuario 
WHERE username=in_username;

END
//
DELIMITER ;


#Procedimiento que permite insertar en las tablas Persona y Usuario los datos correspondientes a un primer Usuario Administrador
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
		email, celular, fecha_registro, ultima_actualizacion, activo, direccion) 
        VALUES (in_name, in_apellido, in_tipo_documento, in_numero_documento, in_fecha_naciemiento, 
        in_email, in_celular, in_fecha_registro, in_ultima_actualizacion, in_activo, "");
 
		 INSERT INTO Usuario (username, password, id_persona, id_empresa, id_tipo_usuario, cargo, area) 
		  VALUES (in_username, in_password, last_insert_id(), in_id_empresa, in_id_tipo_usuario, "", "");

    COMMIT WORK;

END
//
DELIMITER ;


#Procedimiento que permite actualizar la contraseña del usuario cuyo username e email
#corresponden a los pasados como parámetro
DELIMITER //

CREATE PROCEDURE resetPassword(in_username VARCHAR(45), in_email VARCHAR(45), in_password VARCHAR(45))
BEGIN

UPDATE usuario AS u, persona AS pe SET u.password=in_password 
WHERE pe.id_persona=u.id_persona AND u.username=in_username AND pe.email=in_email AND pe.activo=1;

END
//
DELIMITER ;


#Procedimiento que permite verificar que el username e email
#pasados como parámetro pertenezcan a un usuario registrado en la base de datos
DELIMITER //

CREATE PROCEDURE beforeResetPassword(in_username VARCHAR(45), in_email VARCHAR(45))
BEGIN

SELECT u.username, pe.email FROM usuario AS u INNER JOIN persona AS pe 
ON  pe.id_persona=u.id_persona WHERE u.username=in_username AND pe.email=in_email AND pe.activo=1;

END
//
DELIMITER ;



#############################################################################
#									PACIENTES								#
#############################################################################
#Procedimiento que permite seleccionar un Paciente a partir de un ID pasado como parámetro
DELIMITER //

CREATE PROCEDURE findPatient(in_id int)
BEGIN

SELECT pe.id_persona, pe.nombre, pe.apellido, pe.email, pe.tipo_documento, pe.numero_documento, 
 pe.celular, pe.fecha_nacimiento, pe.id_departamento, pe.id_municipio, pe.direccion, pe.activo, 
 pa.id_paciente, pa.huella, pa.rh, pa.gestante, pa.sexo, pa.etnia, pa.comunidad, 
 pe.fecha_registro, pe.ultima_actualizacion, pa.id_persona, pa.id_programaPyDT 
 FROM Persona AS pe INNER JOIN Paciente AS pa ON pe.id_persona=pa.id_persona
 INNER JOIN programa_PyDT AS pydt ON pa.id_programaPyDT=pydt.id_programaPyDT
 WHERE id_paciente=in_id;

END
//
DELIMITER ;

#Procedimiento que permite seleccionar las coincidencias de la busqueda de un Paciente por su nombre o parte de él
DELIMITER //

CREATE PROCEDURE selectPatient(in_name VARCHAR(45))
BEGIN

SELECT pe.id_persona, pe.nombre, pe.apellido,pe.email, pe.tipo_documento, pe.numero_documento, 
 pe.celular, pe.fecha_nacimiento, pe.id_departamento, pe.id_municipio, pe.direccion, pe.activo,
 pa.id_paciente, pa.huella, pa.rh, pa.gestante, pa.sexo, pa.etnia, pa.comunidad,
 pe.fecha_registro, pe.ultima_actualizacion, pa.id_persona, pa.id_programaPyDT 
 FROM Persona AS pe INNER JOIN Paciente AS pa ON pe.id_persona=pa.id_persona
 WHERE pe.nombre LIKE concat('%', in_name ,'%');

END
//
DELIMITER ;


#Procedimiento que permite insertar en las tablas Persona, Paciente e Historia Clínica 
#los datos correspondientes a un nuevo Paciente
DELIMITER //

CREATE PROCEDURE insertPatient(in_name VARCHAR(45), in_apellido VARCHAR(45), in_tipo_documento VARCHAR(45),
 in_numero_documento VARCHAR(45), in_fecha_naciemiento DATE, in_id_departamento INT, in_id_municipio INT, 
 in_email TEXT(45), in_celular VARCHAR(15), in_direccion TEXT(150),
 in_fecha_registro VARCHAR (45), in_activo TINYINT, in_ultima_actualizacion VARCHAR(45),

 in_huella LONGBLOB, in_sexo VARCHAR(45), in_rh VARCHAR (45), in_gestante VARCHAR(45), in_etnia VARCHAR(45),
 in_comunidad VARCHAR(45), in_programaPyDT INT, in_id_persona INT)

BEGIN

    DECLARE errno INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
    GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO;
    SELECT errno AS MYSQL_ERROR;
    ROLLBACK;
    END;

    START TRANSACTION;

		INSERT INTO Persona (nombre, apellido, tipo_documento, numero_documento, fecha_nacimiento, id_departamento,
         id_municipio, email, celular, direccion, fecha_registro, activo, ultima_actualizacion ) 
		 VALUES (in_name, in_apellido, in_tipo_documento, in_numero_documento, in_fecha_naciemiento,
          in_id_departamento, in_id_municipio, in_email, in_celular, in_direccion,
         in_fecha_registro, true, in_ultima_actualizacion);

		INSERT INTO Paciente (huella, sexo, rh, gestante, etnia, comunidad,
		 id_programaPyDT,  id_persona) VALUES (in_huella,in_sexo,in_rh,in_gestante,in_etnia,in_comunidad,
		 in_programaPyDT,last_insert_id());
         
		INSERT INTO HistoriaC (motivo_consulta, fecha_consulta, eps, alergias_medicamentos,
        habitos, enfermedad_actual, antecedentes_EP, antecedentes_EF, medicamentos_formulados,
        info_parto, diagnostico, id_paciente) VALUES("","","","","","","","","","","",last_insert_id());

    COMMIT WORK;

END
//
DELIMITER ;


#Procedimiento que permite actualizar algún registro de un Paciente existente
DELIMITER //

CREATE PROCEDURE updatePatient(in_name VARCHAR(45), in_apellido VARCHAR(45), in_tipo_documento VARCHAR(45),
 in_numero_documento VARCHAR(45), in_fecha_naciemiento DATE, in_id_departamento INT, in_id_municipio INT, 
 in_email TEXT(45), in_celular VARCHAR(15), in_direccion TEXT(150),
 in_ultima_actualizacion VARCHAR(45), 

 in_huella LONGBLOB,  in_rh VARCHAR (45), in_gestante VARCHAR(45), in_sexo VARCHAR(45), in_etnia VARCHAR(45),
 in_comunidad VARCHAR(45), in_programaPyDT INT, in_id_persona INT)
BEGIN

UPDATE Persona AS pe, Paciente AS pa SET pe.nombre=in_name, pe.apellido=in_apellido, 
pe.tipo_documento=in_tipo_documento, pe.numero_documento=in_numero_documento, 
pe.fecha_nacimiento=in_fecha_naciemiento, pe.id_departamento=in_id_departamento, pe.id_municipio=in_id_municipio, 
pe.email=in_email, pe.celular=in_celular, pe.direccion=in_direccion, 
pe.ultima_actualizacion=in_ultima_actualizacion, pa.huella=in_huella, pa.rh=in_rh, pa.gestante=in_gestante,
pa.sexo=in_sexo, pa.etnia=in_etnia, pa.comunidad=in_comunidad,
pa.id_programaPyDT=in_programaPyDT WHERE pe.id_persona = pa.id_persona 
AND pa.id_paciente= in_id_persona;

END
//
DELIMITER ;


#Procedimiento que permite seleccionar los datos de un paciente a partir de su huella
DELIMITER //

CREATE PROCEDURE identifyPatient()
BEGIN

SELECT pe.id_persona, pe.nombre, pe.apellido,
pe.email, pe.tipo_documento, pe.numero_documento, pe.celular, pe.fecha_nacimiento,
pe.id_departamento, pe.id_municipio, pe.direccion, pe.activo, pe.ultima_actualizacion,
 pa.id_paciente, pa.huella, pa.rh, pa.gestante, pa.sexo, pa.etnia, pa.comunidad,
 pe.fecha_registro, pa.id_persona, pa.id_programaPyDT
 FROM Persona AS pe INNER JOIN Paciente AS pa ON pe.id_persona=pa.id_persona;

END
//
DELIMITER ;



#Procedimiento que permite realizar un soft-delete de un Paciente  alterando su atributo activo de true a false o 1 a 0
DELIMITER //

CREATE PROCEDURE deletePatient(in_id_paciente INT)
BEGIN

UPDATE persona AS pe, paciente AS pa SET pe.activo=false WHERE pe.id_persona = pa.id_persona 
AND pa.id_paciente=in_id_paciente;

END
//
DELIMITER ;


#################################################################################
#								HISTORIA CLÍNICA								#
#################################################################################
#Selecciona los datos de la historia clínica del paciente, si no tiene datos de historia clínica
#selecciona el id del paciente para que se pueda registrar una.alter
DELIMITER //

CREATE PROCEDURE selectPatientCH(in_id_paciente INT)
BEGIN

SELECT pe.id_persona, pe.nombre, pe.apellido, pe.tipo_documento, pe.numero_documento,
 hc.id_historiaC, hc.motivo_consulta, hc.fecha_consulta, hc.eps,
 hc.alergias_medicamentos, hc.habitos, hc.enfermedad_actual, hc.antecedentes_EP,
 hc.antecedentes_EF, hc.medicamentos_formulados, hc.info_parto, hc.diagnostico, hc.id_paciente
 FROM Persona AS pe INNER JOIN Paciente AS pa INNER JOIN HistoriaC AS hc 
 ON pe.id_persona=pa.id_persona  AND pa.id_paciente=hc.id_paciente
 WHERE hc.id_paciente=in_id_paciente AND pe.activo=1;

END
//
DELIMITER ;


#Permite actualizar la historia clínica de un paciente
DELIMITER //

CREATE PROCEDURE updateCH (in_motivo_consulta MEDIUMTEXT, in_fecha_consulta VARCHAR(45),
in_eps VARCHAR(45), in_alergias_medicamentos VARCHAR (250), in_habitos VARCHAR (250), 
in_enfermedad_actual VARCHAR(250), in_antecedentes_EP VARCHAR(250), in_antecedentes_EF VARCHAR(250), 
in_medicamentos_formulados LONGTEXT, in_info_parto LONGTEXT, in_diagnostico LONGTEXT, in_id_paciente INT)
BEGIN

UPDATE HistoriaC SET motivo_consulta=in_motivo_consulta, fecha_consulta=in_fecha_consulta, 
 eps=in_eps, alergias_medicamentos=in_alergias_medicamentos, habitos=in_habitos, 
 enfermedad_actual=in_enfermedad_actual, antecedentes_EP=in_antecedentes_EP,
 antecedentes_EF=in_antecedentes_EF, medicamentos_formulados=in_medicamentos_formulados, 
 info_parto=in_info_parto, diagnostico=in_diagnostico WHERE id_paciente=in_id_paciente;

END
//
DELIMITER ;

#############################################################################
#									EMPRESA									#
#############################################################################
#Permite realizar la inserción de los datos de la Empresa en la base de datos
DELIMITER //

CREATE PROCEDURE insertEnterpriseInfo(in_id_empresa INT, in_nit INT, in_nombre_empresa VARCHAR(45), 
 in_direccion TEXT(150), in_id_departamento INT, in_id_municipio INT, in_tel VARCHAR(45),
 in_email TEXT(45), in_url TEXT(100), in_fecha_registro VARCHAR(45))
 
BEGIN

INSERT INTO Empresa (id_empresa, nit, nombre_empresa, direccion_empresa,  id_departamento, id_municipio,
telefono_empresa, email_empresa, url, fecha_registro) VALUES (in_id_empresa, in_nit, in_nombre_empresa, 
in_direccion, in_id_departamento, in_id_municipio, in_tel, in_email, in_url, in_fecha_registro);

END
//
DELIMITER ;


#Permite realiza una actualización de los datos de la Empresa en la base de datos
DELIMITER //

CREATE PROCEDURE updateEnterpriseInfo(in_direccion TEXT(150), in_id_departamento INT,  in_id_municipio INT, 
 in_tel VARCHAR(45), in_email TEXT(45), in_url TEXT(100))
 
BEGIN

UPDATE Empresa SET direccion_empresa=in_direccion, id_departamento=in_id_departamento,
id_municipio=in_id_municipio, telefono_empresa=in_tel, email_empresa=in_email, url=in_url 
WHERE id_empresa=1;

END
//
DELIMITER ;


#Procedimiento que permite seleccionar los datos de la Empresa
DELIMITER //

CREATE PROCEDURE selectEnterpriseInfo(in_id_empresa INT)
BEGIN

SELECT id_empresa, nit, nombre_empresa, direccion_empresa, id_municipio, id_departamento, 
telefono_empresa, email_empresa, url, fecha_registro FROM Empresa WHERE id_empresa=in_id_empresa;

END
//
DELIMITER ;


#Procedimiento que permite seleccionar los datos de la tabla Departamento
DELIMITER //

CREATE PROCEDURE selectDeps()
BEGIN

SELECT departamento FROM Departamento;

END
//
DELIMITER ;


#Procedimiento que permite seleccionar los datos de la tabla Municipio
DELIMITER //

CREATE PROCEDURE selectMun(in_id_departamento INT)
BEGIN
 
SELECT mu.municipio, mu.id_departamento FROM Municipio AS mu INNER JOIN Departamento AS de 
ON mu.id_departamento=de.id_departamento WHERE mu.id_departamento=in_id_departamento;

END
//
DELIMITER ;


#############################################################################
#									TRIGGERS								#
#############################################################################
#Se encarga de guardar registros de actualización de una Persona
DELIMITER //

CREATE TRIGGER update_person_logs_BU
BEFORE UPDATE ON Persona 
FOR EACH ROW

BEGIN
INSERT INTO Historial_persona (last_nombre, last_apellido, last_tipo_documento, 
last_numero_documento, last_fecha_nacimiento, last_id_departamento, last_id_municipio,  
last_email, last_celular, last_direccion, last_activo,
new_nombre, new_apellido, new_tipo_documento, new_numero_documento, new_fecha_nacimiento, 
new_id_departamento, new_id_municipio, new_email, new_celular, new_direccion, new_activo,
fecha, accion,  lugar, id_persona_actualizada) 
VALUES (OLD.nombre, OLD.apellido, OLD.tipo_documento, OLD.numero_documento, OLD.fecha_nacimiento,
OLD.id_departamento, OLD.id_municipio, OLD.email, OLD.celular, OLD.direccion, OLD.activo,
NEW.nombre, NEW.apellido, NEW.tipo_documento, NEW.numero_documento, NEW.fecha_nacimiento, 
NEW.id_departamento, NEW.id_municipio, NEW.email, NEW.celular, NEW.direccion, NEW.activo,
now(), "Se modificó la persona.", current_user(), OLD.id_persona);

END//

DELIMITER ;


#Se encarga de guardar registros de actualización de un Usuario 
DELIMITER //

CREATE TRIGGER update_user_logs_BU
BEFORE UPDATE ON Usuario 
FOR EACH ROW

BEGIN
INSERT INTO Historial_usuario (last_username, last_password, last_cargo, last_area, last_id_tipo_usuario, 
new_username, new_password, new_cargo, new_area, new_id_tipo_usuario, 
fecha, accion, lugar, id_usuario_actualizado) 
VALUES (OLD.username, OLD.password, OLD.cargo, OLD.area, OLD.id_tipo_usuario,
NEW.username, NEW.password, NEW.cargo, NEW.area, NEW.id_tipo_usuario,
 now(), "Se modificó el usuario.", current_user(), OLD.id_usuario);

END//

DELIMITER ;


#Se encarga de guardar registros de actualización de un Paciente 
DELIMITER //

CREATE TRIGGER update_patient_logs_BU
BEFORE UPDATE ON Paciente 
FOR EACH ROW

BEGIN
INSERT INTO Historial_paciente (last_rh, last_gestante, last_sexo, 
last_etnia, last_comunidad, last_id_programaPyDT,
new_rh, new_gestante, new_sexo, new_etnia, new_comunidad, new_id_programaPyDT,
fecha, accion, lugar, id_paciente_actualizado) 
VALUES (OLD.rh, OLD.gestante, OLD.sexo, OLD.etnia, OLD.comunidad, OLD.id_programaPyDT, 
NEW.rh, NEW.gestante, NEW.sexo, NEW.etnia, NEW.comunidad, NEW.id_programaPyDT,
 now(), "Se modificó el paciente.", current_user(), OLD.id_paciente);

END//

DELIMITER ;


#Se encarga de guardar registros de actualización de la Empresa 
DELIMITER //

CREATE TRIGGER update_enterprise_logs_BU
BEFORE UPDATE ON Empresa 
FOR EACH ROW

BEGIN
INSERT INTO Historial_empresa (last_direccion_empresa, last_id_departamento, last_id_municipio, 
last_telefono_empresa, last_url, last_email_empresa, new_direccion_empresa, new_id_municipio, 
new_id_departamento, new_telefono_empresa, new_url, new_email_empresa,
fecha, accion, lugar, id_empresa_actualizada) 
VALUES (OLD.direccion_empresa, OLD.id_departamento, OLD.id_municipio,  
OLD.telefono_empresa, OLD.url, OLD.email_empresa, 
NEW.direccion_empresa, NEW.id_departamento, NEW.id_municipio,
NEW.telefono_empresa, NEW.url, NEW.email_empresa, 
 now(), "Se modificó al empresa.", current_user(), OLD.id_empresa);

END//

DELIMITER ;


#Se encarga de guardar registros de actualización de la Historia Clínica de un paciente 
DELIMITER //

CREATE TRIGGER update_cHistory_logs_BU
BEFORE UPDATE ON HistoriaC 
FOR EACH ROW

BEGIN
INSERT INTO Historial_historiaC (last_motivo_consulta, last_eps, last_alergias_medicamentos, last_habitos,
last_enfermedad_actual, last_antecedentes_EP, last_antecedentes_EF, last_info_parto, last_diagnostico, 
last_medicamentos_formulados, 
new_motivo_consulta, new_eps, new_alergias_medicamentos, new_habitos, new_enfermedad_actual, new_antecedentes_EP, 
new_antecedentes_EF, new_info_parto, new_diagnostico, new_medicamentos_formulados, 
fecha, accion, lugar, id_historiaC_actualizada) 
VALUES (OLD.motivo_consulta, OLD.eps, OLD.alergias_medicamentos, OLD.habitos, OLD.enfermedad_actual, 
OLD.antecedentes_EP, OLD.antecedentes_EF, OLD.info_parto, OLD.diagnostico, OLD.medicamentos_formulados, 
NEW.motivo_consulta, NEW.eps, NEW.alergias_medicamentos, NEW.habitos, NEW.enfermedad_actual, 
NEW.antecedentes_EP, NEW.antecedentes_EF, NEW.info_parto, NEW.diagnostico, NEW.medicamentos_formulados, 
 now(), "Se modificó la historia clínica.", current_user(), OLD.id_historiaC);

END//

DELIMITER ;


#############################################################################
#									FUNCIONES								#
#############################################################################
#Función que permite verificar que la entidad Empresa contenga datos
DELIMITER //

CREATE FUNCTION counterEnterpriseInfo()
RETURNS INT
BEGIN

DECLARE x INT;
SET x = (SELECT  COUNT(id_empresa)
FROM Empresa 
WHERE id_empresa=1);
RETURN X;

END
//
DELIMITER ;

#Función que permite verificar que la entidad Usuario contenga por lo menos una fila
DELIMITER //

CREATE FUNCTION counterUSerAdmin()
RETURNS INT
BEGIN

DECLARE x INT;
SET x = (SELECT  COUNT(id_tipo_usuario)
FROM Usuario 
WHERE id_tipo_usuario=1);
RETURN x;

END
//
DELIMITER ;


#Función que permite contar el núermo de Usuarios con tipo de Usuario Administrador activos
DELIMITER //

CREATE FUNCTION counterAllAdmins()
RETURNS INT
BEGIN

DECLARE x INT;
SET x = (
SELECT COUNT(id_tipo_usuario) FROM persona AS pe INNER JOIN usuario AS u 
ON pe.id_persona=u.id_persona WHERE pe.activo=1 AND u.id_tipo_usuario=1
);
RETURN x;

END
//
DELIMITER ;


#Función que permite contar el núermo de Usuarios con tipo de Usuario Médico activos
DELIMITER //

CREATE FUNCTION counterAllMedics()
RETURNS INT
BEGIN

DECLARE x INT;
SET x = (SELECT COUNT(id_tipo_usuario) FROM persona AS pe INNER JOIN usuario AS u 
ON pe.id_persona=u.id_persona WHERE pe.activo=1 AND u.id_tipo_usuario=2);
RETURN x;

END
//
DELIMITER ;


#Función que permite contar el núermo de Usuarios con tipo de Usuario Recepcionista activos
DELIMITER //

CREATE FUNCTION counterAllRecepts()
RETURNS INT
BEGIN

DECLARE x INT;
SET x = (SELECT COUNT(id_tipo_usuario) FROM persona AS pe INNER JOIN usuario AS u 
ON pe.id_persona=u.id_persona WHERE pe.activo=1 AND u.id_tipo_usuario=3);
RETURN x;

END
//
DELIMITER ;


#Función que permite contar el núermo de Usuarios activos registrados en la base de datos.
DELIMITER //

CREATE FUNCTION counterAllUsers()
RETURNS INT
BEGIN

DECLARE x INT;
SET x = (SELECT COUNT(id_usuario) FROM persona AS pe INNER JOIN usuario AS u 
ON pe.id_persona=u.id_persona WHERE pe.activo=1);
RETURN x;

END
//
DELIMITER ;


#Función que permite contar el núermo de Pacientes activos registrados en la base de datos.
DELIMITER //

CREATE FUNCTION counterAllPatients()
RETURNS INT
BEGIN

DECLARE x INT;
SET x = (SELECT COUNT(id_paciente) FROM persona AS pe INNER JOIN paciente AS pa 
ON pe.id_persona=pa.id_persona WHERE pe.activo=1);
RETURN x;

END
//
DELIMITER ;


#Función que permite contar el núermo de Pacientes activos de la étnia Arhuaco registrados en la base de datos.
DELIMITER //

CREATE FUNCTION counterAllArhuaco()
RETURNS INT
BEGIN

DECLARE x INT;
SET x = (SELECT COUNT(id_paciente) FROM persona AS pe INNER JOIN paciente AS pa 
ON pe.id_persona=pa.id_persona WHERE pa.etnia="Arhuaco" AND pe.activo=1);
RETURN x;

END
//
DELIMITER ;


#Función que permite contar el núermo de Pacientes activos de la étnia Wiwa registrados en la base de datos.
DELIMITER //

CREATE FUNCTION counterAllWiwa()
RETURNS INT
BEGIN

DECLARE x INT;
SET x = (SELECT COUNT(id_paciente) FROM persona AS pe INNER JOIN paciente AS pa 
ON pe.id_persona=pa.id_persona WHERE pa.etnia="Wiwa" AND pe.activo=1);
RETURN x;

END
//
DELIMITER ;


#Función que permite contar el núermo de Pacientes activos de la étnia Kogui registrados en la base de datos.
DELIMITER //

CREATE FUNCTION counterAllKogui()
RETURNS INT
BEGIN

DECLARE x INT;
SET x = (SELECT COUNT(id_paciente) FROM persona AS pe INNER JOIN paciente AS pa 
ON pe.id_persona=pa.id_persona WHERE pa.etnia="Kogui" AND pe.activo=1);
RETURN x;

END
//
DELIMITER ;


#Función que permite contar el núermo de Pacientes activos de otras étnias registrados en la base de datos.
DELIMITER //

CREATE FUNCTION counterAllOthers()
RETURNS INT
BEGIN

DECLARE x INT;
SET x = (SELECT COUNT(id_paciente) FROM persona AS pe INNER JOIN paciente AS pa 
ON pe.id_persona=pa.id_persona WHERE pa.etnia="Otro" AND pe.activo=1);
RETURN x;

END
//
DELIMITER ;


#Función que permite obtener el ID del municipio seleccionado
DELIMITER //

CREATE FUNCTION getIDMunicipio(in_municipio VARCHAR(45))
RETURNS INT
BEGIN

DECLARE x INT;
SET x = (SELECT mu.id_municipio FROM Municipio AS mu
WHERE mu.municipio=in_municipio);
RETURN x;

END
//
DELIMITER ;


#Función que permite obtener el nombre del municipio seleccionado
DELIMITER //

CREATE FUNCTION getNameMunicipio(in_id_municipio INT)
RETURNS VARCHAR(45)
BEGIN

DECLARE x VARCHAR(45);
SET x = (SELECT mu.municipio FROM Municipio AS mu
WHERE mu.id_municipio=in_id_municipio);
RETURN x;

END
//
DELIMITER ;
