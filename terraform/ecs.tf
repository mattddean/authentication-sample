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
        { "name": "NODE_ENV", "value": "${var.stage}" },
        { "name": "MONGO_USERNAME", "value": "${var.docdb_username}" },
        { "name": "MONGO_PASSWORD", "value": "${aws_docdb_cluster.service.master_password}" },
        { "name": "MONGO_HOST", "value": "${aws_docdb_cluster.service.endpoint}" },
        { "name": "MONGO_PORT", "value": "${aws_docdb_cluster.service.port}" },
        { "name": "MONGO_DATABASE", "value": "${var.docdb_initdb_db_name}" },
        { "name": "REDIS_PORT", "value": "${var.cache_port}" },
        { "name": "REDIS_HOST", "value": "${aws_elasticache_replication_group.default.primary_endpoint_address}" }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${var.name}",
          "awslogs-region": "${var.region}",
          "awslogs-stream-prefix": "backend",
          "awslogs-create-group": "true"
        }
      },
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = 512         # Specifying the memory our container requires
  cpu                      = 256         # Specifying the CPU our container requires
  execution_role_arn       = aws_iam_role.ecsExecuteTaskRole.arn
  task_role_arn            = aws_iam_role.ecsInstanceRole.arn
}

resource "aws_iam_role" "ecsExecuteTaskRole" {
  name               = "ecsExecuteTaskRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role" "ecsInstanceRole" {
  name               = "ecsInstanceRole"
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

data "aws_iam_policy_document" "createLogGroupPolicyDocument" {
  statement {
    sid = "1"
    actions = [
      "logs:CreateLogGroup"
    ]
    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "createLogGroupPolicy" {
  name        = "createLogGroup"
  path        = "/service-role/"
  description = "Enable logs CreateLogGroup on all resources"
  policy      = data.aws_iam_policy_document.createLogGroupPolicyDocument.json
}

resource "aws_iam_role_policy_attachment" "ecsExecuteTaskRole_policy" {
  role       = aws_iam_role.ecsExecuteTaskRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "createLogGroupPolicy_policy" {
  role       = aws_iam_role.ecsExecuteTaskRole.name
  policy_arn = aws_iam_policy.createLogGroupPolicy.arn
}

resource "aws_iam_role_policy_attachment" "ecsInstanceRole_policy" {
    role       = aws_iam_role.ecsInstanceRole.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
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