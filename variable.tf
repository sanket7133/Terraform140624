variable "vpc_cide" {
    default = "10.1.0.0/16"
}

variable "subnetA_cidr" {
    default = "10.1.0.0/24"
}
variable "subnetB_cidr" {
    default = "10.1.1.0/24"
}
variable "subnetC_cidr" {
    default = "10.1.2.0/24"
}

variable "availability_zone_a" {
  default = "ap-south-1a"
}  

variable "availability_zone_b" {
  default = "ap-south-1b"
}   

variable "availability_zone_c" {
  default = "ap-south-1c"
}   

variable "cidr_route" {
  default = "0.0.0.0/0"
}  

variable "AMI" {
    default = "ami-0f58b397bc5c1f2e8" 
}

variable "instance_type" {
  default = "t2.small"
}

variable "Container-Port" {
  default = "3000"
}

variable "host-Port" {
  default = "3000"
}

variable "image_name" {
  default = "ice-cream"
}

variable "cluster_name" {
  default = "ice-cream_cluster"
}

variable "ecs_family" {
  default = "ice-cream_fam"
}

variable "ALB" {
  default = "ice-cream_alb"
}

variable "Target_grp" {
  default = "ice-cream_TG"
}

variable "ecs_services" {
  default = "ice-cream_service"
}