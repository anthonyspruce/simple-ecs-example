provider "aws" {
  default_tags {
    tags = {
      Terraform   = "true"
      ProjectName = var.project_name
    }
  }
}