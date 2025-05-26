# 📊 Sistema Automatizado de Relatórios de Vendas

Sistema completo para geração automática de relatórios mensais de vendas e controle de estoque, utilizando infraestrutura em nuvem com **AWS Batch**, banco de dados **MySQL**, e execução local via **LocalStack**.

---

## 🚀 Funcionalidades

- ✅ Geração automatizada de relatórios em JSON  
- ✅ Identificação de produtos com estoque baixo  
- ✅ Execução de jobs com AWS Batch (Fargate)  
- ✅ Containerização com Docker & Docker Compose  
- ✅ Infraestrutura como código com Terraform  
- ✅ Logs e métricas via AWS CloudWatch  
- ✅ Criptografia com AWS KMS  
- ✅ CI/CD com GitHub Actions  
- ✅ Execução local simulada com LocalStack  

---

## 🛠️ Tecnologias Utilizadas

| Categoria      | Ferramentas |
|----------------|-------------|
| **Linguagem**  | Python 3.9 |
| **Banco**      | MySQL 8.0 |
| **Containers** | Docker, Docker Compose |
| **Cloud**      | AWS (Batch, ECS, ECR, IAM, KMS, CloudWatch) |
| **IaC**        | Terraform |
| **CI/CD**      | GitHub Actions |
| **Local Dev**  | LocalStack |

---

## 📂 Estrutura do Projeto
├── scripts/ # Código da aplicação (relatórios, banco)
├── sql/ # Scripts SQL do banco
├── infrastructure/ # Terraform (infraestrutura AWS)
├── docker/ # Dockerfile e configs
├── run.sh # Script de execução local
├── setup.sh # Script de setup inicial
└── docker-compose.yml # Orquestração dos containers


---

## ▶️ Como Executar Localmente

1. Clone o repositório:

```bash
git clone https://github.com/devdaniloqueirozq/balanco-vendas-automatizado.git
cd balanco-vendas-automatizado

Execute o setup inicial:
./setup.sh

Rode o sistema: 
./run.sh


✅ Exemplo de Saída{
  "balanco_mensal": {
    "total_vendas": 8,
    "receita_total": 11345.27
  },
  "produtos_com_estoque_baixo": [
    {
      "nome": "Notebook Dell",
      "estoque_atual": 5,
      "estoque_minimo": 10
    }
  ]
}

-------------------------------------------------- // ------------------------------------------------


| Erro                                           | Causa Provável             | Solução                                                     |
| ---------------------------------------------- | -------------------------- | ----------------------------------------------------------- |
| `Connection refused on port 4566`              | LocalStack ainda subindo   | Aguarde mais tempo ou aumente o timeout no script           |
| `ModuleNotFoundError: No module named 'mysql'` | Falta de dependência local | Use Docker ou instale com `pip install -r requirements.txt` |
| `Decimal is not JSON serializable`             | Valor Decimal no JSON      | Use `float()` para serializar corretamente                  |
| `Caracteres estranhos no JSON`                 | Acentos e codificação      | Use nomes de produtos sem acentos                           |
| `Authentication failed (GitHub)`               | Uso de senha no HTTPS      | Use token ou configure SSH                                  |





