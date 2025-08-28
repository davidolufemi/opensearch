terraform {
  backend "s3" {
    bucket         = "tfstate-shared-bucket"
    key            = "vpc/terraform.tfstate" # path/key inside the bucket
    region         = "us-east-1"
    dynamodb_table = "tf-locks"
    encrypt        = true
  }
}
