# AWS Loadbalancer

data "aws_elb_service_account" "root" {}

resource "aws_lb" "nginx" {
  name                       = "${local.naming_prefix}-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.lb_sg.id]
  subnets                    = aws_subnet.public_subnets[*].id
  enable_deletion_protection = false
  depends_on                 = [aws_s3_bucket_policy.web_bucket]

  access_logs {
    bucket  = aws_s3_bucket.web_bucket.bucket
    prefix  = "alb-logs"
    enabled = true
  }

  tags = local.common_tags
}


# target group

resource "aws_lb_target_group" "nginx" {
  name     = "${local.naming_prefix}-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.app.id
}


# listener

resource "aws_lb_listener" "nginx" {
  load_balancer_arn = aws_lb.nginx.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn
  }

  tags = merge(local.common_tags, { Name = "${var.naming_prefix}-lb-listener" })
}


# target group attachments

resource "aws_lb_target_group_attachment" "nginx_lb_attachments" {
  count = var.nginx_instance_count

  target_group_arn = aws_lb_target_group.nginx.arn
  target_id        = aws_instance.nginx_instances[count.index].id
  port             = 80
}
