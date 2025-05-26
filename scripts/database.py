import mysql.connector
import os
from datetime import datetime, timedelta
import pandas as pd
from typing import List, Dict, Tuple
import logging

class DatabaseManager:
    def __init__(self):
        self.config = {
            'host': os.getenv('MYSQL_HOST', 'localhost'),
            'port': int(os.getenv('MYSQL_PORT', 3306)),
            'database': os.getenv('MYSQL_DATABASE', 'vendas_db'),
            'user': os.getenv('MYSQL_USER', 'admin'),
            'password': os.getenv('MYSQL_PASSWORD', 'senha123'),
            'autocommit': True
        }
        self.connection = None
        
    def connect(self):
        """Estabelece conexão com MySQL"""
        try:
            self.connection = mysql.connector.connect(**self.config)
            logging.info("Conexão com MySQL estabelecida com sucesso")
            return True
        except mysql.connector.Error as e:
            logging.error(f"Erro ao conectar com MySQL: {e}")
            return False
    
    def disconnect(self):
        """Fecha conexão com MySQL"""
        if self.connection and self.connection.is_connected():
            self.connection.close()
            logging.info("Conexão com MySQL fechada")
    
    def get_vendas_mes_atual(self) -> pd.DataFrame:
        """Busca vendas do mês atual"""
        query = """
        SELECT 
            v.id,
            p.nome as produto,
            p.categoria,
            v.quantidade,
            v.valor_total,
            v.data_venda,
            v.vendedor
        FROM vendas v
        JOIN produtos p ON v.produto_id = p.id
        WHERE MONTH(v.data_venda) = MONTH(CURDATE())
        AND YEAR(v.data_venda) = YEAR(CURDATE())
        ORDER BY v.data_venda DESC
        """
        
        try:
            df = pd.read_sql(query, self.connection)
            logging.info(f"Encontradas {len(df)} vendas no mês atual")
            return df
        except Exception as e:
            logging.error(f"Erro ao buscar vendas do mês: {e}")
            return pd.DataFrame()
    
    def get_balanco_mensal(self) -> Dict:
        """Calcula balanço mensal"""
        query = """
        SELECT 
            COUNT(*) as total_vendas,
            SUM(quantidade) as total_itens_vendidos,
            SUM(valor_total) as receita_total,
            AVG(valor_total) as ticket_medio,
            COUNT(DISTINCT vendedor) as vendedores_ativos
        FROM vendas
        WHERE MONTH(data_venda) = MONTH(CURDATE())
        AND YEAR(data_venda) = YEAR(CURDATE())
        """
        
        try:
            cursor = self.connection.cursor(dictionary=True)
            cursor.execute(query)
            result = cursor.fetchone()
            cursor.close()
            
            return {
                'total_vendas': result['total_vendas'] or 0,
                'total_itens_vendidos': result['total_itens_vendidos'] or 0,
                'receita_total': float(result['receita_total'] or 0),
                'ticket_medio': float(result['ticket_medio'] or 0),
                'vendedores_ativos': result['vendedores_ativos'] or 0
            }
        except Exception as e:
            logging.error(f"Erro ao calcular balanço mensal: {e}")
            return {}
    
    def get_produtos_estoque_baixo(self) -> pd.DataFrame:
        """Busca produtos com estoque abaixo do mínimo"""
        query = """
        SELECT 
            id,
            nome,
            categoria,
            estoque_atual,
            estoque_minimo,
            (estoque_minimo - estoque_atual) as quantidade_necessaria,
            preco
        FROM produtos
        WHERE estoque_atual < estoque_minimo
        ORDER BY (estoque_minimo - estoque_atual) DESC
        """
        
        try:
            df = pd.read_sql(query, self.connection)
            logging.info(f"Encontrados {len(df)} produtos com estoque baixo")
            return df
        except Exception as e:
            logging.error(f"Erro ao buscar produtos com estoque baixo: {e}")
            return pd.DataFrame()
    
    def get_top_produtos_vendidos(self, limite: int = 10) -> pd.DataFrame:
        """Busca produtos mais vendidos no mês"""
        query = """
        SELECT 
            p.nome as produto,
            p.categoria,
            SUM(v.quantidade) as total_vendido,
            SUM(v.valor_total) as receita_produto,
            COUNT(v.id) as numero_vendas,
            AVG(v.valor_total/v.quantidade) as preco_medio
        FROM vendas v
        JOIN produtos p ON v.produto_id = p.id
        WHERE MONTH(v.data_venda) = MONTH(CURDATE())
        AND YEAR(v.data_venda) = YEAR(CURDATE())
        GROUP BY p.id, p.nome, p.categoria
        ORDER BY total_vendido DESC
        LIMIT %s
        """
        
        try:
            df = pd.read_sql(query, self.connection, params=[limite])
            logging.info(f"Top {len(df)} produtos mais vendidos carregados")
            return df
        except Exception as e:
            logging.error(f"Erro ao buscar top produtos: {e}")
            return pd.DataFrame()
