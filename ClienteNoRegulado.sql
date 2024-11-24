SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mercado_no_regulado
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mercado_no_regulado`;

CREATE SCHEMA IF NOT EXISTS `mercado_no_regulado` DEFAULT CHARACTER SET utf8 ;
USE `mercado_no_regulado` ;

-- -----------------------------------------------------
-- Table tipoDocumento
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tipoDocumento` (
  `idDocumento` INT NOT NULL AUTO_INCREMENT,
  `nombreDocumento` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idDocumento`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table cliente
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cliente` (
  `idCliente` INT NOT NULL AUTO_INCREMENT,
  `primerNombre` VARCHAR(45) NOT NULL,
  `segundoNombre` VARCHAR(45) NULL,
  `primerApellido` VARCHAR(45) NOT NULL,
  `nui` BIGINT NOT NULL, -- Número Único de Identificación
  `nacionalidad` VARCHAR(45) NOT NULL,
  `fechaNacimiento` DATE NOT NULL, -- Cambiado a DATE
  `celular` BIGINT NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `razonSocial` VARCHAR(45) NOT NULL,
  `nit` BIGINT NOT NULL,
  `fechaCreacionEmpresa` DATE NOT NULL, -- Cambiado a DATE
  `tipoDocumento_idDocumento` INT NOT NULL,
  PRIMARY KEY (`idCliente`),
  FOREIGN KEY (`tipoDocumento_idDocumento`)
    REFERENCES `tipoDocumento` (`idDocumento`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table correspondencia
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `correspondencia` (
  `idCorrespondencia` INT NOT NULL AUTO_INCREMENT,
  `direccion` VARCHAR(255) NOT NULL, -- Aumentada longitud
  `codigoPostal` VARCHAR(45) NOT NULL,
  `cliente_idCliente` INT NOT NULL,
  PRIMARY KEY (`idCorrespondencia`),
  FOREIGN KEY (`cliente_idCliente`)
    REFERENCES `cliente` (`idCliente`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table consumo
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `consumo` (
  `idConsumo` INT NOT NULL AUTO_INCREMENT,
  `KwhConsumidos` DECIMAL(10,2) NOT NULL, -- Mejor utilizar DECIMAL para valores numéricos
  `fechaConsumo` DATE NOT NULL, -- Cambiado a DATE
  `totalMes` DECIMAL(10,2) NOT NULL,
  `totalContrato` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`idConsumo`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table contador
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `contador` (
  `idContador` INT NOT NULL AUTO_INCREMENT,
  `marca` VARCHAR(45) NOT NULL,
  `numeroContador` VARCHAR(45) NOT NULL,
  `fechaInstalacion` DATE NOT NULL, -- Cambiado a DATE
  `consumo_idConsumo` INT NOT NULL,
  PRIMARY KEY (`idContador`),
  FOREIGN KEY (`consumo_idConsumo`)
    REFERENCES `consumo` (`idConsumo`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table departamento
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `departamento` (
  `idDepartamento` INT NOT NULL AUTO_INCREMENT,
  `nombreDepartamento` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idDepartamento`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table municipio
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `municipio` (
  `idMunicipio` INT NOT NULL AUTO_INCREMENT,
  `nombreMunicipio` VARCHAR(45) NOT NULL,
  `departamento_idDepartamento` INT NOT NULL,
  PRIMARY KEY (`idMunicipio`),
  FOREIGN KEY (`departamento_idDepartamento`)
    REFERENCES `departamento` (`idDepartamento`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table contrato
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `contrato` (
  `idContrato` INT NOT NULL AUTO_INCREMENT,
  `precioKwh` DECIMAL(10,2) NOT NULL, -- Cambiado a DECIMAL
  `direccion` VARCHAR(255) NOT NULL,
  `fechaInicio` DATE NOT NULL, -- Cambiado a DATE
  `fechaTerminacion` DATE NOT NULL, -- Cambiado a DATE
  `valorPiso` DECIMAL(10,2) NOT NULL,
  `valorTecho` DECIMAL(10,2) NOT NULL,
  `contador_idContador` INT NOT NULL,
  `cliente_idCliente` INT NOT NULL,
  `municipio_idMunicipio` INT NOT NULL,
  PRIMARY KEY (`idContrato`),
  FOREIGN KEY (`contador_idContador`)
    REFERENCES `contador` (`idContador`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`cliente_idCliente`)
    REFERENCES `cliente` (`idCliente`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`municipio_idMunicipio`)
    REFERENCES `municipio` (`idMunicipio`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table factura
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `factura` (
  `idFactura` INT NOT NULL AUTO_INCREMENT,
  `consumoMensual` DECIMAL(10,2) NOT NULL,
  `tarifaMensual` DECIMAL(10,2) NOT NULL,
  `mes` VARCHAR(45) NOT NULL,
  `anio` YEAR NOT NULL, -- Cambiado a YEAR
  `contrato_idContrato` INT NOT NULL,
  PRIMARY KEY (`idFactura`),
  FOREIGN KEY (`contrato_idContrato`)
    REFERENCES `contrato` (`idContrato`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
