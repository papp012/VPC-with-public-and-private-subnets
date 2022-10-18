variable "region" {
  default = "eu-central-1"
}

variable "prefix" {
  default = "papp012"
}

variable "ami_ID" {
  default = "ami-05ff5eaef6149df49"
}

data "external" "myipaddr" {
  program = ["bash", "-c", "curl -s 'https://api.ipify.org?format=json'"]
}
locals {
  my_ip = "${data.external.myipaddr.result.ip}"
}
