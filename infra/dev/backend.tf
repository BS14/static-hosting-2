terraform {
  backend "s3" {
    bucket  = "fivexl-static-hosting-tf-state"
    key     = "dev/static-site-2/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
