terraform {
  backend "s3" {
    bucket = "ikkuthebucket2"
    key    = "terraform.tfstate"
    region = "us-east-1"
    
  }
}