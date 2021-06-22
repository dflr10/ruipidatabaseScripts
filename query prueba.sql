

#Usando el botón de eliminar a la inversa Paciente
UPDATE persona, paciente SET persona.activo=true 
WHERE persona.id_persona = paciente.id_persona AND paciente.id_paciente= 1;

#Usando el botón de eliminar a la inversa Usuario
UPDATE persona, usuario SET persona.activo=0 
WHERE persona.id_persona = usuario.id_persona AND usuario.id_usuario= 1;




SELECT * FROM Tipo_usuario;
 
SELECT * FROM Persona;

SELECT * FROM Paciente;

SELECT * FROM Usuario;

SELECT * FROM Programa_PyDT;

SELECT * FROM Empresa;

SELECT * FROM HistoriaC;

SELECT * FROM Historial_persona;

SELECT * FROM Historial_usuario;

SELECT * FROM Historial_paciente;

SELECT * FROM Historial_empresa;

SELECT * FROM Historial_historiaC;

SELECT * FROM Departamento;
