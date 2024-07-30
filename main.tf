#lets setup a jenkins server first 

resource "aws_vpc" "vpc-1406" {
        cidr_block = var.vpc_cide
        tags = {
          Name= "VPC-EXAMPLE"
        }
}

resource "aws_subnet" "Subnet1" {
  vpc_id = aws_vpc.vpc-1406.id
  availability_zone = var.availability_zone_a
  cidr_block = var.subnetA_cidr
  tags = {
    "Name"= "Subnet-A"
  }
}

resource "aws_subnet" "Subnet2" {
  vpc_id = aws_vpc.vpc-1406.id
  availability_zone = var.availability_zone_b
  cidr_block = var.subnetB_cidr
  tags = {
    "Name"= "Subnet-b"
  }
}

resource "aws_subnet" "Subnet3" {
  vpc_id = aws_vpc.vpc-1406.id
  availability_zone = var.availability_zone_c
  cidr_block = var.subnetC_cidr
  tags = {
    "Name"= "Subnet-C"
  }
}

resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.vpc-1406.id
    tags = {
      "Name"= "IGW-1406"
    }
}

resource "aws_route_table" "RT_A" {
  vpc_id = aws_vpc.vpc-1406.id
  route {
    cidr_block= var.cidr_route
    gateway_id =aws_internet_gateway.IGW.id
  }
}

resource "aws_route_table_association" "assoA" {
  subnet_id = aws_subnet.Subnet1.id
  route_table_id = aws_route_table.RT_A.id
}

resource "aws_route_table_association" "assoB" {
  subnet_id = aws_subnet.Subnet2.id
  route_table_id = aws_route_table.RT_A.id
}

resource "aws_route_table_association" "assoC" {
  subnet_id = aws_subnet.Subnet3.id
  route_table_id = aws_route_table.RT_A.id
}

resource "aws_security_group" "SG" {
  name = "SG-1406"
  vpc_id = aws_vpc.vpc-1406.id

ingress {
    description = "Port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    description = "Outbound "
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "alb" {
  name   = "ALB-SG"
  vpc_id = aws_vpc.vpc-1406.id
 
  ingress {
   protocol         = "tcp"
   from_port        = 80
   to_port          = 80
   cidr_blocks      = ["0.0.0.0/0"]
  
  }
 
  ingress {
   protocol         = "tcp"
   from_port        = 443
   to_port          = 443
   cidr_blocks      = ["0.0.0.0/0"]
 
  }
 
  egress {
   protocol         = "-1"
   from_port        = 0
   to_port          = 0
   cidr_blocks      = ["0.0.0.0/0"]
   
  }
}

resource "aws_instance" "Jenkins" {
  ami = var.AMI
  instance_type = var.instance_type
  vpc_security_group_ids = [ aws_security_group.SG.id ]
  subnet_id = aws_subnet.Subnet1.id
  user_data = base64encode(file("config.sh"))
  associate_public_ip_address = true
}

resource "aws_ecr_repository" "ECR" {
  name = "ice-cream"
}

resource "aws_ecs_cluster" "ECS" {
  name = "Ice-cream"
}

resource "aws_ecs_task_definition" "Task_denfination" {
  network_mode = "awsvpc"
  family = "Ice-cream"

  container_definitions = jsonencode([
    {
   name        = "Ice-cream"
   image       = "Ice-cream:latest"
   essential   = true
    cpu       = 10
      memory    = 512
   portMappings = [{
     protocol      = "tcp"
     containerPort = 3000
     hostPort      = 3000
   }]
  } ]
   )
}

resource "aws_lb" "ALB" {
  name = "Ice-cream-alb"
  internal = false
  load_balancer_type = "application"
   subnets = [aws_subnet.Subnet1.id , aws_subnet.Subnet2.id , aws_subnet.Subnet3.id]
    security_groups = [aws_security_group.alb.id]
}


resource "aws_alb_target_group" "main" {
  name        = "Ice-cream-TG"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc-1406.id
  target_type = "ip"
 
  health_check {
   healthy_threshold   = "3"
   interval            = "30"
   protocol            = "HTTP"
   matcher             = "200"
   timeout             = "3"
   path                = "/"
   unhealthy_threshold = "2"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.ALB.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.main.arn
  }
}


resource "aws_ecs_service" "Service" {
  name = "Ice-cream-service"
  cluster         = aws_ecs_cluster.ECS.id
  task_definition = aws_ecs_task_definition.Task_denfination.arn
  desired_count   = 2

  network_configuration {
   subnets = [aws_subnet.Subnet1.id , aws_subnet.Subnet2.id , aws_subnet.Subnet3.id]
    security_groups = [aws_security_group.alb.id]
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.main.arn
   container_name   = "Ice-cream"
   container_port   = var.Container-Port
  }
  
}

