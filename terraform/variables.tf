variable "env" {
  description = "Map containing all the environment configuration"
  type        = map(string)
}

variable "dynamodb_config" {
  description = "Map containing all the DynamoDB configuration"
  type        = map(any)
  default     = {}
}

variable "lambda_get_config" {
  description = "Map containing all the Lambda Get configuration"
  type        = map(any)
  default     = {}
}

variable "lambda_update_config" {
  description = "Map containing all the Lambda Update configuration"
  type        = map(any)
  default     = {}
}

variable "kms_config" {
  description = "Map containing all the KMS configuration"
  type        = map(any)
  default     = {}
}