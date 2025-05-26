-- Inserir produtos de exemplo
INSERT INTO produtos (nome, categoria, preco, estoque_atual, estoque_minimo) VALUES
('Notebook Dell', 'Eletrônicos', 2500.00, 5, 10),
('Mouse Logitech', 'Acessórios', 89.90, 25, 15),
('Teclado Mecânico', 'Acessórios', 299.99, 8, 12),
('Monitor 24"', 'Eletrônicos', 899.00, 3, 8),
('Webcam HD', 'Eletrônicos', 199.90, 15, 10),
('Fone Bluetooth', 'Áudio', 159.99, 2, 15),
('Carregador USB-C', 'Acessórios', 49.90, 30, 20),
('SSD 1TB', 'Armazenamento', 399.00, 12, 10);

-- Inserir vendas dos últimos 3 meses
INSERT INTO vendas (produto_id, quantidade, valor_total, data_venda, vendedor) VALUES
-- Vendas de Janeiro 2025
(1, 2, 5000.00, '2025-05-25', 'Danilo Queiroz'),
(2, 5, 449.50, '2025-05-20', 'Lara Freitas'),
(3, 1, 299.99, '2025-05-25', 'Pedro Costa'),
-- Vendas de Fevereiro 2025
(1, 1, 2500.00, '2025-02-05', 'Ana Oliveira'),
(4, 2, 1798.00, '2025-02-10', 'Carlos Lima'),
(5, 3, 599.70, '2025-02-15', 'João Silva'),
-- Vendas de Março 2025
(2, 8, 719.20, '2025-03-01', 'Maria Santos'),
(6, 4, 639.96, '2025-03-05', 'Pedro Costa'),
(7, 10, 499.00, '2025-03-10', 'Ana Oliveira'),
-- Vendas recentes (Maio 2025)
(1, 1, 2500.00, '2025-05-01', 'Carlos Lima'),
(3, 2, 599.98, '2025-05-05', 'João Silva'),
(8, 3, 1197.00, '2025-05-10', 'Maria Santos'),
(4, 1, 899.00, '2025-05-15', 'Pedro Costa'),
(5, 2, 399.80, '2025-05-20', 'Ana Oliveira');
