module "app_s3_bucket" {
  source = "./modules/bgra-web-app-s3"

  bucket_name             = local.s3_bucket_name
  elb_service_account_arn = data.aws_elb_service_account.root.arn
  common_tags             = local.common_tags
}

resource "aws_s3_object" "s3_website_objects" {
  for_each = local.s3_web_objects
  bucket   = module.app_s3_bucket.web_bucket.id
  key      = each.value
  source   = "${path.root}/${each.value}"

  tags = merge(local.common_tags, { Name = "${var.naming_prefix}-s3-web-object-${each.key}" })
}

