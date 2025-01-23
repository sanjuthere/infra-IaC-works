terraform {
  backend "s3" {
    bucket = "demo-bucket-24e5da220888"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
