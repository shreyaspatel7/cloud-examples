
resource "aws_s3_bucket" "public_bucket" {
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

