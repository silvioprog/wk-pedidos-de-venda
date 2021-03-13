CREATE TABLE `wk_pedidos`.`clientes` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `cidade` VARCHAR(100) NOT NULL,
  `uf` CHAR(2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `nome_INDEX` (`nome`));

INSERT INTO `wk_pedidos`.`clientes` (`nome`, `cidade`, `uf`) VALUES ('Alice Amanda', 'Salvador', 'BA');
INSERT INTO `wk_pedidos`.`clientes` (`nome`, `cidade`, `uf`) VALUES ('Arthur Gabriel', 'Salvador', 'BA');
INSERT INTO `wk_pedidos`.`clientes` (`nome`, `cidade`, `uf`) VALUES ('Helena Tomás', 'Salvador', 'BA');
INSERT INTO `wk_pedidos`.`clientes` (`nome`, `cidade`, `uf`) VALUES ('Bernardo Lorenzo', 'Salvador', 'BA');
INSERT INTO `wk_pedidos`.`clientes` (`nome`, `cidade`, `uf`) VALUES ('Miguel Aurora', 'Rio de Janeiro', 'RJ');
INSERT INTO `wk_pedidos`.`clientes` (`nome`, `cidade`, `uf`) VALUES ('Sophia Martin', 'Rio de Janeiro', 'RJ');
INSERT INTO `wk_pedidos`.`clientes` (`nome`, `cidade`, `uf`) VALUES ('Valentina Rodrigues', 'Recife', 'PE');
INSERT INTO `wk_pedidos`.`clientes` (`nome`, `cidade`, `uf`) VALUES ('Heitor Santana', 'Recife', 'PE');
INSERT INTO `wk_pedidos`.`clientes` (`nome`, `cidade`, `uf`) VALUES ('Laura Larissa', 'Brasília', 'DF');
INSERT INTO `wk_pedidos`.`clientes` (`nome`, `cidade`, `uf`) VALUES ('Davi Lucas', 'Brasília', 'DF');
INSERT INTO `wk_pedidos`.`clientes` (`nome`, `cidade`, `uf`) VALUES ('Isabella Laura', 'Brasília', 'DF');
INSERT INTO `wk_pedidos`.`clientes` (`nome`, `cidade`, `uf`) VALUES ('Lorenzo Rodrigues', 'São Paulo', 'SP');
INSERT INTO `wk_pedidos`.`clientes` (`nome`, `cidade`, `uf`) VALUES ('Manuela Martin', 'São Paulo', 'SP');
INSERT INTO `wk_pedidos`.`clientes` (`nome`, `cidade`, `uf`) VALUES ('Théo Lorenzo', 'São Paulo', 'SP');
INSERT INTO `wk_pedidos`.`clientes` (`nome`, `cidade`, `uf`) VALUES ('Júlia Aurora', 'São Paulo', 'SP');
INSERT INTO `wk_pedidos`.`clientes` (`nome`, `cidade`, `uf`) VALUES ('Pedro José', 'São Paulo', 'SP');
INSERT INTO `wk_pedidos`.`clientes` (`nome`, `cidade`, `uf`) VALUES ('Heloísa Tomás', 'São Paulo', 'SP');
INSERT INTO `wk_pedidos`.`clientes` (`nome`, `cidade`, `uf`) VALUES ('Gabriel Martin', 'João Pessoa', 'JP');
INSERT INTO `wk_pedidos`.`clientes` (`nome`, `cidade`, `uf`) VALUES ('Luiza Luana', 'João Pessoa', 'JP');
INSERT INTO `wk_pedidos`.`clientes` (`nome`, `cidade`, `uf`) VALUES ('Enzo Gabriel', 'João Pessoa', 'JP');

CREATE TABLE `wk_pedidos`.`produtos` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(100) NOT NULL,
  `preco` DECIMAL(18,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `nome_INDEX` (`descricao`));

