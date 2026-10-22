# 🍕 Pizzaria — Modelagem Lógica de Banco de Dados

Entregável da Semana 03 — Disciplina: Modelagem de Banco de Dados

Este repositório contém a modelagem lógica de um cenário de **Pizzaria**, derivada do modelo conceitual (MER) desenvolvido na Sprint anterior. O projeto aplica as regras de mapeamento do MER para o modelo relacional e as técnicas de normalização até a **3ª Forma Normal (3FN)**.

---

## 📁 Estrutura do Repositório

```
pizzaria-db/
├── README.md                      # Documentação e justificativa da 3FN
├── diagrama_modelo_logico.md      # Diagrama do Modelo Lógico (Mermaid)
└── sql/
    ├── ddl.sql                    # Script DDL (CREATE TABLE)
    └── dml.sql                    # Script DML (INSERT + SELECT com JOIN)
```

---

## 📐 Diagrama do Modelo Lógico

O diagrama completo está em [`diagrama_modelo_logico.md`](diagrama_modelo_logico.md), renderizado em Mermaid.

### Visão geral das tabelas

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

---

## 🔄 Processo de Normalização até a 3FN

### Estado Não Normalizado (Antes da 1FN)

Em um modelo não normalizado, poderíamos ter uma única tabela `pedido` com todos os dados:

```
pedido(id, data, cliente_nome, cliente_telefone, cliente_endereco, pizzas, ingredientes, valor_total, entregador_nome, ...)
```

Problemas: `cliente_endereco` é um atributo composto (rua, número, bairro, cidade, CEP) e `pizzas`/`ingredientes` são grupos repetitivos (várias pizzas e ingredientes em uma única célula).

---

### 1ª Forma Normal (1FN) — Atributos atômicos e sem grupos repetitivos

**Regra:** Todo atributo deve ser atômico (indivisível) e não pode haver grupos repetitivos.

**Aplicação:**

1. **Endereço do cliente decomposto:** O atributo `cliente_endereco` foi dividido em `rua`, `numero`, `bairro`, `cidade` e `cep`, tornando cada campo atômico.

2. **Grupos repetitivos eliminados com novas tabelas:**
   - Em vez de listar as pizzas de um pedido como `"Margherita, Calabresa"` em uma coluna, criou-se a tabela `item_pedido` (relação N:M entre `pedido` e `pizza`), com `quantidade` e `preco_unitario`.
   - Em vez de listar os ingredientes de uma pizza como `"Molho, Queijo, Orégano"` em uma coluna, criou-se a tabela `pizza_ingrediente` (relação N:M entre `pizza` e `ingrediente`), com `quantidade`.

**Resultado:** Todas as tabelas possuem apenas atributos atômicos e nenhum grupo repetitivo.

---

### 2ª Forma Normal (2FN) — Eliminação de dependências parciais

**Regra:** Todo atributo não-chave deve depender da **totalidade** da chave primária (não apenas de parte dela). Aplicável a tabelas com chave composta.

**Aplicação:**

1. **Tabela `item_pedido`** (PK composta: `id_pedido` + `id_pizza`):
   - ❌ **Antes:** Se o `nome` e o `preco` da pizza estivessem nesta tabela, dependeriam apenas de `id_pizza` (dependência parcial).
   - ✅ **Depois:** `nome` e `preco` foram movidos para a tabela `pizza`. Em `item_pedido`, o `preco_unitario` é mantido pois representa o preço no momento do pedido (pode diferir do preço atual do cardápio) e depende de **ambas** as partes da chave composta.

2. **Tabela `pizza_ingrediente`** (PK composta: `id_pizza` + `id_ingrediente`):
   - ❌ **Antes:** Se o `nome` e a `unidade_medida` do ingrediente estivessem nesta tabela, dependeriam apenas de `id_ingrediente` (dependência parcial).
   - ✅ **Depois:** `nome` e `unidade_medida` foram movidos para a tabela `ingrediente`. Em `pizza_ingrediente`, apenas `quantidade` permanece, que depende de ambas as partes da chave composta (qual pizza + qual ingrediente).

**Resultado:** Nenhuma dependência parcial em tabelas com chave composta.

---

### 3ª Forma Normal (3FN) — Eliminação de dependências transitivas

**Regra:** Nenhum atributo não-chave deve depender de outro atributo não-chave. Ou seja, se A → B e B → C, então C não deve estar na mesma tabela de A (dependência transitiva: A → B → C).

**Aplicação:**

1. **Dependência transitiva em `pizza` → `categoria`:**
   - ❌ **Antes:** Se `categoria_nome` e `categoria_descricao` estivessem diretamente na tabela `pizza`, teríamos: `id_pizza` → `id_categoria` → `categoria_nome`, `categoria_descricao` (dependência transitiva).
   - ✅ **Depois:** Criou-se a tabela `categoria` com `id_categoria` (PK), `nome` e `descricao`. A tabela `pizza` mantém apenas `id_categoria` como chave estrangeira.

2. **Dependência transitiva em `pedido` → `cliente`:**
   - ❌ **Antes:** Se `cliente_nome`, `cliente_telefone` e `cliente_email` estivessem na tabela `pedido`, teríamos: `id_pedido` → `id_cliente` → `cliente_nome`, `cliente_telefone`, ... (dependência transitiva).
   - ✅ **Depois:** Todos os dados do cliente permanecem na tabela `cliente`. A tabela `pedido` mantém apenas `id_cliente` como FK.

3. **Dependência transitiva em `pedido` → `entregador`:**
   - ❌ **Antes:** Se `entregador_nome` e `entregador_telefone` estivessem na tabela `pedido`, teríamos: `id_pedido` → `id_entregador` → `entregador_nome`, `entregador_telefone` (dependência transitiva).
   - ✅ **Depois:** Os dados do entregador permanecem na tabela `entregador`. A tabela `pedido` mantém apenas `id_entregador` como FK (nullable, pois pedidos podem ser para retirada).

**Resultado:** Nenhuma dependência transitiva. O modelo está na 3FN.

---

## 🗃️ Tecnologias

- **SGBD:** PostgreSQL (compatível com PostgreSQL 12+)
- **Diagrama:** Mermaid (embutido em Markdown)
- **Linguagem:** SQL padrão

## ▶️ Como executar

1. Instale o PostgreSQL (ou use um serviço como Docker, Supabase, etc.)
2. Crie um banco de dados:
   ```sql
   CREATE DATABASE pizzaria;
   ```
3. Execute o script DDL:
   ```bash
   psql -d pizzaria -f sql/ddl.sql
   ```
4. Execute o script DML:
   ```bash
   psql -d pizzaria -f sql/dml.sql
   ```
5. Verifique as consultas SELECT no final do script DML.
