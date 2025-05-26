terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                      = var.aws_region
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_use_path_style           = true

  endpoints {
    iam        = "http://localhost:4566"
    kms        = "http://localhost:4566"
    logs       = "http://localhost:4566"
    cloudwatch = "http://localhost:4566"
  }
}

resource "aws_kms_key" "vendas_key" {
  description             = "KMS key para aplicação de vendas"
  deletion_window_in_days = 7

  tags = {
    Name = "vendas-kms-key"
  }
}

resource "aws_kms_alias" "vendas_key_alias" {
  name          = "alias/vendas-key"
  target_key_id = aws_kms_key.vendas_key.key_id
}

resource "aws_cloudwatch_log_group" "vendas_logs" {
  name              = "/aws/batch/vendas-job"
  retention_in_days = 14
  kms_key_id        = aws_kms_key.vendas_key.arn

  tags = {
    Name = "vendas-log-group"
  }
}

resource "aws_iam_role" "batch_execution_role" {
  name = "vendas-batch-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "batch_execution_policy" {
  name = "vendas-batch-execution-policy"
  role = aws_iam_role.batch_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "cloudwatch:PutMetricData",
          "kms:Decrypt",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "batch_service_role" {
  name = "vendas-batch-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "batch.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "batch_service_role_policy" {
  role       = aws_iam_role.batch_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}
