# Data sources

data "aws_ssm_parameter" "amzn2_linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Instances

resource "aws_instance" "nginx_instances" {
  count                  = var.nginx_instance_count
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type          = "t2.micro"
  subnet_id              = module.app.public_subnets[(count.index % length(module.app.public_subnets))] // aws_subnet.public_subnets[(count.index % var.vpc_public_subnet_count)].id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  user_data = templatefile("${path.module}/templates/startup_script.tpl", {
    s3_bucket_name = module.app_s3_bucket.web_bucket.id
  })
  iam_instance_profile = module.app_s3_bucket.instance_profile.name
  depends_on           = [module.app_s3_bucket]

  tags = merge(local.common_tags, { Name = "${var.naming_prefix}-nginx-instance-${count.index}" })
}


