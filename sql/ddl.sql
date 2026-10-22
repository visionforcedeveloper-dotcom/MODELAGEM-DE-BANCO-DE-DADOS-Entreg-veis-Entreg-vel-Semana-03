-- =====================================================================
--  PIZZARIA — SCRIPT DDL (Data Definition Language)
--  SGBD: PostgreSQL 12+
--  Criação das tabelas com chaves primárias, estrangeiras e restrições
-- =====================================================================

-- Drop tables se já existirem (ordem reversa de dependência)
DROP TABLE IF EXISTS item_pedido CASCADE;
DROP TABLE IF EXISTS pizza_ingrediente CASCADE;
DROP TABLE IF EXISTS ingrediente CASCADE;
DROP TABLE IF EXISTS pizza CASCADE;
DROP TABLE IF EXISTS pedido CASCADE;
DROP TABLE IF EXISTS entregador CASCADE;
DROP TABLE IF EXISTS cliente CASCADE;
DROP TABLE IF EXISTS categoria CASCADE;

-- =====================================================================
--  TABELA: categoria
--  Armazena as categorias das pizzas (Tradicional, Especial, Doce)
--  3FN: elimina a dependência transitiva pizza -> id_categoria -> nome
-- =====================================================================
CREATE TABLE categoria (
    id_categoria SERIAL PRIMARY KEY,
    nome         VARCHAR(50)  NOT NULL UNIQUE,
    descricao    VARCHAR(200)
);

-- =====================================================================
--  TABELA: cliente
--  Armazena os dados dos clientes
--  1FN: endereço decomposto em rua, numero, bairro, cidade, cep
-- =====================================================================
CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    nome       VARCHAR(100) NOT NULL,
    telefone   VARCHAR(20)  NOT NULL,
    email      VARCHAR(100) UNIQUE,
    rua        VARCHAR(100) NOT NULL,
    numero     VARCHAR(10)  NOT NULL,
    bairro     VARCHAR(50)  NOT NULL,
    cidade     VARCHAR(50)  NOT NULL,
    cep        VARCHAR(10)  NOT NULL
);

-- =====================================================================
--  TABELA: entregador
--  Armazena os dados dos entregadores
--  3FN: elimina a dependência transitiva pedido -> id_entregador -> nome
-- =====================================================================
CREATE TABLE entregador (
    id_entregador SERIAL PRIMARY KEY,
    nome          VARCHAR(100) NOT NULL,
    telefone      VARCHAR(20)  NOT NULL
);

-- =====================================================================
--  TABELA: pizza
--  Armazena o cardápio de pizzas
--  FK para categoria (3FN)
--  Restrições: preço > 0, tamanho em valores válidos
-- =====================================================================
CREATE TABLE pizza (
    id_pizza     SERIAL PRIMARY KEY,
    nome         VARCHAR(50)  NOT NULL UNIQUE,
    descricao    VARCHAR(200),
    preco        DECIMAL(10,2) NOT NULL CHECK (preco > 0),
    tamanho      VARCHAR(20)  NOT NULL CHECK (tamanho IN ('Pequena', 'Média', 'Grande', 'Família')),
    id_categoria INT          NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);

-- =====================================================================
--  TABELA: ingrediente
--  Armazena os ingredientes disponíveis
--  2FN: elimina dependência parcial em pizza_ingrediente
-- =====================================================================
CREATE TABLE ingrediente (
    id_ingrediente SERIAL PRIMARY KEY,
    nome           VARCHAR(50) NOT NULL UNIQUE,
    unidade_medida VARCHAR(20) NOT NULL CHECK (unidade_medida IN ('kg', 'g', 'L', 'ml', 'unidade'))
);

-- =====================================================================
--  TABELA: pizza_ingrediente (associativa N:M)
--  Relaciona pizzas e ingredientes com a quantidade usada
--  2FN: quantidade depende de ambas as partes da PK composta
-- =====================================================================
CREATE TABLE pizza_ingrediente (
    id_pizza       INT           NOT NULL,
    id_ingrediente INT           NOT NULL,
    quantidade     DECIMAL(10,2) NOT NULL CHECK (quantidade > 0),
    PRIMARY KEY (id_pizza, id_ingrediente),
    FOREIGN KEY (id_pizza)       REFERENCES pizza(id_pizza),
    FOREIGN KEY (id_ingrediente) REFERENCES ingrediente(id_ingrediente)
);

-- =====================================================================
--  TABELA: pedido
--  Armazena os pedidos realizados
--  FK para cliente e entregador (3FN)
--  Restrições: valor_total >= 0, status em valores válidos
--  DEFAULT: data_pedido = timestamp atual, status = 'Pendente'
-- =====================================================================
CREATE TABLE pedido (
    id_pedido    SERIAL PRIMARY KEY,
    data_pedido  TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valor_total  DECIMAL(10,2) NOT NULL CHECK (valor_total >= 0),
    status       VARCHAR(20)   NOT NULL DEFAULT 'Pendente'
        CHECK (status IN ('Pendente', 'Em Preparo', 'Pronto', 'Em Entrega', 'Entregue', 'Cancelado')),
    id_cliente   INT NOT NULL,
    id_entregador INT,
    FOREIGN KEY (id_cliente)   REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_entregador) REFERENCES entregador(id_entregador)
);

-- =====================================================================
--  TABELA: item_pedido (associativa N:M)
--  Relaciona pedidos e pizzas com quantidade e preço no momento do pedido
--  2FN: preco_unitario depende de ambas as partes da PK (preço do pedido)
-- =====================================================================
CREATE TABLE item_pedido (
    id_pedido      INT           NOT NULL,
    id_pizza       INT           NOT NULL,
    quantidade    INT           NOT NULL CHECK (quantidade > 0),
    preco_unitario DECIMAL(10,2) NOT NULL CHECK (preco_unitario > 0),
    PRIMARY KEY (id_pedido, id_pizza),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_pizza)  REFERENCES pizza(id_pizza)
);
