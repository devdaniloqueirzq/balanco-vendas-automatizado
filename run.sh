#!/bin/bash

set -e

echo "🚀 Iniciando Sistema de Vendas"
echo "=============================="

# Carregar variáveis de ambiente
if [ -f .env ]; then
    set -a
    . .env
    set +a
fi

# Função para aguardar serviço
wait_for_service() {
    local service=$1
    local host=$2
    local port=$3
    local max_attempts=30
    local attempt=0

    echo "⏳ Aguardando $service ($host:$port)..."
    
    while [ $attempt -lt $max_attempts ]; do
        if nc -z $host $port 2>/dev/null; then
            echo "✅ $service está pronto!"
            return 0
        fi
        
        attempt=$((attempt + 1))
        echo "Tentativa $attempt/$max_attempts..."
        sleep 5
    done
    
    echo "❌ Timeout aguardando $service"
    return 1
}

# Parar containers existentes
echo "🧹 Limpando ambiente..."
docker-compose down -v 2>/dev/null || true

# Iniciar serviços
echo "🐳 Iniciando containers..."
docker-compose up -d

# Aguardar serviços
wait_for_service "LocalStack" "localhost" "4566"
wait_for_service "MySQL" "localhost" "3306"

# Verificar saúde do LocalStack
echo "⏳ Aguardando LocalStack estar completamente pronto..."
for i in {1..30}; do
    if curl -s http://localhost:4566/_localstack/health | grep -q '"iam": "available"'; then
        echo "✅ LocalStack pronto!"
        break
    fi
    echo "Tentativa $i/30..."
    sleep 5
done

# Inicializar banco de dados
echo "📊 Inicializando banco de dados..."
sleep 10
docker exec mysql-vendas mysql -u root -prootpassword -e "SHOW DATABASES;" 2>/dev/null || {
    echo "❌ Erro ao conectar com MySQL"
    exit 1
}

# Configurar AWS CLI local
echo "⚙️ Configurando AWS CLI para LocalStack..."
aws configure set aws_access_key_id test
aws configure set aws_secret_access_key test
aws configure set region us-east-1

# Aplicar infraestrutura básica (sem ECR/ECS/VPC)
echo "🏗️ Aplicando infraestrutura suportada..."
cd infrastructure/terraform
terraform init
terraform apply -auto-approve
cd ../..

# Build da imagem (simula ECR local)
echo "🐳 Buildando imagem do app localmente..."
docker build -t vendas-app:latest .

# Executar container como simulação de job batch
echo "⚡ Executando job de relatório localmente (simulação de Batch)..."
docker run --rm --network=host vendas-app:latest

# Executar diretamente também (caso queira debug em Python)
echo "🖥️ Executando versão local para demonstração (scripts/app.py)..."
cd scripts
python3 app.py
cd ..

echo ""
echo "🎉 Sistema executado com sucesso!"
echo ""
echo "📁 Arquivos gerados:"
echo "  - /tmp/relatorio_vendas.json (Relatório JSON)"
echo "  - /tmp/vendas_app.log (Logs da aplicação)"
echo ""
echo "📊 Para parar o sistema: docker-compose down"
