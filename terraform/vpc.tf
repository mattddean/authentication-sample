# https://github.com/hashicorp/terraform-elasticache-example/blob/master/network.tf

# Create a VPC to launch our instances into
resource "aws_vpc" "default" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = var.name
  }
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = var.name
  }
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.default.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

# Grab the list of availability zones
data "aws_availability_zones" "available" {}

resource "aws_subnet" "default" {
  count                   = length(var.cidr_blocks)
  vpc_id                  = aws_vpc.default.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = var.cidr_blocks[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = var.name
  }
}