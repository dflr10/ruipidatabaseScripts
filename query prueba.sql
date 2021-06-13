
#Usando el botón de eliminar a la inversa Paciente
UPDATE persona, paciente SET persona.activo=true 
WHERE persona.id_persona = paciente.id_persona AND paciente.id_paciente= 2;

#Usando el botón de eliminar a la inversa Usuario
UPDATE persona, usuario SET persona.activo=true 
WHERE persona.id_persona = usuario.id_persona AND usuario.id_usuario= 2;



SELECT * FROM Tipo_usuario;
 
SELECT * FROM Persona;

SELECT * FROM Paciente;

SELECT * FROM Usuario;

SELECT * FROM Programa_PyDT;

SELECT * FROM Empresa;

SELECT * FROM Historial_persona;

SELECT * FROM Historial_usuario;

SELECT * FROM Historial_paciente;

SELECT * FROM Historial_empresa;
