

output "kms_key_id" {
  description = "ID da chave KMS"
  value       = aws_kms_key.vendas_key.id
}

output "cloudwatch_log_group" {
  description = "Nome do grupo de logs"
  value       = aws_cloudwatch_log_group.vendas_logs.name
}
