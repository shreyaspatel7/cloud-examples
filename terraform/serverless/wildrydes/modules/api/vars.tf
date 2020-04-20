variable "env" {
  type        = string
  description = "Which environment (PRD/STG/UAT/etc.) these resources are for"
}

variable "partner" {
  type        = string
  default     = "shd"
  description = "Which client these resources are for"
}

variable "app" {
  type    = string
  default = "platform"
}

variable "function_name" {
  type    = string
}

variable "invoke_arn" {
  type    = string
}


variable "arn" {
  type    = string
}

