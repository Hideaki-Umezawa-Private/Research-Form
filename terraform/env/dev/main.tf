locals {
  lambda_functions_map = {
    for name in var.lambda_functions :
    name => {
      function_name = "${var.environment}-${name}"
    }
  }
}

data "aws_route53_zone" "hosted_zone" {
  name         = local.hosted_zone_name
  private_zone = false
}

module "secrets" {
  source       = "../../modules/secrets"
  environment  = var.environment
  app_name = var.app_name
}

module "route53" {
  source                 = "../../modules/route53"
  project_domain_name    = local.project_domain_name
  hosted_zone_id         = data.aws_route53_zone.hosted_zone.id
  cloudfront_static_site = module.cloudfront.static_site
  api                    = module.apigateway.work_progress_api_domain
  acm_for_cloudfront     = module.acm.certificate_for_cloudfront
  acm_for_api_gateway    = module.acm.certificate_for_api_gateway
}

module "acm" {
  source                          = "../../modules/acm"
  project_domain_name             = local.project_domain_name
  hosted_zone_name                = data.aws_route53_zone.hosted_zone.name
  dns_verify_for_apigateway_fqdns = module.route53.dns_verify_for_apigateway_fqdns
  dns_verify_for_cloudfront_fqdns = module.route53.dns_verify_for_cloudfront_fqdns
}

module "waf" {
  source      = "../../modules/waf"
  environment = var.environment
}

module "cloudfront" {
  source               = "../../modules/cloudfront"
  app_name         = var.app_name
  project_domain_name  = local.project_domain_name
  environment          = var.environment
  acm_public_east      = module.acm.certificate_for_cloudfront
  waf_web_acl          = module.waf.web_acl_for_cloudfront
  s3_bucket_cdn_origin = module.s3.bucket_cdn_origin
}

module "s3" {
  source                                 = "../../modules/s3"
  app_name                           = var.app_name
  environment                            = var.environment
  cloudfront_static_site                 = module.cloudfront.static_site
  allowed_origins                        = var.s3_allowed_origins
  lambda_function_generate_thumbnail_arn = module.lambda.aws_lambda_function_generate_thumbnail.arn
}

module "apigateway" {
  source                     = "../../modules/apigateway"
  app_name               = var.app_name
  project_domain_name        = local.project_domain_name
  environment                = var.environment
  acm_public_northeast_arn   = module.acm.certificate_for_api_gateway_arn
  waf_web_acl                = module.waf.web_acl_for_apigateway
  certificate_for_apigateway = module.acm.certification_validation_for_apigateway
  lambda_functions           = local.lambda_functions_map
  cognito_user_pool_arn      = var.cognito_user_pool_arn
}

module "lambda" {
  source       = "../../modules/lambda"
  environment  = var.environment
  lambda_roles = module.iam.lambda_roles
  functions    = var.lambda_functions
}

module "dynamodb" {
  source       = "../../modules/dynamodb"
  app_name = var.app_name
  environment  = var.environment
}

module "iam" {
  source              = "../../modules/iam"
  app_name        = var.app_name
  github_project_path = var.github_project_path
  environment         = var.environment
  secrets             = module.secrets.tasc_dev_secrets
  dynamodb_table_arn  = module.dynamodb.work_progress_table_arn
  s3_bucket_arn       = module.s3.bucket_media_arn
}
