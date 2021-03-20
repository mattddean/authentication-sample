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

  node_type            = "cache.t2.micro"
  port                 = var.cache_port

  snapshot_retention_limit = 5
  snapshot_window          = "00:00-05:00"

  subnet_group_name          = aws_elasticache_subnet_group.default.name
  automatic_failover_enabled = false

  security_group_ids = [ aws_security_group.default.id ]

  number_cache_clusters = 1
}