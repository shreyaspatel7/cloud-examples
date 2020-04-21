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


variable "pool_id" {
  type    = string
}

variable "pool_client_id" {
  type    = string
}

variable "invoke_url" {
  type = string
}
