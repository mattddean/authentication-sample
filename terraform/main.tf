# https://medium.com/avmconsulting-blog/how-to-deploy-a-dockerised-node-js-application-on-aws-ecs-with-terraform-3e6bceb48785

provider "aws" {
  region = var.region
}

# Providing a reference to our default VPC
resource "aws_default_vpc" "default_vpc" {
}

# Providing a reference to our default subnets
resource "aws_default_subnet" "default_subnet_a" {
  availability_zone = "eu-west-2a"
}

resource "aws_default_subnet" "default_subnet_b" {
  availability_zone = "eu-west-2b"
}

resource "aws_default_subnet" "default_subnet_c" {
  availability_zone = "eu-west-2c"
}

# resource mongo {
# provisioner "local-exec" {
#     command = "echo ${aws_instance.web.private_ip} >> private_ips.txt"
#   }
# }

# container definitions
# "environmentFiles": [
#         {
#           "value": "arn:aws:s3:::s3_bucket_name/envfile_object_name.env",
#           "type": "s3"
#         }
#       ],