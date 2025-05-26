#!/usr/bin/env python3
import os
import sys
import logging
from datetime import datetime
from dotenv import load_dotenv

# Adicionar path para importar módulos locais
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from database import DatabaseManager
from reports import ReportGenerator

# Configurar logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(sys.stdout),
        logging.FileHandler('/tmp/vendas_app.log')
    ]
)

logger = logging.getLogger(__name__)

def main():
    """Função principal da aplicação"""
    logger.info("Iniciando processamento de relatório de vendas")
    
    # Carregar variáveis de ambiente
    load_dotenv()
    
    # Inicializar componentes
    db_manager = DatabaseManager()
    report_generator = ReportGenerator()
    
    try:
        # Conectar ao banco
        if not db_manager.connect():
            logger.error("Falha ao conectar com o banco de dados")
            return 1
        
        logger.info("Iniciando coleta de dados...")
        
        # Coletar dados
        balanco = db_manager.get_balanco_mensal()
        vendas_df = db_manager.get_vendas_mes_atual()
        estoque_baixo_df = db_manager.get_produtos_estoque_baixo()
        top_produtos_df = db_manager.get_top_produtos_vendidos()
        
        logger.info("Dados coletados com sucesso")
        
        # Gerar relatório
        relatorio = report_generator.gerar_relatorio_completo(
            balanco, vendas_df, estoque_baixo_df, top_produtos_df
        )
        
        # Salvar relatório
        caminho_relatorio = report_generator.salvar_relatorio(relatorio)
        
        # Imprimir no console
        report_generator.imprimir_relatorio_console(relatorio)
        
        # Enviar métricas para CloudWatch
        report_generator.enviar_metricas_cloudwatch(balanco)
        
        logger.info(f"Processamento concluído com sucesso. Relatório salvo em: {caminho_relatorio}")
        
        return 0
        
    except Exception as e:
        logger.error(f"Erro durante processamento: {e}")
        return 1
        
    finally:
        # Fechar conexão
        db_manager.disconnect()

if __name__ == "__main__":
    exit_code = main()
    sys.exit(exit_code)
