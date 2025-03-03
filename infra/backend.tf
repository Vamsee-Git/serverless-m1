terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-two-tier-vamsee"
    key            = "terradorm/statefile_serverless"
    region         = "ap-south-1"
  }
}
