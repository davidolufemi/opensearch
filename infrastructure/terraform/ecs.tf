module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "6.0.1"

  cluster_name = "ecs-dev-cluster"

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/aws-ecs"
      }
    }
  }

  default_capacity_provider_strategy = {
    FARGATE = {
      weight = 50
      base   = 20
    }
    FARGATE_SPOT = {
      weight = 50
    }
  }

  services = {
    ecsdemo-frontend = {
      cpu           = 1024
      memory        = 4096
      launch_type   = "FARGATE"
      desired_count = 1

      container_definitions = {
        ecs-app = {
          cpu       = 512
          memory    = 1024
          essential = true
          image     = "davidayo97/opensearch:6183b54253668a77011882feb380a0657fe12e04"
          name      = "ecs-app"

          portMappings = [{
            name          = "web"
            containerPort = 80
            protocol      = "tcp"
          }]

          readonlyRootFilesystem = false

          enable_cloudwatch_logging = true
          logConfiguration = {
            logDriver = "awslogs"
            options = {
              awslogs-group         = "/ecs/ecsdemo-frontend"
              awslogs-region        = "us-east-1" # <-- change if your region differs
              awslogs-stream-prefix = "ecs"
            }
          }
          memoryReservation = 100
        }
      }

      # Remove Service Connect entirely
      # (no service_connect_configuration here)

      # ALB attachment: make sure the TG listens on port 3000
      load_balancer = {
        service = {
          target_group_arn = module.alb.target_groups["ex-instance"].arn
          container_name   = "ecs-app"  # must match container name above
          container_port   = 80       # must match containerPort above & TG port
        }
      }

      # Put tasks in PRIVATE subnets (recommended)
      subnet_ids = module.vpc.public_subnets

      security_group_ingress_rules = {
        alb_3000 = {
          description                  = "Allow ALB service on 80"
          from_port                    = 80
          to_port                      = 80
          ip_protocol                  = "tcp"
          referenced_security_group_id = module.alb.security_group_id
        }
      }
      security_group_egress_rules = {
        all = {
          ip_protocol = "-1"
          cidr_ipv4   = "0.0.0.0/0"
        }
      }
    }
  }

  tags = {
    Environment = "Development"
    Project     = "Example"
  }
}