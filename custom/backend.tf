terraform {
    required_version = ">=1.10"
  backend "s3" {
    bucket = "statefilebucket100"
    key = "terraform.tfstate"
    region = "us-east-1"
   #use_lockfile = true
    dynamodb_table = "ikram"

  }
}
