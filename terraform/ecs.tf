# https://medium.com/avmconsulting-blog/how-to-deploy-a-dockerised-node-js-application-on-aws-ecs-with-terraform-3e6bceb48785

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
      "environment": [
        {
          "MONGO_USERNAME": "${var.docdb_username}",
          "MONGO_PASSWORD": "${aws_docdb_cluster.service.master_password}",
          "MONGO_HOST": "${aws_docdb_cluster.service.endpoint}",
          "MONGO_PORT": "${aws_docdb_cluster.service.port}",
          "MONGO_DATABASE": "${var.docdb_initdb_db_name}",
          "REDIS_PORT": "${var.cache_port}",
          "REDIS_HOST": "${aws_elasticache_replication_group.default.primary_endpoint_address}"
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
  name            = "auth-sample-backend"
  cluster         = aws_ecs_cluster.auth_sample_backend.id
  task_definition = aws_ecs_task_definition.auth_sample_backend_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    # https://github.com/hashicorp/terraform-elasticache-example/blob/master/ssh.tf
    subnets         = [element(aws_subnet.default.*.id, 0)]
    security_groups = [aws_security_group.default.id]

    assign_public_ip = true
  }
}
