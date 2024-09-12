terraform {
  backend "s3" {
    bucket = "mern-s3-bucket"
    key    = "terraform/terraform.tfstate"
    region = "us-east-1"
  }
}
