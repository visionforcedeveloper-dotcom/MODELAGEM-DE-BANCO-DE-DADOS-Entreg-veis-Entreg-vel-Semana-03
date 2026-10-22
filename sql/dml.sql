-- =====================================================================
--  PIZZARIA — SCRIPT DML (Data Manipulation Language)
--  SGBD: PostgreSQL 12+
--  Inserts (mínimo 3 por tabela) + Consultas SELECT com JOIN
-- =====================================================================

-- =====================================================================
--  INSERTS
-- =====================================================================

-- categoria (3 registros)
INSERT INTO categoria (nome, descricao) VALUES
('Tradicional', 'Pizzas tradicionais com sabores clássicos'),
('Especial',    'Pizzas com ingredientes premium e combinações especiais'),
('Doce',        'Pizzas doces para sobremesa');

-- cliente (3 registros)
INSERT INTO cliente (nome, telefone, email, rua, numero, bairro, cidade, cep) VALUES
('João Silva',     '(11) 98765-4321', 'joao.silva@email.com',     'Rua das Flores', '123',  'Centro',      'São Paulo', '01000-000'),
('Maria Santos',   '(11) 91234-5678', 'maria.santos@email.com',   'Av. Paulista',   '1000', 'Bela Vista',  'São Paulo', '01310-000'),
('Pedro Oliveira', '(11) 99876-5432', 'pedro.oliveira@email.com', 'Rua Augusta',    '500',  'Consolação', 'São Paulo', '01304-000');

-- entregador (3 registros)
INSERT INTO entregador (nome, telefone) VALUES
('Carlos Souza', '(11) 95555-1111'),
('Ana Costa',    '(11) 95555-2222'),
('Ricardo Lima', '(11) 95555-3333');

-- pizza (8 registros)
INSERT INTO pizza (nome, descricao, preco, tamanho, id_categoria) VALUES
('Margherita',         'Molho de tomate, mozzarella e manjericão',                    39.90, 'Grande',  1),
('Calabresa',           'Molho de tomate, calabresa, cebola e mozzarella',             45.90, 'Grande',  1),
('Portuguesa',          'Molho de tomate, presunto, ovos, cebola, ervilha e mozzarella', 49.90, 'Grande',  1),
('Quatro Queijos',      'Mozzarella, provolone, parmesão e gorgonzola',               52.90, 'Grande',  2),
('Frango com Catupiry', 'Frango desfiado e catupiry',                                  49.90, 'Grande',  2),
('Pizza da Casa',       'Presunto, champignon, bacon e mozzarella',                   54.90, 'Família', 2),
('Chocolate',           'Chocolate ao leite com granulado',                           35.90, 'Grande',  3),
('Banana com Canela',   'Banana, canela e leite condensado',                          32.90, 'Grande',  3);

-- ingrediente (19 registros)
INSERT INTO ingrediente (nome, unidade_medida) VALUES
('Molho de Tomate',  'L'),
('Mozzarella',       'kg'),
('Manjericão',       'g'),
('Calabresa',        'kg'),
('Cebola',           'kg'),
('Presunto',         'kg'),
('Ovo',              'unidade'),
('Ervilha',          'kg'),
('Provolone',        'kg'),
('Parmesão',         'kg'),
('Gorgonzola',       'kg'),
('Frango',           'kg'),
('Catupiry',         'kg'),
('Chocolate',        'kg'),
('Banana',           'kg'),
('Canela',           'g'),
('Leite Condensado', 'L'),
('Champignon',       'kg'),
('Bacon',            'kg');

