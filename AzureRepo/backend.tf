terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-XXXX-ss-XXXX"
    key            = "demo-azuredevops-aws-orchestration"
    region         = "ap-southeast-2"
    dynamodb_table = "terraform-state-lock"
  }
}
