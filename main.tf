provider "aws" {
  region = "${var.region}"
  shared_credentials_file = "/home/christian/.aws/emslynk-dev"
}