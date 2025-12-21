terraform {
  backend "s3" {
    bucket         = "tfstatebuckets3-f929909f"
    key            = "global/mystatefile/terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "dynamodb-state"
  }
}