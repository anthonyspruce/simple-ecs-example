resource "aws_ecs_task_definition" "nginx" {
  family                   = "nginx"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = "nginx"
      essential = true
      portMappings = [
        {
          containerPort = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "nginx" {
  name            = "nginx"
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.nginx.arn
  desired_count   = 1

  network_configuration {
    subnets = module.vpc.private_subnets
    security_groups = [
      aws_security_group.ecs.id
    ]
  }

  load_balancer {
    target_group_arn = module.alb.target_group_arns[0]
    container_name   = "nginx"
    container_port   = 80
  }

  capacity_provider_strategy {
    base              = 0
    capacity_provider = "FARGATE"
    weight            = 100
  }
}

resource "aws_security_group" "ecs" {
  name        = "${var.project_name}-ecs"
  description = "Security group for ECS Tasks"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "ecs_in_80" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = aws_security_group.ecs.id
}

resource "aws_security_group_rule" "ecs_egress" {
  type              = "egress"
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs.id
}