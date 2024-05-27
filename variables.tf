# NECESSARY FOR provider.tf file

variable "region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1" # Use OWN
}

variable "profile" {
  description = "Profile name for AWS authentication"
  type        = string
  default     = "terraform-user" # Use OWN
}

variable "role_arn" {
  description = "ARN for Role assumed by Terraform User"
  type = string
  default = "arn:aws:iam::******:role/*******" # Use OWN
}

# OTHERS WITHIN THE CONFIGURATION FILES =====================
variable "ami" {
  description = "AMI ID for the EC2 instances"
  type        = string
  default     = "ami-08d4ac5b634553e16"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_key" {
  description = "SSH key pair name for EC2 instances"
  type        = string
  default     = "terraform_keys" # Use OWN
}

variable "avail_zones" {
  description = "List of Availability zones used"
  type = list
  default = [ "us-east-1a", "us-east-1b" ]
}
# CIDR BLOCK Cidrs=============================================
variable "vpc_cidrs" {
  description = "CIDR blocks for the VPC and subnets"
  type        = list(string)
  default     = ["10.0.0.0/16", "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
}

variable "pub_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type = list
  default     = ["10.0.1.0/24", "10.0.2.0/24",]
}

variable "priv_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type = list
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "pub_int_cidr" {
  description = "CIDR block for public internet access"
  default     = "0.0.0.0/0"
}

# GLOBAL TAGS VARIABLE TEMPLATE ====================================

variable "global_tags" {
  description = "default tags for resources"
  type        = map(string)
  default = {
    "cost-center"             = "yourDepartment"
    "project"                 = "apache"
    "Environment"             = "Dev"
    "Instance_Category"       = ""
    "VPC_Category"            = ""
    "resource_type"           = ""
    "Network"                 = ""
    "Name"                    = ""
    "Owner"                   = "defaultOwner"
    "Application"             = "defaultApp"
    "Compliance"              = "defaultCompliance"
    "Business Unit"           = "defaultBusinessUnit"
    "Creation Date"           = "2024-05-27"
    "Service"                 = "defaultService"
    "Version"                 = "1.0"
    "Lifecycle"               = "Active"
    "Region"                  = "defaultRegion"
    "Security_Group"          = ""
    "Route_Table"             = ""
    "Route_Table_Association" = ""
    "VPC"                     = "main"
  }
}
