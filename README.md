# AWS Terraform Setup with NAT Gateway, VPC Endpoints, and SSM

This repository contains Terraform configuration files to set up an AWS environment with a NAT Gateway, VPC endpoints, and AWS Systems Manager (SSM) for managing EC2 instances. The setup includes both public and private subnets for high availability, with instances in private subnets accessing the internet via a NAT Gateway.

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Components](#components)
- [Setup Instructions](#setup-instructions)
- [Usage](#usage)
- [Troubleshooting](#troubleshooting)

## Overview

The project sets up the following:

- A VPC with public and private subnets across two availability zones for high availability.
- An Internet Gateway for public subnets.
- A NAT Gateway in a public subnet to allow instances in private subnets to access the internet.
- VPC endpoints for SSM, SSM messages, and EC2 messages to enable Systems Manager functionalities.
- EC2 instances in both public and private subnets, with appropriate IAM roles and security groups.
- S3 bucket access using KMS for securing data.

## Architecture

The architecture includes:

- **VPC**: A Virtual Private Cloud with subnets spread across multiple availability zones.
- **Subnets**: Public and private subnets in each availability zone.
- **NAT Gateway**: To allow private subnet instances to access the internet.
- **VPC Endpoints**: For SSM, SSM messages, and EC2 messages.
- **EC2 Instances**: Instances in both public and private subnets with appropriate security groups and IAM roles.

## Components

- **provider.tf**: Configuration for the AWS provider.
- **vpc.tf**: Definitions for the VPC, subnets, Internet Gateway, NAT Gateway, and route tables.
- **security_groups.tf**: Definitions for security groups.
- **iam.tf**: IAM roles and policies for EC2 instances.
- **ec2_instances.tf**: Configuration for EC2 instances.
- **s3_bucket.tf**: Configuration for an S3 bucket with KMS encryption.
- **user_data.sh**: User data script for EC2 instances to install and configure necessary software.

## Setup Instructions

1. **Clone the repository**:

2. **Initialize Terraform**:

- terraform init

3. **Validate the configuration**:

- terraform validate

4. **Apply the configuration**:

- terraform apply

# **Follow the prompts to confirm the changes**.

## Usage

### Connecting to Instances:

- Use AWS Systems Manager Session Manager to connect to instances without needing SSH access.
- Ensure the necessary IAM roles and VPC endpoints are configured for SSM.

## Accessing the S3 Bucket:

### Instances in both public and private subnets can access the S3 bucket securely via the defined IAM policies and KMS encryption.

## Troubleshooting

### Instance Connectivity Issues:

- Ensure the NAT Gateway and route tables are correctly configured.
- Verify that security groups allow necessary outbound traffic.

## SSM Connection Issues:

- Check that VPC endpoints for SSM, SSM messages, and EC2 messages are available.
- Ensure IAM roles have the necessary permissions.
