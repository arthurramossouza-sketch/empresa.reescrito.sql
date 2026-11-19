-- Estrutura reorganizada do banco de dados empresa
-- Mantém as tabelas, colunas, tipos, valores padrão, índices,
-- relacionamentos e registros presentes no arquivo original.

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";
SET NAMES utf8mb4;

START TRANSACTION;

CREATE DATABASE IF NOT EXISTS `empresa`;
USE `empresa`;

-- Tabelas sem dependências
CREATE TABLE `unidades_senai` (
  `id_unidade` int NOT NULL AUTO_INCREMENT,
  `nome_unidade` varchar(100) NOT NULL,
  `cidade` varchar(50) NOT NULL,
  PRIMARY KEY (`id_unidade`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `tipos_maquinas` (
  `id_tipo` int NOT NULL,
  `nomes_tipo` varchar(50) NOT NULL,
  `horas_revisao_padrao` int DEFAULT NULL,
  PRIMARY KEY (`id_tipo`)
) ENGINE=InnoDB;

CREATE TABLE `tecnicos` (
  `id_tecnico` int NOT NULL,
  `nome_tecnico` varchar(100) DEFAULT NULL,
  `especialidade` varchar(50) DEFAULT NULL,
  `nivel_certificado` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_tecnico`)
) ENGINE=InnoDB;

CREATE TABLE `estoque_pecas` (
  `id_peca` int NOT NULL AUTO_INCREMENT,
  `codigo_part_number` varchar(50) DEFAULT NULL,
  `descricao` varchar(150) DEFAULT NULL,
  `quantidade_estoque` int DEFAULT NULL,
  `preco_unitario` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id_peca`),
  UNIQUE KEY `codigo_part_number` (`codigo_part_number`)
) ENGINE=InnoDB;

-- Tabelas que dependem de unidades, tipos ou outras tabelas principais
CREATE TABLE `linhas_producao` (
  `id_linha` int NOT NULL AUTO_INCREMENT,
  `nome_linha` varchar(100) NOT NULL,
  `id_unidade` int NOT NULL,
  PRIMARY KEY (`id_linha`),
  KEY `fk_id_linha` (`id_unidade`),
  CONSTRAINT `fk_id_linha` FOREIGN KEY (`id_unidade`)
    REFERENCES `unidades_senai` (`id_unidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `maquinas_senai` (
  `id_maquina` int NOT NULL,
  `id_linha` int DEFAULT NULL,
  `id_tipo` int DEFAULT NULL,
  `tag_patrimonio` varchar(30) DEFAULT NULL,
  `data_aquisicao` date DEFAULT NULL,
  `status_operacao` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id_maquina`),
  UNIQUE KEY `tag_patrimonio` (`tag_patrimonio`),
  KEY `fk_linha` (`id_linha`),
  KEY `fk_id_tipo` (`id_tipo`),
  CONSTRAINT `fk_id_tipo` FOREIGN KEY (`id_tipo`)
    REFERENCES `tipos_maquinas` (`id_tipo`),
  CONSTRAINT `fk_linha` FOREIGN KEY (`id_linha`)
    REFERENCES `linhas_producao` (`id_linha`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `ordens_servico` (
  `id_ordem` int NOT NULL AUTO_INCREMENT,
  `id_maquina` int DEFAULT NULL,
  `id_tecnico` int DEFAULT NULL,
  `data_abertura` datetime DEFAULT NULL,
  `tipo_manutenção` varchar(20) DEFAULT NULL,
  `STATUS_os` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id_ordem`),
  KEY `fk_id_maquinas` (`id_maquina`),
  KEY `fk_id_tecnico` (`id_tecnico`),
  CONSTRAINT `fk_id_maquinas` FOREIGN KEY (`id_maquina`)
    REFERENCES `maquinas_senai` (`id_maquina`),
  CONSTRAINT `fk_id_tecnico` FOREIGN KEY (`id_tecnico`)
    REFERENCES `tecnicos` (`id_tecnico`)
) ENGINE=InnoDB;

-- Tabelas dependentes das ordens de serviço e das máquinas
CREATE TABLE `componentes_maquina` (
  `id_componente` int NOT NULL,
  `id_maquina` int DEFAULT NULL,
  `nome_componente` varchar(100) DEFAULT NULL,
  `horas_uso_acumulado` int DEFAULT NULL,
  `limite_horas_alerta` int DEFAULT NULL,
  PRIMARY KEY (`id_componente`),
  KEY `fk_id_maquina` (`id_maquina`),
  CONSTRAINT `fk_id_maquina` FOREIGN KEY (`id_maquina`)
    REFERENCES `maquinas_senai` (`id_maquina`)
) ENGINE=InnoDB;

CREATE TABLE `historico_sensores` (
  `id_leitura` int NOT NULL AUTO_INCREMENT,
  `id_ordem` int DEFAULT NULL,
  `temperatura_medida` decimal(5,2) DEFAULT NULL,
  `vibracao_mm_s` decimal(5,2) DEFAULT NULL,
  `data_hora_leitura` datetime DEFAULT NULL,
  `prompt_geracao_ia` varchar(100) DEFAULT 'gerado_por_llm',
  PRIMARY KEY (`id_leitura`),
  KEY `fk_ordem` (`id_ordem`),
  CONSTRAINT `fk_ordem` FOREIGN KEY (`id_ordem`)
    REFERENCES `ordens_servico` (`id_ordem`)
) ENGINE=InnoDB;

CREATE TABLE `pecas_os` (
  `id_ordem` int NOT NULL,
  `id_peca` int NOT NULL,
  `quantidade_utilizada` int DEFAULT NULL,
  `preco_aplicado` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id_ordem`, `id_peca`),
  KEY `fk_id_peca` (`id_peca`),
  CONSTRAINT `fk_id_ordem` FOREIGN KEY (`id_ordem`)
    REFERENCES `ordens_servico` (`id_ordem`),
  CONSTRAINT `fk_id_peca` FOREIGN KEY (`id_peca`)
    REFERENCES `estoque_pecas` (`id_peca`)
) ENGINE=InnoDB;

-- Dados que estavam presentes no arquivo original
INSERT INTO `unidades_senai` (`id_unidade`, `nome_unidade`, `cidade`) VALUES
(1, 'SENAI Umuarama', 'Umuarama'),
(2, 'SENAI Curitiba', 'Curitiba'),
(3, 'SENAI Londrina', 'Londrina'),
(4, 'SENAI Maringa', 'Maringa'),
(5, 'SENAI Cascavel', 'Cascavel'),
(6, 'SENAI Umuarama', 'Umuarama'),
(7, 'SENAI Curitiba', 'Curitiba'),
(8, 'SENAI Londrina', 'Londrina'),
(9, 'SENAI Maringa', 'Maringa'),
(10, 'SENAI Cascavel', 'Cascavel');

COMMIT;
