#!/bin/bash

set -e

echo "🚀 Configurando Sistema de Vendas Automatizado"
echo "=============================================="

# Função para verificar se comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Verificar pré-requisitos
echo "📋 Verificando pré-requisitos..."

if ! command_exists docker; then
    echo "❌ Docker não encontrado. Instalando..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    echo "✅ Docker instalado. Reinicie o terminal."
fi

if ! command_exists docker-compose; then
    echo "❌ Docker Compose não encontrado. Instalando..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "✅ Docker Compose instalado."
fi

if ! command_exists aws; then
    echo "❌ AWS CLI não encontrado. Instalando..."
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm -rf aws awscliv2.zip
    echo "✅ AWS CLI instalado."
fi

if ! command_exists terraform; then
    echo "❌ Terraform não encontrado. Instalando..."
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install terraform
    echo "✅ Terraform instalado."
fi

# Instalar LocalStack
echo "📦 Instalando LocalStack..."
pip3 install localstack awscli-local

# Criar arquivo .env
echo "📝 Configurando variáveis de ambiente..."
if [ ! -f .env ]; then
    cp .env.example .env
    echo "✅ Arquivo .env criado. Edite se necessário."
fi

# Configurar Git (se não estiver em um repositório)
if [ ! -d .git ]; then
    echo "🔧 Inicializando repositório Git..."
    git init
    git add .
    git commit -m "Initial commit - Sistema de Vendas Automatizado"
    echo "✅ Repositório Git inicializado."
fi

echo ""
echo "✅ Configuração concluída!"
echo ""
echo "📋 Próximos passos:"
echo "1. Edite o arquivo .env se necessário"
echo "2. Execute: ./run.sh para iniciar o sistema"
echo "3. Para GitHub Actions, faça push para um repositório GitHub"
echo ""