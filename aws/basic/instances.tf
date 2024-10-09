# Data sources

data "aws_ssm_parameter" "amzn2_linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Instances

resource "aws_instance" "nginx_instances" {
  count                  = var.nginx_instance_count
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnets[(count.index % var.vpc_public_subnet_count)].id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  user_data = templatefile("${path.module}/templates/startup_script.tpl", {
    s3_bucket_name = aws_s3_bucket.web_bucket.id
  })
  iam_instance_profile = aws_iam_instance_profile.nginx_profile.name
  depends_on           = [aws_iam_role_policy.allow_s3_all]

  tags = merge(local.common_tags, { Name = "${var.naming_prefix}-nginx-instance-${count.index}" })
}


resource "aws_iam_role" "allow_nginx_s3" {
  name               = "allow_nginx_s3"
  assume_role_policy = <<POLICY_END
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY_END
}

resource "aws_iam_instance_profile" "nginx_profile" {
  name = "${local.naming_prefix}-nginx_profile"
  role = aws_iam_role.allow_nginx_s3.name

  tags = local.common_tags
}


resource "aws_iam_role_policy" "allow_s3_all" {
  name   = "${local.naming_prefix}-allow_s3_all"
  role   = aws_iam_role.allow_nginx_s3.name
  policy = <<POLICY_END
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${local.s3_bucket_name}",
        "arn:aws:s3:::${local.s3_bucket_name}/*"
      ]
    }
  ]
}
POLICY_END
}

