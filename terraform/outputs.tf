# https://geekrodion.medium.com/amazon-documentdb-and-aws-lambda-with-terraform-34a5d1061c15

output "aws_instance_public_dns" {
  value = aws_instance.service.public_dns
}

output "docdb_endpoint" {
  value = aws_docdb_cluster.service.endpoint
}

output "docdb_username" {
  value = aws_docdb_cluster.service.master_username
}

output "name" {
  value = var.name
}