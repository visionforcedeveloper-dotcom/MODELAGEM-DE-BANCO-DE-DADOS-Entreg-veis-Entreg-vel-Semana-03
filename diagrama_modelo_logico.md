# Diagrama do Modelo Lógico — Pizzaria

> Diagrama renderizado em [Mermaid](https://mermaid.js.org/). Visualize em qualquer editor Markdown compatível (GitHub, VS Code com extensão Mermaid, etc.)

## Modelo Lógico (Diagrama ER Relacional)

```mermaid
erDiagram
    CATEGORIA ||--o{ PIZZA : "classifica"
    CLIENTE ||--o{ PEDIDO : "faz"
    ENTREGADOR ||--o{ PEDIDO : "entrega"
    PIZZA ||--o{ ITEM_PEDIDO : "composta em"
    PEDIDO ||--o{ ITEM_PEDIDO : "contém"
    PIZZA ||--o{ PIZZA_INGREDIENTE : "possui"
    INGREDIENTE ||--o{ PIZZA_INGREDIENTE : "compõe"

    CATEGORIA {
        int id_categoria PK
        varchar nome "NOT NULL, UNIQUE"
        varchar descricao
    }

    CLIENTE {
        int id_cliente PK
        varchar nome "NOT NULL"
        varchar telefone "NOT NULL"
        varchar email "UNIQUE"
        varchar rua "NOT NULL"
        varchar numero "NOT NULL"
        varchar bairro "NOT NULL"
        varchar cidade "NOT NULL"
        varchar cep "NOT NULL"
    }

    ENTREGADOR {
        int id_entregador PK
        varchar nome "NOT NULL"
        varchar telefone "NOT NULL"
    }

    PIZZA {
        int id_pizza PK
        varchar nome "NOT NULL, UNIQUE"
        varchar descricao
        decimal preco "NOT NULL, CHECK > 0"
        varchar tamanho "NOT NULL, CHECK IN(...)"
        int id_categoria FK
    }

    INGREDIENTE {
        int id_ingrediente PK
        varchar nome "NOT NULL, UNIQUE"
        varchar unidade_medida "NOT NULL, CHECK IN(...)"
    }

    PIZZA_INGREDIENTE {
        int id_pizza PK "FK"
        int id_ingrediente PK "FK"
        decimal quantidade "NOT NULL, CHECK > 0"
    }

    PEDIDO {
        int id_pedido PK
        timestamp data_pedido "NOT NULL, DEFAULT now()"
        decimal valor_total "NOT NULL, CHECK >= 0"
        varchar status "NOT NULL, DEFAULT Pendente"
        int id_cliente FK
        int id_entregador FK "nullable"
    }

    ITEM_PEDIDO {
        int id_pedido PK "FK"
        int id_pizza PK "FK"
        int quantidade "NOT NULL, CHECK > 0"
        decimal preco_unitario "NOT NULL, CHECK > 0"
    }
```

## Cardinalidades

| Relacionamento | Card. | Descrição |
|---|---|---|
| Categoria → Pizza | 1 : N | Uma categoria classifica várias pizzas |
| Cliente → Pedido | 1 : N | Um cliente faz vários pedidos |
| Entregador → Pedido | 1 : N | Um entregador entrega vários pedidos |
| Pizza ↔ Ingrediente | N : M | Uma pizza tem vários ingredientes e vice-versa (via `pizza_ingrediente`) |
| Pedido ↔ Pizza | N : M | Um pedido contém várias pizzas e uma pizza aparece em vários pedidos (via `item_pedido`) |

## Mapeamento MER → Relacional

| Entidade/Relacionamento MER | Tabela Relacional | Tipo |
|---|---|---|
| Entidade Categoria | `categoria` | Tabela forte |
| Entidade Cliente | `cliente` | Tabela forte |
| Entidade Entregador | `entregador` | Tabela forte |
| Entidade Pizza | `pizza` | Tabela forte (FK → categoria) |
| Entidade Ingrediente | `ingrediente` | Tabela forte |
| Relacionamento Pizza-Ingrediente (N:M) | `pizza_ingrediente` | Tabela associativa |
| Entidade Pedido | `pedido` | Tabela forte (FK → cliente, entregador) |
| Relacionamento Pedido-Pizza (N:M) | `item_pedido` | Tabela associativa |
