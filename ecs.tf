data "template_file" "user_data" {
  template = file("${path.module}/user-data.sh")

  vars = {
    cluster_name = var.cluster_name
    enable_task_role = var.task_role_enable
  }
}

data "aws_ami" "amazon_linux_ecs" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}
resource "aws_iam_instance_profile" "ecs_ec2_profile" {
  name = "infra-ecs-ec2-profile"
  role = "AmazonEC2ContainerServiceforEC2Role"
}
module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  
  name = var.ec2_resources_name

  # Launch configuration
  lc_name   = var.ec2_resources_name
  use_lc    = true
  create_lc = true

  image_id                 = data.aws_ami.amazon_linux_ecs.id
  instance_type            = "${var.asg_ec2_instance_type}"
  security_groups          = [module.ecs_sg.security_group_id]
  service_linked_role_arn  = data.aws_iam_role.asg_role.arn
  iam_instance_profile_arn = aws_iam_instance_profile.ecs_ec2_profile.arn
  iam_instance_profile_name = aws_iam_instance_profile.ecs_ec2_profile.name
  associate_public_ip_address = true
  user_data                = data.template_file.user_data.rendered
  key_name                 = var.key_name 
  # Auto scaling group
  vpc_zone_identifier       = module.vpc.public_subnets
  health_check_type         = "EC2"
  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1 
  wait_for_capacity_timeout = 0

  tags = [
    {
      key                 = "Environment"
      value               = "${var.environment}"
      propagate_at_launch = true
    },
    {
      key                 = "Cluster"
      value               = "${var.cluster_name}"
      propagate_at_launch = true
    },
  ]
}

resource "aws_ecs_capacity_provider" "infra_ecs_capacity_provider" {
  name = "infra-ecs-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = module.asg.autoscaling_group_arn
  }
}
module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  name               = var.cluster_name
  container_insights = true

  capacity_providers = ["FARGATE", "FARGATE_SPOT", aws_ecs_capacity_provider.infra_ecs_capacity_provider.name]

  default_capacity_provider_strategy = [{
    capacity_provider = aws_ecs_capacity_provider.infra_ecs_capacity_provider.name # "FARGATE_SPOT"
    weight            = "1"
  }]

  tags = {
    Environment = var.environment
  }
}  