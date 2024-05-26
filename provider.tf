provider "aws" {
  region = "us-east-1" # If you change region, make sure to update availability zone in other files as well to match
  profile = "terraform-user" # Create your own profile here
  assume_role {
    role_arn = "" # Use own role ARN
  }
}

# For this project, i have chosen to authenticate through a profile and am using an assumed role created in my AWS account. Feel free to explore other authentication and authorization approaches if you so choose