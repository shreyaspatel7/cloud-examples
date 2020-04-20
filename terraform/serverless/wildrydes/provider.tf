terraform {
  backend "s3" {
    bucket = "terarform-state"
    key    = "states/"
    region = "us-east-1"
  }
}

provider "aws" {
  profile    = "default"
  region     = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
}
