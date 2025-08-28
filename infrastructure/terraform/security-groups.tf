module "sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "dev-sg"
  description = "Security group for dev environment allowing HTTP and HTTPS"
  vpc_id      = module.vpc.vpc_id

  # Ingress rules: HTTP (80), HTTPS (443)
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  # Egress rules: allow all outbound traffic
  egress_rules = ["all-all"]
}
