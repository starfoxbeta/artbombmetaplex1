data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  
  name = var.vpc-name

  cidr = "10.1.0.0/16"

  azs             = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24"]
  public_subnets  = ["10.1.11.0/24", "10.1.12.0/24"]
  
  enable_dns_hostnames = true
  enable_dns_support = true
  enable_nat_gateway = false # false is just faster

  tags = {
    Environment = var.environment
    Name        = var.vpc-name
  }
}