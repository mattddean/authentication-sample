# https://geekrodion.medium.com/amazon-documentdb-and-aws-lambda-with-terraform-34a5d1061c15

variable "region" {
  default = "us-west-2"
}

variable "name" {
  default = "auth-sample"
}

variable "docdb_initdb_db_name" {
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

