module "ecs_cluster" {
  source = "infrablocks/ecs-cluster/aws"
  version = "3.4.0"

  region = var.region
  vpc_id = aws_vpc.default.id
  subnet_ids = aws_subnet.default.*.id
  security_groups = [aws_security_group.default.id]

  component = "backend"
  deployment_identifier = "production"

  cluster_name = var.name
  cluster_instance_ssh_public_key_path = "~/.ssh/id_rsa.pub"
  cluster_instance_type = "t2.small"

  cluster_minimum_size = 1
  cluster_maximum_size = 1
  cluster_desired_capacity = 1
}
