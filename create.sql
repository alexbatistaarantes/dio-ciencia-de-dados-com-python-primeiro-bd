-- ----------------------------------------------------------------------
-- DATABASE

DROP DATABASE ecommerce;
CREATE DATABASE ecommerce;
USE ecommerce;

-- ----------------------------------------------------------------------
-- TABELAS

-- Categoria Produto
DROP TABLE IF EXISTS categoria_produto;
CREATE TABLE categoria_produto(
	id INT NOT NULL AUTO_INCREMENT,
	nome VARCHAR(30) NOT NULL UNIQUE,
	
	PRIMARY KEY(id)
);

-- Produto
DROP TABLE IF EXISTS produto;
CREATE TABLE produto(
	id INT NOT NULL AUTO_INCREMENT,
	nome VARCHAR(30) NOT NULL,
	id_categoria INT NOT NULL,
	
	PRIMARY KEY(id),
	FOREIGN KEY(id_categoria) REFERENCES categoria_produto(id) ON DELETE CASCADE
);

-- Fornecedor
DROP TABLE IF EXISTS fornecedor;
CREATE TABLE fornecedor(
	id INT NOT NULL AUTO_INCREMENT,
	razao_social VARCHAR(50) NOT NULL,
	cnpj VARCHAR(14) NOT NULL UNIQUE,
	
	PRIMARY KEY(id)
);

-- Fornecedor disponibiliza produto
DROP TABLE IF EXISTS fornecedor_produto;
CREATE TABLE fornecedor_produto(
	id_fornecedor INT NOT NULL,
	id_produto INT NOT NULL,
	
	FOREIGN KEY(id_fornecedor) REFERENCES fornecedor(id) ON DELETE CASCADE,
	FOREIGN KEY(id_produto) REFERENCES produto(id) ON DELETE CASCADE
);

-- Estoque
DROP TABLE IF EXISTS estoque;
CREATE TABLE estoque(
	id INT NOT NULL AUTO_INCREMENT,
	local_estoque VARCHAR(50) NOT NULL,
	
	PRIMARY KEY(id)
);

-- Estoque de produto
DROP TABLE IF EXISTS estoque_produto;
CREATE TABLE estoque_produto(
	id_estoque INT NOT NULL,
	id_produto INT NOT NULL,
	quantidade INT DEFAULT 0,
	
	FOREIGN KEY(id_estoque) REFERENCES estoque(id) ON DELETE CASCADE,
	FOREIGN KEY(id_produto) REFERENCES produto(id) ON DELETE CASCADE
);

-- Cliente
DROP TABLE IF EXISTS cliente;
CREATE TABLE cliente(
	id INT NOT NULL AUTO_INCREMENT,
	nome VARCHAR(100) NOT NULL,
	cpf CHAR(11) NOT NULL UNIQUE,
	endereco VARCHAR(100),
	data_de_nascimento DATE NOT NULL,
	
	PRIMARY KEY(id)
);

-- Pedido
DROP TABLE IF EXISTS pedido;
CREATE TABLE pedido(
	id INT NOT NULL AUTO_INCREMENT,
	id_cliente INT NOT NULL,
	status_do_pedido ENUM('Cancelado', 'Concluído', 'Em progresso') DEFAULT 'Em progresso' NOT NULL,
	
	PRIMARY KEY(id),
	FOREIGN KEY(id_cliente) REFERENCES cliente(id) ON DELETE CASCADE
);

-- Produtos de um pedido
DROP TABLE IF EXISTS produto_pedido;
CREATE TABLE produto_pedido(
	id_produto INT NOT NULL,
	id_pedido INT NOT NULL,
	quantidade INT NOT NULL DEFAULT 1,
	
	FOREIGN KEY(id_produto) REFERENCES produto(id) ON DELETE CASCADE,
	FOREIGN KEY(id_pedido) REFERENCES pedido(id) ON DELETE CASCADE
);

-- ----------------------------------------------------------------------
