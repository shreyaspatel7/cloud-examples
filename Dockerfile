FROM ubuntu:bionic

RUN apt-get update -y && apt-get upgrade -y && apt-get install curl unzip python-pip -y

# Terraform
RUN curl -Lo /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip && \
    cd /usr/local/bin && unzip /tmp/terraform.zip && chmod +x /usr/local/bin/terraform


