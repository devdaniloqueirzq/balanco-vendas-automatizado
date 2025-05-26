import os
import json
import logging
from datetime import datetime
from decimal import Decimal

class ReportGenerator:
    def gerar_relatorio_completo(self, balanco, vendas_df, estoque_baixo_df, top_produtos_df):
        return {
            "balanco_mensal": balanco,
            "vendas_mes_atual": vendas_df.to_dict(orient="records"),
            "produtos_com_estoque_baixo": estoque_baixo_df.to_dict(orient="records"),
            "top_produtos_vendidos": top_produtos_df.to_dict(orient="records"),
        }

    def salvar_relatorio(self, relatorio):
        caminho = "/tmp/relatorio_vendas.json"
        with open(caminho, "w", encoding="utf-8") as f:
            json.dump(
                relatorio,
                f,
                indent=2,
                ensure_ascii=False,
                default=self._json_serial
            )
        return caminho

    def imprimir_relatorio_console(self, relatorio):
        print("\n📊 RELATÓRIO DE VENDAS")
        print(json.dumps(
            relatorio,
            indent=2,
            ensure_ascii=False,
            default=self._json_serial
        ))

    def enviar_metricas_cloudwatch(self, balanco):
        # Simulação: Apenas printa no log. No real enviaria para CloudWatch
        print(f"📈 Enviando métrica: lucro = {balanco.get('lucro', 0)}")

    def _json_serial(self, obj):
        if isinstance(obj, Decimal):
            return float(obj)
        if isinstance(obj, (datetime, )):
            return obj.isoformat()
        return str(obj)

