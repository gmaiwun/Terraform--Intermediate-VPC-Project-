provider "aws" {
  region = var.region
  profile = var.profile 
  assume_role {
    role_arn = var.role_arn
  }
}

# For this project, i have chosen to authenticate through a profile and am using an assumed role created in my AWS account. Feel free to explore other authentication and authorization approaches if you so choose