# Pull data
    # 1. VPC ID
    data "aws_vpc" "mainvpc" {
      cidr_block = "10.10.0.0/16"
    }
    # 2. Subnet ID
variable "publicsubnets" {
  type = list(string)
  description = "map of public subnets for LB"
  default = ["subnet-0e30ad58bfe61169c","subnet-0c89413bc617da67f"] # need to manually add but this can be improved
}


# 1. Target group
resource "aws_lb_target_group" "targetgroup" {
  name = "webservers80"
  port = 80
  protocol = "HTTP"
  vpc_id = data.aws_vpc.mainvpc.id
  health_check {
    interval = 30
    path = "/healthcheck.html"
    port = 80
    timeout = 5 # default
    healthy_threshold = 3 # default
    unhealthy_threshold = 3 # default

  }
}
# 2. Attach instance to the target group
resource "aws_lb_target_group_attachment" "attachment" {
  target_group_arn = aws_lb_target_group.targetgroup.arn
  target_id = "i-0c009ab8660778806"
  port = 80
}
# 3. load balancer
resource "aws_lb" "loadbalancer" {
  name = "frontend"
  load_balancer_type = "application"
  subnets = [ var.publicsubnets[0],var.publicsubnets[1] ]
  security_groups = [aws_security_group.loadbal.id]
}


# 3. security group for LB
resource "aws_security_group" "loadbal" {
  name = "Allow80"
  vpc_id = data.aws_vpc.mainvpc.id
  description = "Allow 80 from FE"
  ingress {
    from_port = 80
    to_port = 80
    cidr_blocks = [ "0.0.0.0/0" ]
    protocol = "tcp"
  }
}

# 4. listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.targetgroup.arn
  }
}

# 5. Listener rules
resource "aws_lb_listener_rule" "rule" {
  listener_arn = aws_lb_listener.listener.arn
  priority = 100
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.targetgroup.arn
  }
  condition {
    path_pattern {
      values = ["*"]
    }
  }
}