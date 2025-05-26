FROM python:3.9-slim

WORKDIR /app

# Instalar dependências sistema
RUN apt-get update && apt-get install -y \
    gcc \
    pkg-config \
    default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

# Copiar requirements
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar código da aplicação
COPY scripts/ ./scripts/
COPY sql/ ./sql/

# Definir entrypoint
CMD ["python", "scripts/app.py"]

