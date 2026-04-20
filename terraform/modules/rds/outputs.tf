output "db_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.nexabank.endpoint
}

output "db_name" {
  description = "Database name"
  value       = aws_db_instance.nexabank.db_name
}

output "db_port" {
  description = "Database port"
  value       = aws_db_instance.nexabank.port
}