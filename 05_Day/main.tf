# Deploying web servers using ASG

provider "aws" {
  region = "us-east-2"
}

variable "http8080" {
  type = number
  description = "8080 port for web servers"
  default = "8080"
}

# 1.Launch Configuration/template
resource "aws_launch_configuration" "webserverlc" {
  image_id = "ami-0c55b159cbfafe1f0"
  security_groups = [ aws_security_group.sgwebservices.id ]
  instance_type = "t2.micro"
  key_name = "devops"
  user_data = <<-EOF
            #!/bin/bash
            echo "Sri Swami Samarath" > index.html
            nohup busybox httpd -f -p ${var.http8080} &
            EOF
    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_security_group" "sgwebservices" {
  name = "allow 8080"

  ingress {
      to_port = var.http8080
      from_port = var.http8080
      protocol = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ]
  }
    ingress {
      to_port = 22
      from_port = 22
      protocol = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ]
  }
}

# 2. auto scaling group
data "aws_vpc" "defaultvpc" {
  default = true
}

data "aws_subnet_ids" "defaultvpcsb" {
    vpc_id = data.aws_vpc.defaultvpc.id  
}

# it is about where and when
resource "aws_autoscaling_group" "asgwebservices" {
  name = "ASG-WebSVC"
  launch_configuration = aws_launch_configuration.webserverlc.name 
  vpc_zone_identifier = data.aws_subnet_ids.defaultvpcsb.ids #where
  target_group_arns = [aws_lb_target_group.tglb-websvc.arn] # ^ adding target groups from LB here.
  health_check_type = "ELB" # This is important and is offered as part of ASG
  min_size = 2
  health_check_grace_period = 300 # 5 minutes before it starts
  max_size = 10
  tag {
    key = "Name"
    value = "Terraform-asg-example"
    propagate_at_launch = true # this will ensure all EC have same name
  }
}

# 3. create load balancer

resource "aws_lb" "lb4webservices" {
  name = "LB-Webservices"
  load_balancer_type = "application"
  subnets = data.aws_subnet_ids.defaultvpcsb.ids
  security_groups = [aws_security_group.sglb.id]
}

# 4. create security group for load balancer

resource "aws_security_group" "sglb" {
  name = "SG for Load Balancer"
  ingress {
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "tcp"
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = -1
      cidr_blocks = ["0.0.0.0/0"]
  }
}


# 5. load balancer lister

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.lb4webservices.arn
  port = 80
  protocol = "HTTP"
  default_action {
      type = "fixed-response" 
          fixed_response {
              content_type = "text/plain"
              message_body = "Something went wrong. Try again"
              status_code = 404
      } 
  }
}

# 6. create target group for load balancer
resource "aws_lb_target_group" "tglb-websvc" {
    name = "TGS-Webservices"
    port = var.http8080
    protocol = "HTTP"
    vpc_id = data.aws_vpc.defaultvpc.id

  # you need a health check for target group
  health_check {
    enabled = true
    healthy_threshold = 5
    unhealthy_threshold = 2
    interval = 30 # in seconds
    path = "/"
    protocol = "HTTP"
    timeout = 5 # in seconds
    matcher = "200" # success code
  }
}

#  Listener rules
resource "aws_lb_listener_rule" "lblisterrules" {
  listener_arn = aws_lb_listener.http.arn
  priority = 100
  condition {

  }
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tglb-websvc.arn
  }

  condition {
    path_pattern { 
      values = ["*"]
    }
  }
}
# OUTPUT Section
output "instoutpts" {
  description = "all outputs will be defined in this block"
  value = aws_lb.lb4webservices.dns_name
}