data "aws_region" "current" {}

module "db" {
  source  = "./modules/db"
  env     = "${var.env}"
  partner = "${var.partner}"
  app     = "${var.app}"
}

module "lambda" {
  source  = "./modules/lambda"
  env     = "${var.env}"
  partner = "${var.partner}"
  app     = "${var.app}"
  arn     = module.db.arn
}

module "cognito" {
  source  = "./modules/auth"
  env     = "${var.env}"
  partner = "${var.partner}"
  app     = "${var.app}"
}

module "api_gateway" {
  source        = "./modules/api"
  env           = "${var.env}"
  partner       = "${var.partner}"
  app           = "${var.app}"
  invoke_arn    = module.lambda.invoke_arn
  function_name = module.lambda.function_name
  arn           = module.cognito.pool_client_arn

}


# Copies the string in content into /tmp/file.log

resource "local_file" "foo" {
  content  = <<-EOF
    window._config = {
        cognito: {
            userPoolId: '${module.cognito.pool_id}', // e.g. us-east-2_uXboG5pAb
            userPoolClientId: '${module.cognito.pool_client_id}', // e.g. 25ddkmj4v6hfsfvruhpfi7n4hv
            region: '${data.aws_region.current.name}' // e.g. us-east-2
        },
        api: {
            invokeUrl: '' // e.g. https://rc7nyt4tql.execute-api.us-west-2.amazonaws.com/prod,
        }
    };
    EOF
  filename = "${path.module}/app/${var.env}/${var.partner}/website/js/config.js"
}

module "storage" {
  source         = "./modules/storage"
  env            = "${var.env}"
  partner        = "${var.partner}"
  app            = "${var.app}"
  pool_id        = module.cognito.pool_id
  pool_client_id = module.cognito.pool_client_id
}

