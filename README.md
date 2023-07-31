# dio-ciencia-de-dados-com-python-primeiro-bd

[Queries de criação do banco de dados](./create.sql)

[Queries de inserção de dados dummy](./create.sql)

## Esquema do banco de dados
![Esquema do banco de dados](design/Esquema%20Banco%20de%20Dados.png)

## Queries

### VIEW de dados completo dos clientes
```sql
CREATE VIEW cliente_completo AS
SELECT
	c.id AS id,
	c.pessoa AS pessoa,
	c.endereco AS endereco,
	CASE
		WHEN c.pessoa = 'PF' THEN pf.nome
		WHEN c.pessoa = 'PJ' THEN pj.razao_social
	END AS nome,
	CASE
		WHEN c.pessoa = 'PF' THEN pf.cpf
		WHEN c.pessoa = 'PJ' THEN pj.cnpj
	END AS cadastro,
	CASE
		WHEN c.pessoa = 'PF' THEN pf.data_de_nascimento
		WHEN c.pessoa = 'PJ' THEN pj.data_de_abertura
	END AS nascimento
FROM cliente c
LEFT JOIN pessoa_fisica pf ON pf.id_cliente = c.id
LEFT JOIN pessoa_juridica pj ON pj.id_cliente = c.id;
```

### Pedidos por cliente
```sql
SELECT
	c.nome AS Nome,
	COUNT(*) AS "Quantidade de Pedidos"
FROM cliente_completo c
INNER JOIN pedido p ON p.id_cliente = c.id
GROUP BY c.cadastro, c.nome
ORDER BY `Quantidade de Pedidos` DESC;
```

| Nome                                            | Quantidade de Pedidos |
|-|-|
| Dr. Ofelia Harber I                             |                     5 |
| Eugenia Lehner                                  |                     5 |
| Lydia O'Conner                                  |                     5 |
| Jaleel Monahan                                  |                     5 |
| Sally Dietrich                                  |                     5 |
|...|...|

### Pedidos por produto
```sql
SELECT
	p.nome AS Produto,
	COUNT(*) AS "Quantidade de Pedidos"
FROM produto_pedido pp
INNER JOIN produto p ON p.id = pp.id_produto
GROUP BY pp.id_produto
ORDER BY `Quantidade de Pedidos` DESC;
```

| Produto                        | Quantidade de Pedidos |
|-|-|
| Asperiores at.                 |                     7 |
| Nisi voluptas nesciunt.        |                     6 |
| Error quasi ipsam.             |                     6 |
| Nostrum atque minima.          |                     5 |
|...|...|

### Fornecimento e estoque por produto
```sql
SELECT
	p.nome AS Nome,
	fp.`Quantidade de Fornecedores`,
	ep.`Quantidade de Estoques`,
	ep.`Quantidade em estoque`
FROM produto p
LEFT JOIN (
	SELECT
		id_produto,
		COUNT(*) AS "Quantidade de Fornecedores"
	FROM fornecedor_produto
	GROUP BY id_produto
) fp ON fp.id_produto = p.id
LEFT JOIN (
	SELECT
		id_produto,
		COUNT(*) AS "Quantidade de Estoques",
		SUM(quantidade) AS "Quantidade em estoque"
	FROM estoque_produto
	GROUP BY id_produto
) ep ON ep.id_produto = p.id
ORDER BY ep.`Quantidade em estoque` DESC
```

| Nome                           | Quantidade de Fornecedores | Quantidade de Estoques | Quantidade em estoque |
|-|-|-|-|
| Vitae est magnam.              |                          3 |                     10 |                   276 |
| Nihil ut ullam.                |                          2 |                      7 |                   235 |
| Et non nam.                    |                          3 |                      5 |                   198 |
| Neque ut.                      |                          1 |                      5 |                   185 |
| Consectetur eos.               |                          1 |                      7 |                   181 |
|...|...|...|...|


### Quantidade de Clientes PF

```sql
SELECT COUNT(*)
FROM cliente_completo
WHERE pessoa = 'PF'
```

### Produtos sem nenhuma venda

```sql
SELECT *
FROM produto
WHERE id NOT IN (SELECT id_produto FROM produto_pedido)
```

