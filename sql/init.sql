
CREATE TABLE IF NOT EXISTS produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    categoria VARCHAR(100),
    preco DECIMAL(10,2),
    estoque_atual INT DEFAULT 0,
    estoque_minimo INT DEFAULT 10,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS vendas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    produto_id INT,
    quantidade INT,
    valor_total DECIMAL(10,2),
    data_venda DATE,
    vendedor VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (produto_id) REFERENCES produtos(id)
);


CREATE INDEX idx_vendas_data ON vendas(data_venda);
CREATE INDEX idx_vendas_produto ON vendas(produto_id);
CREATE INDEX idx_produtos_estoque ON produtos(estoque_atual, estoque_minimo);
