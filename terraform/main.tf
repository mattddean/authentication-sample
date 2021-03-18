# https://medium.com/avmconsulting-blog/how-to-deploy-a-dockerised-node-js-application-on-aws-ecs-with-terraform-3e6bceb48785

provider "aws" {
  region = "us-west-2"
}

resource "aws_ecs_cluster" "auth_sample_backend" {
  name = "auth-sample-backend"
}

resource "aws_ecs_task_definition" "auth_sample_backend_task" {
  family                   = "auth-sample-backend-task"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "auth-sample-backend-task",
      "image": "mattddean/auth_sample-backend",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = 512         # Specifying the memory our container requires
  cpu                      = 256         # Specifying the CPU our container requires
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_service" "auth_sample_backend" {
  name            = "auth-sample-backend"                                # Naming our first service
  cluster         = aws_ecs_cluster.auth_sample_backend.id               # Referencing our created Cluster
  task_definition = aws_ecs_task_definition.auth_sample_backend_task.arn # Referencing the task our service will spin up
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [aws_default_subnet.default_subnet_a.id, aws_default_subnet.default_subnet_b.id, aws_default_subnet.default_subnet_c.id]
    assign_public_ip = true # Providing our containers with public IPs
  }
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

resource mongo {
  
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