-- pizza_ingrediente (29 registros)
INSERT INTO pizza_ingrediente (id_pizza, id_ingrediente, quantidade) VALUES
(1,  1, 0.20),  -- Margherita: Molho de Tomate
(1,  2, 0.30),  -- Margherita: Mozzarella
(1,  3, 10),    -- Margherita: Manjericão
(2,  1, 0.20),  -- Calabresa: Molho de Tomate
(2,  4, 0.25),  -- Calabresa: Calabresa
(2,  5, 0.15),  -- Calabresa: Cebola
(2,  2, 0.30),  -- Calabresa: Mozzarella
(3,  1, 0.20),  -- Portuguesa: Molho de Tomate
(3,  6, 0.20),  -- Portuguesa: Presunto
(3,  7, 4),     -- Portuguesa: Ovo
(3,  5, 0.15),  -- Portuguesa: Cebola
(3,  8, 0.10),  -- Portuguesa: Ervilha
(3,  2, 0.30),  -- Portuguesa: Mozzarella
(4,  2, 0.20),  -- Quatro Queijos: Mozzarella
(4,  9, 0.10),  -- Quatro Queijos: Provolone
(4, 10, 0.10),  -- Quatro Queijos: Parmesão
(4, 11, 0.10),  -- Quatro Queijos: Gorgonzola
(5, 12, 0.25),  -- Frango com Catupiry: Frango
(5, 13, 0.20),  -- Frango com Catupiry: Catupiry
(5,  2, 0.20),  -- Frango com Catupiry: Mozzarella
(6,  6, 0.20),  -- Pizza da Casa: Presunto
(6, 18, 0.15),  -- Pizza da Casa: Champignon
(6, 19, 0.15),  -- Pizza da Casa: Bacon
(6,  2, 0.30),  -- Pizza da Casa: Mozzarella
(7, 14, 0.30),  -- Chocolate: Chocolate
(8, 15, 0.30),  -- Banana com Canela: Banana
(8, 16, 10),    -- Banana com Canela: Canela
(8, 17, 0.15);  -- Banana com Canela: Leite Condensado

-- pedido (3 registros)
INSERT INTO pedido (data_pedido, valor_total, status, id_cliente, id_entregador) VALUES
('2026-10-20 19:30:00',  85.80, 'Entregue',    1, 1),
('2026-10-21 20:00:00',  52.90, 'Em Entrega',  2, 2),
('2026-10-22 21:00:00', 112.70, 'Pendente',    3, NULL);

-- item_pedido (5 registros)
INSERT INTO item_pedido (id_pedido, id_pizza, quantidade, preco_unitario) VALUES
(1, 1, 1, 39.90),  -- Pedido 1: 1x Margherita
(1, 2, 1, 45.90),  -- Pedido 1: 1x Calabresa
(2, 4, 1, 52.90),  -- Pedido 2: 1x Quatro Queijos
(3, 1, 2, 39.90),  -- Pedido 3: 2x Margherita
(3, 8, 1, 32.90);  -- Pedido 3: 1x Banana com Canela


-- =====================================================================
--  CONSULTAS SELECT COM JOIN
-- =====================================================================

-- ---------------------------------------------------------------------
--  Consulta 1: Lista todos os pedidos com dados do cliente e do entregador
--  JOINs: pedido + cliente (INNER) + entregador (LEFT, pois pode ser NULL)
-- ---------------------------------------------------------------------
SELECT
    p.id_pedido,
    p.data_pedido,
    p.valor_total,
    p.status,
    c.nome  AS cliente,
    c.telefone AS telefone_cliente,
    e.nome  AS entregador
FROM pedido p
INNER JOIN cliente   c ON p.id_cliente   = c.id_cliente
LEFT  JOIN entregador e ON p.id_entregador = e.id_entregador
ORDER BY p.data_pedido;

-- ---------------------------------------------------------------------
--  Consulta 2: Lista todas as pizzas com seus ingredientes e categorias
--  JOINs: pizza + categoria + pizza_ingrediente + ingrediente (4 tabelas)
-- ---------------------------------------------------------------------
SELECT
    pz.nome     AS pizza,
    cat.nome    AS categoria,
    pz.preco,
    pz.tamanho,
    i.nome      AS ingrediente,
    pi.quantidade,
    i.unidade_medida
FROM pizza pz
INNER JOIN categoria          cat ON pz.id_categoria = cat.id_categoria
INNER JOIN pizza_ingrediente  pi  ON pz.id_pizza      = pi.id_pizza
INNER JOIN ingrediente        i   ON pi.id_ingrediente = i.id_ingrediente
ORDER BY pz.nome, i.nome;

-- ---------------------------------------------------------------------
--  Consulta 3 (BÔNUS): Detalhamento completo de um pedido
--  JOINs: pedido + cliente + item_pedido + pizza + categoria (5 tabelas)
-- ---------------------------------------------------------------------
SELECT
    p.id_pedido,
    p.data_pedido,
    p.status,
    c.nome  AS cliente,
    pz.nome AS pizza,
    cat.nome AS categoria,
    ip.quantidade,
    ip.preco_unitario,
    (ip.quantidade * ip.preco_unitario) AS subtotal
FROM pedido p
INNER JOIN cliente    c   ON p.id_cliente = c.id_cliente
INNER JOIN item_pedido ip ON p.id_pedido   = ip.id_pedido
INNER JOIN pizza      pz  ON ip.id_pizza   = pz.id_pizza
INNER JOIN categoria  cat ON pz.id_categoria = cat.id_categoria
ORDER BY p.id_pedido, pz.nome;
