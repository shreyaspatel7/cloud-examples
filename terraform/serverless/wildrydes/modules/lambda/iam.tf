//This will generate an IAM role that assumes inbuild policy for lambda
resource "aws_iam_role" "iam_for_lambda" {
  name = "${var.env}-${var.partner}-${var.app}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


/*
This will create a new policy that allows lambda to put data in the dynamoDB 
and attache the policy the role created in the previous step
*/
resource "aws_iam_role_policy" "test_policy" {
  name = "${var.env}-${var.partner}-${var.app}"
  role = aws_iam_role.iam_for_lambda.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "dynamodb:PutItem",
            "Resource": "${var.arn}"
        }
    ]
  }
  EOF
}

//This will define the arn required for pre-existing basic lambda execution role to attach to the role
data "aws_iam_policy" "basic_labda_access" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

//This will attached the ARN  with the created policy
resource "aws_iam_role_policy_attachment" "basic_labda_access_role_policy_attach" {
  role       = "${aws_iam_role.iam_for_lambda.name}"
  policy_arn = "${data.aws_iam_policy.basic_labda_access.arn}"
}