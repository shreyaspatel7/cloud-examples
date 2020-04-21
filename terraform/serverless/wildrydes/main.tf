
//This module will deploy DynamoDB
module "db" {
  source  = "./modules/db"
  env     = "${var.env}"
  partner = "${var.partner}"
  app     = "${var.app}"
}

//This modile will deploylambda function
module "lambda" {
  source  = "./modules/lambda"
  env     = "${var.env}"
  partner = "${var.partner}"
  app     = "${var.app}"
  arn     = module.db.arn
}

/*
This modulde will configure userpool and userpool client to enable communication 
between frontend registration module and lambda thought api gateway 
*/
module "cognito" {
  source  = "./modules/auth"
  env     = "${var.env}"
  partner = "${var.partner}"
  app     = "${var.app}"
}

/*
This module is used to configure API Gateway which will create /ride resouce, create POST and OPTION method with corse configuration
*/
module "api_gateway" {
  source        = "./modules/api"
  env           = "${var.env}"
  partner       = "${var.partner}"
  app           = "${var.app}"
  invoke_arn    = module.lambda.invoke_arn
  function_name = module.lambda.function_name
  arn           = module.cognito.pool_client_arn

}

// This module will create s3 bucket with statis hosting configurations  
module "storage" {
  source         = "./modules/storage"
  env            = "${var.env}"
  partner        = "${var.partner}"
  app            = "${var.app}"
  pool_id        = module.cognito.pool_id
  pool_client_id = module.cognito.pool_client_id
  invoke_url = module.api_gateway.invoke_url
}

