module "ecs_cluster" {
  source  = "infrablocks/ecs-cluster/aws"
  version = "3.4.0"

  region          = var.region
  vpc_id          = aws_vpc.default.id
  subnet_ids      = aws_subnet.default.*.id
  security_groups = [aws_security_group.default.id]

  component             = "backend"
  deployment_identifier = "production"

  cluster_name                         = var.name
  cluster_instance_ssh_public_key_path = "/.ssh/id_rsa.pub"
  cluster_instance_type                = "t2.small"

  cluster_minimum_size     = 1
  cluster_maximum_size     = 1
  cluster_desired_capacity = 1

  associate_public_ip_addresses = "yes"
}

module "ecs_service" {
  source  = "infrablocks/ecs-service/aws"
  version = "3.2.0"

  region = var.region
  vpc_id = aws_vpc.default.id

  component             = "backend"
  deployment_identifier = "production"

  service_name  = var.name
  # service_image = "mattddean/auth_sample-backend"
  service_port  = "3000"

  service_task_container_definitions = <<DEFINITION
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

  service_desired_count                      = 1
  service_deployment_maximum_percent         = 100
  service_deployment_minimum_healthy_percent = 50

  attach_to_load_balancer = "no"

  service_role                 = aws_iam_role.ecsInstanceRole.arn    # task role
  ecs_cluster_service_role_arn = aws_iam_role.ecsExecuteTaskRole.arn # manage service role

  ecs_cluster_id = module.ecs_cluster.cluster_id
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
