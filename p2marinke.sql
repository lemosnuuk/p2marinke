DROP DATABASE P2;
CREATE DATABASE P2;
USE P2;

CREATE TABLE Mesa (
    id_mesa INT PRIMARY KEY,
    status VARCHAR(20) NOT NULL,
    cliente_nome VARCHAR(100)
);

CREATE TABLE Produto (
    id_produto INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    quantidade_estoque INT NOT NULL,
    estoque_minimo INT NOT NULL,
    marca VARCHAR(50) NOT NULL
);

CREATE TABLE Pedido (
    id_pedido INT PRIMARY KEY,
    id_mesa INT NOT NULL,
    id_cliente INT,
    data_hora DATETIME NOT NULL,
    FOREIGN KEY (id_mesa) REFERENCES Mesa(id_mesa)
);

CREATE TABLE Item_Pedido (
    id_item_pedido INT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto)
);

CREATE TABLE Pagamento (
    id_pagamento INT PRIMARY KEY,
    id_pedido INT NOT NULL,
    forma_pagamento VARCHAR(50) NOT NULL,
    valor_total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido)
);

INSERT INTO Mesa (id_mesa, status, cliente_nome) VALUES (1, 'Livre', NULL);
INSERT INTO Mesa (id_mesa, status, cliente_nome) VALUES (2, 'Ocupada', 'João Silva');
INSERT INTO Mesa (id_mesa, status, cliente_nome) VALUES (3, 'Sobremesa', 'Maria Souza');
INSERT INTO Mesa (id_mesa, status, cliente_nome) VALUES (4, 'Ocupada-Ociosa', 'Carlos Lima');
INSERT INTO Mesa (id_mesa, status, cliente_nome) VALUES (5, 'Livre', NULL);

INSERT INTO Produto (id_produto, nome, preco_unitario, quantidade_estoque, estoque_minimo, marca)
VALUES (1, 'Coca-Cola', 5.00, 100, 10, 'Coca-Cola Company');
INSERT INTO Produto (id_produto, nome, preco_unitario, quantidade_estoque, estoque_minimo, marca)
VALUES (2, 'Hambúrguer', 15.00, 50, 5, 'Burger House');
INSERT INTO Produto (id_produto, nome, preco_unitario, quantidade_estoque, estoque_minimo, marca)
VALUES (3, 'Batata Frita', 10.00, 30, 5, 'Snack Brand');
INSERT INTO Produto (id_produto, nome, preco_unitario, quantidade_estoque, estoque_minimo, marca)
VALUES (4, 'Pizza', 25.00, 20, 3, 'Italiano Ltda');
INSERT INTO Produto (id_produto, nome, preco_unitario, quantidade_estoque, estoque_minimo, marca)
VALUES (5, 'Sorvete', 8.00, 40, 10, 'Ice Cream Co.');

INSERT INTO Pedido (id_pedido, id_mesa, id_cliente, data_hora) VALUES (1, 2, 101, '2024-11-28 12:30:00');
INSERT INTO Pedido (id_pedido, id_mesa, id_cliente, data_hora) VALUES (2, 3, 102, '2024-11-28 13:00:00');
INSERT INTO Pedido (id_pedido, id_mesa, id_cliente, data_hora) VALUES (3, 4, 103, '2024-11-28 13:45:00');
INSERT INTO Pedido (id_pedido, id_mesa, id_cliente, data_hora) VALUES (4, 5, NULL, '2024-11-28 14:15:00');
INSERT INTO Pedido (id_pedido, id_mesa, id_cliente, data_hora) VALUES (5, 2, 104, '2024-11-28 15:00:00');


