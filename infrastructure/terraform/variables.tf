variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

variable "ecr_repository_name" {
  description = "Nome do repositório ECR"
  type        = string
  default     = "vendas-app"
}

variable "batch_job_queue_name" {
  description = "Nome da fila de jobs do Batch"
  type        = string
  default     = "vendas-job-queue"
}

variable "batch_job_definition_name" {
  description = "Nome da definição do job"
  type        = string
  default     = "vendas-job-def"
}

variable "mysql_host" {
  description = "Host do MySQL"
  type        = string
  default     = "host.docker.internal"
}

variable "mysql_port" {
  description = "Porta do MySQL"
  type        = number
  default     = 3306
}

variable "mysql_database" {
  description = "Nome do banco MySQL"
  type        = string
  default     = "vendas_db"
}

variable "mysql_user" {
  description = "Usuário MySQL"
  type        = string
  default     = "admin"
}

variable "mysql_password" {
  description = "Senha MySQL"
  type        = string
  default     = "senha123"
  sensitive   = true
}

variable "localstack_endpoint" {
  description = "Endpoint do LocalStack"
  type        = string
  default     = "http://host.docker.internal:4566"
}
