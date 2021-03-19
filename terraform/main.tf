# https://medium.com/avmconsulting-blog/how-to-deploy-a-dockerised-node-js-application-on-aws-ecs-with-terraform-3e6bceb48785

provider "aws" {
  region = var.region
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