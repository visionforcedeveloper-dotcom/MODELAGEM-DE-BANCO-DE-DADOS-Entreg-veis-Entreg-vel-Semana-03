# Modelagem Lógica de Banco de Dados - Pizzaria

Entregável da Semana 03 - Disciplina: Modelagem de Banco de Dados

Modelagem lógica de um cenário de pizzaria, partindo do modelo conceitual (MER) feito na Sprint anterior. O projeto aplica o mapeamento do MER para o modelo relacional e a normalização até a 3FN.

## Estrutura do Repositório

```
├── README.md                    # Documentação e justificativa da 3FN
├── diagrama_modelo_logico.md   # Diagrama do Modelo Lógico (Mermaid)
└── sql/
    ├── ddl.sql                  # Script DDL (CREATE TABLE)
    └── dml.sql                  # Script DML (INSERT + SELECT com JOIN)
```

## Tabelas do Modelo

| Tabela | Descrição | Chave Primária |
|---|---|---|
| `categoria` | Categorias de pizza (Tradicional, Especial, Doce) | `id_categoria` |
| `cliente` | Dados dos clientes | `id_cliente` |
| `entregador` | Dados dos entregadores | `id_entregador` |
| `pizza` | Cardápio de pizzas | `id_pizza` |
| `ingrediente` | Ingredientes disponíveis | `id_ingrediente` |
| `pizza_ingrediente` | Relação N:M entre pizza e ingrediente | `id_pizza`, `id_ingrediente` |
| `pedido` | Pedidos realizados | `id_pedido` |
| `item_pedido` | Itens de cada pedido (N:M entre pedido e pizza) | `id_pedido`, `id_pizza` |

O diagrama completo está em `diagrama_modelo_logico.md`.

## Normalização até a 3FN

### Antes da 1FN

Sem normalização, poderíamos ter uma única tabela `pedido` com tudo junto:

```
pedido(id, data, cliente_nome, cliente_telefone, cliente_endereco, pizzas, ingredientes, valor_total, entregador_nome, ...)
```

O problema é que `cliente_endereco` é composto (rua, número, bairro, cidade, CEP) e `pizzas`/`ingredientes` são grupos repetitivos, ou seja, várias pizzas e ingredientes amontoados em uma única célula.

### 1FN - Atributos atômicos e sem grupos repetitivos

Todo atributo precisa ser atômico e não pode haver grupos repetitivos.

1. O endereço do cliente foi decomposto em `rua`, `numero`, `bairro`, `cidade` e `cep`, cada um sendo um campo separado.

2. Os grupos repetitivos foram resolvidos com tabelas novas:
   - Em vez de listar as pizzas de um pedido como "Margherita, Calabresa" em uma coluna só, criou-se a tabela `item_pedido` (relação N:M entre `pedido` e `pizza`), com `quantidade` e `preco_unitario`.
   - Em vez de listar os ingredientes de uma pizza como "Molho, Queijo, Orégano" em uma coluna só, criou-se a tabela `pizza_ingrediente` (relação N:M entre `pizza` e `ingrediente`), com `quantidade`.

### 2FN - Eliminação de dependências parciais

Todo atributo não-chave deve depender da chave primária inteira, não só de parte dela. Vale para tabelas com chave composta.

1. Tabela `item_pedido` (PK composta: `id_pedido` + `id_pizza`):
   - Se o `nome` e o `preco` da pizza ficassem aqui, dependeriam só de `id_pizza` (dependência parcial).
   - `nome` e `preco` ficaram na tabela `pizza`. Em `item_pedido` o `preco_unitario` permanece porque representa o preço no momento do pedido e depende das duas partes da chave composta.

2. Tabela `pizza_ingrediente` (PK composta: `id_pizza` + `id_ingrediente`):
   - Se o `nome` e a `unidade_medida` do ingrediente ficassem aqui, dependeriam só de `id_ingrediente` (dependência parcial).
   - `nome` e `unidade_medida` ficaram na tabela `ingrediente`. Em `pizza_ingrediente` só permanece `quantidade`, que depende das duas partes da chave.

### 3FN - Eliminação de dependências transitivas

Nenhum atributo não-chave deve depender de outro atributo não-chave. Se A -> B e B -> C, então C não deve ficar na mesma tabela de A.

1. Dependência transitiva em `pizza` -> `categoria`:
   - Se `categoria_nome` e `categoria_descricao` ficassem na tabela `pizza`, teríamos: `id_pizza` -> `id_categoria` -> `categoria_nome`, `categoria_descricao`.
   - Criou-se a tabela `categoria` com `id_categoria` (PK), `nome` e `descricao`. A tabela `pizza` mantém só `id_categoria` como FK.

2. Dependência transitiva em `pedido` -> `cliente`:
   - Se `cliente_nome`, `cliente_telefone` e `cliente_email` ficassem na tabela `pedido`, teríamos: `id_pedido` -> `id_cliente` -> `cliente_nome`, `cliente_telefone`, etc.
   - Os dados do cliente ficaram na tabela `cliente`. A tabela `pedido` mantém só `id_cliente` como FK.

3. Dependência transitiva em `pedido` -> `entregador`:
   - Se `entregador_nome` e `entregador_telefone` ficassem na tabela `pedido`, teríamos: `id_pedido` -> `id_entregador` -> `entregador_nome`, `entregador_telefone`.
   - Os dados do entregador ficaram na tabela `entregador`. A tabela `pedido` mantém só `id_entregador` como FK (nullable, pois nem todo pedido é entrega).

## Tecnologias

- SGBD: PostgreSQL 12+
- Diagrama: Mermaid (em Markdown)
- Linguagem: SQL

## Como executar

1. Crie um banco de dados no PostgreSQL:
   ```sql
   CREATE DATABASE pizzaria;
   ```
2. Execute o script DDL:
   ```bash
   psql -d pizzaria -f sql/ddl.sql
   ```
3. Execute o script DML:
   ```bash
   psql -d pizzaria -f sql/dml.sql
   ```
