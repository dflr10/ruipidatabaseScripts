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
  `direccion_empresa` TEXT(45) NULL,
  `ciudad_empresa` VARCHAR(45) NULL,
  `departamento_empresa` VARCHAR(45) NULL,
  `telefono_empresa` INT NULL,
  `url` TEXT(45) NULL,
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
  `email` VARCHAR(45) NULL,
  `tipo_documento` VARCHAR(45) NULL,
  `numero_documento` INT NULL,
  `celular` INT NULL,
  `fecha_nacimiento` DATETIME NULL,
  `ciudad_origen` VARCHAR(45) NULL,
  `departamento_origen` VARCHAR(45) NULL,
  `direccion` VARCHAR(45) NULL,
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
  `Persona_id_persona` INT NOT NULL,
  `Empresa_id_empresa` INT NOT NULL,
  `Tipo_usuario_id_tipo_usuario` INT NOT NULL,
  PRIMARY KEY (`id_usuario`),
  INDEX `fk_Usuario_Persona1_idx` (`Persona_id_persona` ASC) VISIBLE,
  INDEX `fk_Usuario_Empresa1_idx` (`Empresa_id_empresa` ASC) VISIBLE,
  INDEX `fk_Usuario_Tipo_usuario1_idx` (`Tipo_usuario_id_tipo_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_Usuario_Persona1`
    FOREIGN KEY (`Persona_id_persona`)
    REFERENCES `ruipidatabase`.`Persona` (`id_persona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Usuario_Empresa1`
    FOREIGN KEY (`Empresa_id_empresa`)
    REFERENCES `ruipidatabase`.`Empresa` (`id_empresa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Usuario_Tipo_usuario1`
    FOREIGN KEY (`Tipo_usuario_id_tipo_usuario`)
    REFERENCES `ruipidatabase`.`Tipo_usuario` (`id_tipo_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ruipidatabase`.`Programa_PyDT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ruipidatabase`.`Programa_PyDT` (
  `id_programaPyDT` INT NOT NULL AUTO_INCREMENT,
  `nombre_programaPyDT` VARCHAR(45) NULL,
  PRIMARY KEY (`id_programaPyDT`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ruipidatabase`.`Paciente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ruipidatabase`.`Paciente` (
  `id_paciente` INT NOT NULL AUTO_INCREMENT,
  `huella` LONGBLOB NOT NULL,
  `rh` VARCHAR(45) NULL,
  `gestante` TINYINT NULL,
  `sexo` CHAR(1) NULL,
  `etnia` VARCHAR(45) NULL,
  `comunidad` VARCHAR(45) NULL,
  `municipio` VARCHAR(45) NULL,
  `fecha_registro` VARCHAR(45) NULL,
  `Persona_id_persona` INT NOT NULL,
  `Programa_PyDT_id_programaPyDT` INT NOT NULL,
  PRIMARY KEY (`id_paciente`),
  INDEX `fk_Paciente_Persona1_idx` (`Persona_id_persona` ASC) VISIBLE,
  INDEX `fk_Paciente_Programa_PyDT1_idx` (`Programa_PyDT_id_programaPyDT` ASC) VISIBLE,
  CONSTRAINT `fk_Paciente_Persona1`
    FOREIGN KEY (`Persona_id_persona`)
    REFERENCES `ruipidatabase`.`Persona` (`id_persona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Paciente_Programa_PyDT1`
    FOREIGN KEY (`Programa_PyDT_id_programaPyDT`)
    REFERENCES `ruipidatabase`.`Programa_PyDT` (`id_programaPyDT`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ruipidatabase`.`Paciente_Usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ruipidatabase`.`Paciente_Usuario` (
  `Paciente_id_paciente` INT NOT NULL,
  `Usuario_id_usuario` INT NOT NULL,
  PRIMARY KEY (`Paciente_id_paciente`, `Usuario_id_usuario`),
  INDEX `fk_Paciente_has_Usuario_Usuario1_idx` (`Usuario_id_usuario` ASC) VISIBLE,
  INDEX `fk_Paciente_has_Usuario_Paciente1_idx` (`Paciente_id_paciente` ASC) VISIBLE,
  CONSTRAINT `fk_Paciente_has_Usuario_Paciente1`
    FOREIGN KEY (`Paciente_id_paciente`)
    REFERENCES `ruipidatabase`.`Paciente` (`id_paciente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Paciente_has_Usuario_Usuario1`
    FOREIGN KEY (`Usuario_id_usuario`)
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
  `fecha_consulta` VARCHAR(45) NULL,
  `eps` VARCHAR(45) NULL,
  `alergias_medicamentos` VARCHAR(45) NULL,
  `habitos` VARCHAR(45) NULL,
  `enfermedad_actual` VARCHAR(45) NULL,
  `antecedente_EP` VARCHAR(45) NULL,
  `antecedentes_EF` VARCHAR(45) NULL,
  `info_proced_Q` VARCHAR(45) NULL,
  `info_parto` VARCHAR(45) NULL,
  `diagnostico` LONGTEXT NULL,
  `Paciente_id_paciente` INT NOT NULL,
  PRIMARY KEY (`id_HistoriaC`),
  INDEX `fk_HistoriaC_Paciente1_idx` (`Paciente_id_paciente` ASC) VISIBLE,
  CONSTRAINT `fk_HistoriaC_Paciente1`
    FOREIGN KEY (`Paciente_id_paciente`)
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