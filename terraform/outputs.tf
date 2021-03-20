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

# https://github.com/hashicorp/terraform-elasticache-example/blob/master/output.tf
output "cache_configuration_endpoint_address" {
  value = aws_elasticache_replication_group.default.configuration_endpoint_address
}

output "cache_primary_endpoint_address" {
  value = aws_elasticache_replication_group.default.primary_endpoint_address
}

# should exist but doesn't
# output "cache_reader_endpoint_address" {
#   value = aws_elasticache_replication_group.default.reader_endpoint_address
# }

output "mongo_shell_instance_ip" {
  value = aws_instance.service.public_ip
}