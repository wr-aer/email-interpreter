terraform {
  backend "s3" {
    # Change as required for specific tf backend setup
    bucket = "email-interpreter-terraform-backend"
    key    = "email-interpreter-terraform-backend"
    region = "eu-west-2"
  }
}
