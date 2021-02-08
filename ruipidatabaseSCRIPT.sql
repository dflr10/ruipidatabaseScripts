-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema ruipidatabase
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ruipidatabase
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ruipidatabase` DEFAULT CHARACTER SET utf8 ;
USE `ruipidatabase` ;

-- -----------------------------------------------------
-- Table `ruipidatabase`.`Empresa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ruipidatabase`.`Empresa` (
  `id_empresa` INT NOT NULL AUTO_INCREMENT,
  `nit` INT NOT NULL,
  `nombre_empresa` VARCHAR(45) NOT NULL,
  `direccion_empresa` TEXT(150) NULL,
  `ciudad_empresa` VARCHAR(45) NULL,
  `departamento_empresa` VARCHAR(45) NULL,
  `telefono_empresa` INT NULL,
  `url` TEXT(100) NULL,
  `email_empresa` TEXT(45) NULL,
  PRIMARY KEY (`id_empresa`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ruipidatabase`.`Tipo_usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ruipidatabase`.`Tipo_usuario` (
  `id_tipo_usuario` INT NOT NULL AUTO_INCREMENT,
  `nombre_tipo_usuario` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_tipo_usuario`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ruipidatabase`.`Persona`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ruipidatabase`.`Persona` (
  `id_persona` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `apellido` VARCHAR(45) NOT NULL,
  `tipo_documento` VARCHAR(45) NULL,
  `numero_documento` VARCHAR(45) NULL,
  `fecha_nacimiento` DATE NULL,
  `ciudad_origen` VARCHAR(45) NULL,
  `departamento_origen` VARCHAR(45) NULL,
  `email` TEXT(45) NULL,
  `celular` VARCHAR(15) NULL,
  `direccion` TEXT(150) NULL,
  `fecha_registro` VARCHAR(45) NULL,
  PRIMARY KEY (`id_persona`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ruipidatabase`.`Usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ruipidatabase`.`Usuario` (
  `id_usuario` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `cargo` VARCHAR(45) NULL,
  `area` VARCHAR(45) NULL,
  `ultima_sesion` DATETIME NULL,
  `id_persona` INT NOT NULL,
  `id_empresa` INT NOT NULL,
  `id_tipo_usuario` INT NOT NULL,
  PRIMARY KEY (`id_usuario`),
  INDEX `fk_Usuario_Persona1_idx` (`id_persona` ASC) VISIBLE,
  INDEX `fk_Usuario_Empresa1_idx` (`id_empresa` ASC) VISIBLE,
  INDEX `fk_Usuario_Tipo_usuario1_idx` (`id_tipo_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_Usuario_Persona1`
    FOREIGN KEY (`id_persona`)
    REFERENCES `ruipidatabase`.`Persona` (`id_persona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Usuario_Empresa1`
    FOREIGN KEY (`id_empresa`)
    REFERENCES `ruipidatabase`.`Empresa` (`id_empresa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Usuario_Tipo_usuario1`
    FOREIGN KEY (`id_tipo_usuario`)
    REFERENCES `ruipidatabase`.`Tipo_usuario` (`id_tipo_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ruipidatabase`.`Programa_PyDT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ruipidatabase`.`Programa_PyDT` (
  `id_programaPyDT` INT NOT NULL AUTO_INCREMENT,
  `nombre_programaPyDT` VARCHAR(100) NULL,
  PRIMARY KEY (`id_programaPyDT`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ruipidatabase`.`Paciente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ruipidatabase`.`Paciente` (
  `id_paciente` INT NOT NULL AUTO_INCREMENT,
  `huella` LONGBLOB NOT NULL,
  `rh` VARCHAR(45) NULL,
  `gestante` VARCHAR(45) NULL,
  `sexo` VARCHAR(45) NULL,
  `etnia` VARCHAR(45) NULL,
  `comunidad` VARCHAR(45) NULL,
  `municipio` VARCHAR(45) NULL,
  `id_persona` INT NOT NULL,
  `id_programaPyDT` INT NULL,
  PRIMARY KEY (`id_paciente`),
  INDEX `fk_Paciente_Persona1_idx` (`id_persona` ASC) VISIBLE,
  INDEX `fk_Paciente_Programa_PyDT1_idx` (`id_programaPyDT` ASC) VISIBLE,
  CONSTRAINT `fk_Paciente_Persona1`
    FOREIGN KEY (`id_persona`)
    REFERENCES `ruipidatabase`.`Persona` (`id_persona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Paciente_Programa_PyDT1`
    FOREIGN KEY (`id_programaPyDT`)
    REFERENCES `ruipidatabase`.`Programa_PyDT` (`id_programaPyDT`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ruipidatabase`.`Paciente_Usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ruipidatabase`.`Paciente_Usuario` (
  `id_paciente` INT NOT NULL,
  `id_usuario` INT NOT NULL,
  PRIMARY KEY (`id_paciente`, `id_usuario`),
  INDEX `fk_Paciente_has_Usuario_Usuario1_idx` (`id_usuario` ASC) VISIBLE,
  INDEX `fk_Paciente_has_Usuario_Paciente1_idx` (`id_paciente` ASC) VISIBLE,
  CONSTRAINT `fk_Paciente_has_Usuario_Paciente1`
    FOREIGN KEY (`id_paciente`)
    REFERENCES `ruipidatabase`.`Paciente` (`id_paciente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Paciente_has_Usuario_Usuario1`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `ruipidatabase`.`Usuario` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ruipidatabase`.`timestamps`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ruipidatabase`.`timestamps` (
  `create_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` TIMESTAMP NULL);


-- -----------------------------------------------------
-- Table `ruipidatabase`.`HistoriaC`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ruipidatabase`.`HistoriaC` (
  `id_HistoriaC` INT NOT NULL AUTO_INCREMENT,
  `motivo_consulta` MEDIUMTEXT NOT NULL,
  `fecha_consulta` DATETIME NULL,
  `eps` VARCHAR(45) NULL,
  `alergias_medicamentos` VARCHAR(250) NULL,
  `habitos` VARCHAR(250) NULL,
  `enfermedad_actual` VARCHAR(250) NULL,
  `antecedente_EP` VARCHAR(250) NULL,
  `antecedentes_EF` VARCHAR(250) NULL,
  `info_parto` LONGTEXT NULL,
  `diagnostico` LONGTEXT NULL,
  `medicamentos_formulados` LONGTEXT NULL,
  `id_paciente` INT NOT NULL,
  PRIMARY KEY (`id_HistoriaC`),
  INDEX `fk_HistoriaC_Paciente1_idx` (`id_paciente` ASC) VISIBLE,
  CONSTRAINT `fk_HistoriaC_Paciente1`
    FOREIGN KEY (`id_paciente`)
    REFERENCES `ruipidatabase`.`Paciente` (`id_paciente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

#Ingresar datos de tipos de usuario
INSERT INTO Tipo_usuario (nombre_tipo_usuario) VALUES ('Administrador');
INSERT INTO Tipo_usuario (nombre_tipo_usuario) VALUES ('Médico');
INSERT INTO Tipo_usuario (nombre_tipo_usuario) VALUES ('Recepción');

#Ingresar Programas Prevención y Detección Temprana de Enfermedades
INSERT INTO Programa_PyDT (nombre_programaPyDT) VALUES('Alteraciones Crecimiento y Desarrollo');
INSERT INTO Programa_PyDT (nombre_programaPyDT) VALUES('Alteraciones Desarrollo del Joven');
INSERT INTO Programa_PyDT (nombre_programaPyDT) VALUES('Alteraciones del Embarazo');
INSERT INTO Programa_PyDT (nombre_programaPyDT) VALUES('Alteraciones en el Adulto');
INSERT INTO Programa_PyDT (nombre_programaPyDT) VALUES('Cáncer de Seno');
