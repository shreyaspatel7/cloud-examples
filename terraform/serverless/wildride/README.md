## AWS Serverlelss IaS

### Introduction

In this project we have implemented the terrafrom code foe the serverless web application architecture mentioned on the [AWS site](https://aws.amazon.com/getting-started/hands-on/build-serverless-web-app-lambda-apigateway-s3-dynamodb-cognito/). This Terraform Framerwork supports deployment for mulitple clients as well as multiple environments(dev, uat, prod..etc) based on the varibles configured in the `dev.tfvars file`. This code will utilize the following AWS resources via terraform:

- s3 Storage for static site hosting
- AWS Cognito User Pool for the user managment (autherization/authentication)
- AWS Lambda for handelind backend process
- DynamoDB for data storage 
- API Gateaway for RESTful API  




#### How do I deploy this environment?
In order to deploy the architecture, you will have to execute the following terrafrom commands. If you would like to deploy another variant of the application then you can simaplly add your variant to `app/<ENV>/<CLIENT>/`directory and create another `.tfvars` file with appropriate variables to deploy the variant. The newly created `.tfvars` file then can be passed on during the `terraform plan -var-file=<YOUR_NEW_FILE>` phase.

```Shell
terraform init
terraform workspace new dev
terraform workspace select dev
terraform plan -var-file=dev.tfvars --out this.plan
terraform apply this.plan
```

#### How do I teardown this environment?
```Shell
terraform destroy -var-file=dev.tfvars 
```