module "ecs_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name = "${var.ecs_security_group_name}"
  description = "Security Group for ECS Instance"
  vpc_id = module.vpc.vpc_id
  ingress_with_cidr_blocks = [
       { from_port = 22
        to_port = 22
        protocol = "tcp"
        description = "Allow access to ECS EC2 Instances via SSH"
        cidr_blocks = "${var.ecs_ingress_ssh_ip}"
       },
       {
         from_port = 80
         to_port = 80
         protocol = "tcp"
         cidr_blocks = "${var.ecs_ingress_ssh_ip}"  
       }
    ]
  egress_with_cidr_blocks = [
    { from_port = 80
     to_port = 80
     protocol = "tcp"
     description = "Allow Outbound HTTP Access"
     cidr_blocks = "0.0.0.0/0"
     },
     {
       from_port = 443
       to_port = 443
       protocol = "tcp"
       description = "Allow Outbound HTTPS Access"
       cidr_blocks = "0.0.0.0/0"
     }     
  ]  
}