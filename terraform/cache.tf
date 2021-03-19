# https://github.com/hashicorp/terraform-elasticache-example/blob/master/elasticache.tf

resource "aws_security_group" "default" {
  name_prefix = var.name
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elasticache_subnet_group" "default" {
  name       = "${var.name}-cache-subnet"
  subnet_ids = aws_subnet.default.*.id
}

resource "aws_elasticache_replication_group" "default" {
  replication_group_id          = "${var.name}-cluster"
  replication_group_description = "Redis cluster for Hashicorp ElastiCache example"

  node_type            = "cache.m4.large"
  port                 = 6379
  parameter_group_name = "default.redis3.2.cluster.on"

  snapshot_retention_limit = 5
  snapshot_window          = "00:00-05:00"

  subnet_group_name          = aws_elasticache_subnet_group.default.name
  automatic_failover_enabled = true

  number_cache_clusters = 1
}