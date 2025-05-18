provider "aws" {
  region = "eu-central-1"
  alias  = "eu"

  default_tags {
    tags = {
      owner         = "InfoSec"
      project       = "infrastructure"
      environment   = var.environment
      businessUnit  = "engineering"
      sensitiveData = "TLP:RED"
    }
  }
}
provider "aws" {
  region = "us-east-1"
  alias  = "us"

  default_tags {
    tags = {
      owner         = "InfoSec"
      project       = "infrastructure"
      environment   = var.environment
      businessUnit  = "engineering"
      sensitiveData = "TLP:RED"
    }
  }
}



