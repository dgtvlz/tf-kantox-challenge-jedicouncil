module "kms_key" {
    source = "cloudposse/kms-key/aws"
    version = "v0.12.1"
    namespace  = var.env.name
    stage      = var.env.environment
    name       = var.env.project
    description = "KMS for encrypting Jedi's IDs"
    deletion_window_in_days = 10
    enable_key_rotation     = true
    alias                   = "alias/${var.env.project}"
}