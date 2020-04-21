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
  type = string
}


variable "region" {
  type    = string
  default = "us-east-1"
  description="this variable will be used to perform multi regation deployment"

}