INSERT INTO `wk_pedidos`.`produtos` (`descricao`, `preco`) VALUES ('Arroz da barra 1k', 6.23);
INSERT INTO `wk_pedidos`.`produtos` (`descricao`, `preco`) VALUES ('Sal grosso 1k', 3.48);
INSERT INTO `wk_pedidos`.`produtos` (`descricao`, `preco`) VALUES ('Sal refinado 1k', 5.67);
INSERT INTO `wk_pedidos`.`produtos` (`descricao`, `preco`) VALUES ('Açúcar refinado 1k', 6.14);
INSERT INTO `wk_pedidos`.`produtos` (`descricao`, `preco`) VALUES ('Miúdos para feijoada 2k', 22.65);
INSERT INTO `wk_pedidos`.`produtos` (`descricao`, `preco`) VALUES ('Cerveja latinha 300ml', 3.98);
INSERT INTO `wk_pedidos`.`produtos` (`descricao`, `preco`) VALUES ('Cerveja garrafa 600ml', 10.99);
INSERT INTO `wk_pedidos`.`produtos` (`descricao`, `preco`) VALUES ('Desodorante neutro 150ml', 15.25);
INSERT INTO `wk_pedidos`.`produtos` (`descricao`, `preco`) VALUES ('Sabão líquido 250ml', 8.10);
INSERT INTO `wk_pedidos`.`produtos` (`descricao`, `preco`) VALUES ('Sabão em pó 300g', 9.90);
INSERT INTO `wk_pedidos`.`produtos` (`descricao`, `preco`) VALUES ('Sabão em barras 300g', 5.45);
INSERT INTO `wk_pedidos`.`produtos` (`descricao`, `preco`) VALUES ('Linguiça de porco 600g', 18.90);
INSERT INTO `wk_pedidos`.`produtos` (`descricao`, `preco`) VALUES ('Linguiça de frango 600g', 16.90);
INSERT INTO `wk_pedidos`.`produtos` (`descricao`, `preco`) VALUES ('Linguiça de carne 600g', 21.80);
INSERT INTO `wk_pedidos`.`produtos` (`descricao`, `preco`) VALUES ('Amendoim torrado 200g', 4.55);
INSERT INTO `wk_pedidos`.`produtos` (`descricao`, `preco`) VALUES ('Amendoim japonês 200g', 6.45);
INSERT INTO `wk_pedidos`.`produtos` (`descricao`, `preco`) VALUES ('Cebola roxa 200g', 7.80);
INSERT INTO `wk_pedidos`.`produtos` (`descricao`, `preco`) VALUES ('Macarrão espaguete 150g', 7.60);
INSERT INTO `wk_pedidos`.`produtos` (`descricao`, `preco`) VALUES ('Farinha de milho 1k', 5.30);
INSERT INTO `wk_pedidos`.`produtos` (`descricao`, `preco`) VALUES ('Farinha de trigo 1k', 8.49);

CREATE TABLE `wk_pedidos`.`pedidos` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `cliente_id` BIGINT UNSIGNED NOT NULL,
  `total` DECIMAL(18,2) NOT NULL,
  `emissao` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `cliente_id_FOREIGN_KEY_idx` (`id` ASC, `cliente_id` ASC) VISIBLE,
  CONSTRAINT `cliente_id_FOREIGN_KEY`
    FOREIGN KEY (`cliente_id`)
    REFERENCES `wk_pedidos`.`clientes` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

CREATE TABLE `wk_pedidos`.`pedidos_produtos` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `pedido_id` BIGINT UNSIGNED NOT NULL,
  `produto_id` BIGINT UNSIGNED NOT NULL,
  `quantidade` INT NOT NULL,
  `preco` DECIMAL(18,2) NOT NULL,
  `total` DECIMAL(18,2) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `pedidos_id_FOREIGN_KEY_idx` (`pedido_id` ASC) VISIBLE,
  INDEX `produto_id_FOREIGN_KEY_idx` (`produto_id` ASC) VISIBLE,
  CONSTRAINT `pedido_id_FOREIGN_KEY`
    FOREIGN KEY (`pedido_id`)
    REFERENCES `wk_pedidos`.`pedidos` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `produto_id_FOREIGN_KEY`
    FOREIGN KEY (`produto_id`)
    REFERENCES `wk_pedidos`.`produtos` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);
