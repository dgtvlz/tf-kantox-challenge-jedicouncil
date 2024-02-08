module "kms_key" {
  source                  = "cloudposse/kms-key/aws"
  version                 = "v0.12.1"
  namespace               = var.env.name
  stage                   = var.env.environment
  name                    = var.env.project
  description             = var.kms_config.description
  deletion_window_in_days = var.kms_config.deletion_window_in_days
  enable_key_rotation     = var.kms_config.enable_key_rotation
  alias                   = "alias/${var.env.project}"
}