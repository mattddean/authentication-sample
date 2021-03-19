# https://geekrodion.medium.com/amazon-documentdb-and-aws-lambda-with-terraform-34a5d1061c15

variable "stage" {
  default = "production"
}

variable "region" {
  default = "us-west-2"
}

variable "name" {
  default = "auth-sample"
}

variable "docdb_initdb_db_name" {
  default = "auth"
}

variable "docdb_username" {
  default = "auth"
}

variable "docdb_instance_class" {
  default = "db.t3.medium"
}

variable "docdb_password" {
  sensitive = true
}

variable "cache_port" {
  default = 6379
}

# https://github.com/hashicorp/terraform-elasticache-example/blob/master/variables.tf
variable "vpc_cidr_block" {
  description = "The top-level CIDR block for the VPC."
  default     = "10.1.0.0/16"
}
variable "cidr_blocks" {
  description = "The CIDR blocks to create the workstations in."
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}