
data "aws_region" "current" {}

/* 
===================================+ THIS IS THE MOST IMPORTANT STEP +===================================
After all the resources have been provisioned, we would require some configuration 
to enable  communication between frontend application, API Gateway, and Cognito. We will aquire the metadat
related to the provisioned resources using Terrafrom output variable functionality.
  "Output values are like the return values of a Terraform module, and have several uses:
  1.  A child module can use outputs to expose a subset of its resource attributes to a parent module.
  2.  A root module can use outputs to print certain values in the CLI output after running terraform apply.
  3.  When using remote state, root module outputs can be accessed by other configurations via a terraform_remote_state data source."- https://www.terraform.io/docs/configuration/outputs.html


In this config we will add userPoolId, and userPoolId which will take care of the communication between Cognito and the front end application. We also use invoke_url which is the endpoint for the API getway communication. After configuring these varaibles, we will upload the static website related resources to the bucket.
*/
resource "local_file" "generate_config_file" {
  content  = <<-EOF
    window._config = {
        cognito: {
            userPoolId: '${var.pool_id}', // e.g. us-east-2_uXboG5pAb
            userPoolClientId: '${var.pool_client_id}', // e.g. 25ddkmj4v6hfsfvruhpfi7n4hv
            region: '${data.aws_region.current.name}' // e.g. us-east-2
        },
        api: {
            invokeUrl: '${var.invoke_url}' // e.g. https://rc7nyt4tql.execute-api.us-west-2.amazonaws.com/prod,
        }
    };
    EOF
  filename = "${path.module}/../../app/${var.env}/${var.partner}/website/js/config.js"
}
resource "aws_s3_bucket" "public_bucket" {
  depends_on = [
    local_file.generate_config_file,
  ]
  bucket = "${var.env}-${var.partner}-${var.app}"
  acl    = "public-read"

  tags = {
    Name        = "${var.env}-${var.partner}-${var.app}"
    Environment = var.env
    Partner     = var.partner
  }

  provisioner "local-exec" {
    when    = create
    command = "aws s3 sync ${path.module}/../../app/${var.env}/${var.partner}/website s3://${aws_s3_bucket.public_bucket.id} --region ${aws_s3_bucket.public_bucket.region}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "aws s3 rm s3://${aws_s3_bucket.public_bucket.id} --recursive"
  }

  website {
    index_document = "index.html"
    error_document = "error.html"

    routing_rules = <<EOF
    [{
      "Condition": {
          "KeyPrefixEquals": "docs/"
      },
      "Redirect": {
          "ReplaceKeyPrefixWith": "documents/"
      }
    }]
    EOF
  }
}

resource "aws_s3_bucket_policy" "public_bucket_policy" {
  bucket = aws_s3_bucket.public_bucket.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
     {
        "Effect": "Allow", 
        "Principal": "*", 
        "Action": "s3:GetObject", 
        "Resource": "arn:aws:s3:::${aws_s3_bucket.public_bucket.id}/*"
      }
  ]
}
POLICY
}