INSERT INTO Item_Pedido (id_item_pedido, id_pedido, id_produto, quantidade) VALUES (1, 1, 1, 2);
INSERT INTO Item_Pedido (id_item_pedido, id_pedido, id_produto, quantidade) VALUES (2, 1, 3, 1);
INSERT INTO Item_Pedido (id_item_pedido, id_pedido, id_produto, quantidade) VALUES (3, 2, 4, 2);
INSERT INTO Item_Pedido (id_item_pedido, id_pedido, id_produto, quantidade) VALUES (4, 3, 2, 3);
INSERT INTO Item_Pedido (id_item_pedido, id_pedido, id_produto, quantidade) VALUES (5, 4, 5, 1);

INSERT INTO Pagamento (id_pagamento, id_pedido, forma_pagamento, valor_total) VALUES (1, 1, 'Cartão', 15.00);
INSERT INTO Pagamento (id_pagamento, id_pedido, forma_pagamento, valor_total) VALUES (2, 2, 'Dinheiro', 50.00);
INSERT INTO Pagamento (id_pagamento, id_pedido, forma_pagamento, valor_total) VALUES (3, 3, 'Cartão', 45.00);
INSERT INTO Pagamento (id_pagamento, id_pedido, forma_pagamento, valor_total) VALUES (4, 4, 'Pix', 8.00);
INSERT INTO Pagamento (id_pagamento, id_pedido, forma_pagamento, valor_total) VALUES (5, 5, 'Dinheiro', 30.00);


-- Exercício A
ALTER TABLE Pedido ADD nome_funcionario VARCHAR(100) NOT NULL;


UPDATE Pedido SET nome_funcionario = 'Estiven' WHERE id_pedido = 1;
UPDATE Pedido SET nome_funcionario = 'Livia' WHERE id_pedido = 2;
UPDATE Pedido SET nome_funcionario = 'Kaio' WHERE id_pedido = 3;
UPDATE Pedido SET nome_funcionario = 'Reinaldo' WHERE id_pedido = 4;
UPDATE Pedido SET nome_funcionario = 'Matheus Lemos Lindo' WHERE id_pedido = 5;

SELECT 
    ped.nome_funcionario AS Nome_Funcionario,
    m.id_mesa AS Mesa_Atendida,
    SUM(pag.valor_total) AS Valor_Total_Gasto
FROM 
    Mesa m
JOIN Pedido ped ON m.id_mesa = ped.id_mesa
JOIN Pagamento pag ON ped.id_pedido = pag.id_pedido
GROUP BY 
    ped.nome_funcionario, m.id_mesa
ORDER BY 
    ped.nome_funcionario, m.id_mesa;


-- Exercício B
SELECT 
    m.id_mesa AS Mesa,
    p.nome AS Produto,
    ip.quantidade AS Quantidade,
    pr.data_hora AS Data_Hora_Pedido
FROM 
    Mesa m
JOIN Pedido pr ON m.id_mesa = pr.id_mesa
JOIN Item_Pedido ip ON pr.id_pedido = ip.id_pedido
JOIN Produto p ON ip.id_produto = p.id_produto
WHERE 
    m.id_mesa = 2 -- Substituir pelo ID da Mesa
ORDER BY 
    pr.data_hora;


-- Exercício C
DELIMITER $$

CREATE PROCEDURE RedefinirStatusMesa (
    IN p_id_mesa INT
)
BEGIN
    SELECT 
        id_mesa AS Mesa,
        status AS Status_Atual
    FROM 
        Mesa
    WHERE 
        id_mesa = p_id_mesa;

    UPDATE Mesa
    SET 
        status = 'Livre'
    WHERE 
        id_mesa = p_id_mesa;

    SELECT CONCAT('O status da Mesa ', p_id_mesa, ' foi redefinido para Livre.') AS Mensagem;
END $$

DELIMITER ;

CALL RedefinirStatusMesa(2); -- Substituir pelo ID da Mesa

SELECT 
        id_mesa AS Mesa,
        status AS Status_Atual
    FROM 
        Mesa
    WHERE 
        id_mesa = 2;
        
-- Beijo marinke <3



