variable "region" {
  default = "us-east-2"
}
variable "vpc-name" {
  default = "meta-prod-vpc"
}
variable "environment" {
  default = "Dev"
}
variable "cluster_name" {
  default = "meta-ecs-cluster"
}
variable "ec2_resources_name" {
  default = "meta-ecs-dev"  
}
variable "ec2_profile_name" {
  default = "meta-ecs-ec2-profile"
}
variable "asg_ec2_instance_type" {
  default = "t3.medium"
}
variable "task_role_enable" {
  default = "true"
}
variable "ecs_security_group_name" {
  default = "metaplex-sg"
}
variable "ecs_ingress_ssh_ip" {
  default = "74.132.175.52/32"
}
variable "key_name" {
  default = "development-ecs-emslynk"
}