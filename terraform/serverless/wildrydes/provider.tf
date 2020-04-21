terraform {
  backend "s3" {
    bucket = "terarform-state"
    key    = "states/"
    region = "us-east-1"
  }
}

provider "aws" {
  profile    = "default"
  region     =  var.region
  shared_credentials_file = "~/.aws/credentials"
}
