# Terraform Infrastructure Documentation

## Overview
This document provides a detailed explanation of the AWS infrastructure deployed using Terraform. It includes information on networking, server provisioning, storage setup, and IAM user creation.

## 1. Networking Setup
### VPC
- **Name**: `public_vpc`
- **CIDR Block**: `10.0.0.0/16`
- **Instance Tenancy**: Default

### Subnets
- **Public Subnet 1**:
  - Name: `az1_subnet`
  - CIDR Block: `10.0.1.0/24`
  - Availability Zone: `eu-north-1a`
  - Public IP Assignment: Enabled
- **Public Subnet 2**:
  - Name: `az2_subnet`
  - CIDR Block: `10.0.2.0/24`
  - Availability Zone: `eu-north-1b`
  - Public IP Assignment: Enabled

### Internet Gateway
- **Name**: `public_internet_gateway`
- **Attached to**: `public_vpc`

### Security Group
- **Name**: `security_group`
- **Rules**:
  - **Inbound**:
    - HTTP (80) – Allowed from within the VPC
    - HTTPS (443) – Allowed from within the VPC
    - SSH (22) – Allowed from within the VPC
  - **Outbound**:
    - All traffic allowed (`0.0.0.0/0`)

## 2. Server Provisioning
### Backend Servers
- **Instance Type**: `t3.micro`
- **Count**: `2`
- **AMI**: `ami-09a9858973b288bdd`
- **Subnet**: `az1_subnet`
- **Security Group**: `security_group`
- **Tags**: Named as `backend_server_X` (where X is the instance index)

### Frontend Servers
- **Instance Type**: `t3.micro`
- **Count**: `3`
- **AMI**: `ami-09a9858973b288bdd`
- **Subnet**: `az1_subnet`
- **Security Group**: `security_group`
- **Tags**: Named as `frontend_server_X` (where X is the instance index)

## 3. S3 Bucket Configuration
- **Bucket Name**: `trevo-s3-bucket`
- **Purpose**: General storage for the infrastructure
- **Tags**: Named as `trevo-s3-bucket`

## 4. IAM User Creation
- **User Name**: `BOB`
- **Role**: `AdministratorAccess`
- **Path**: `/`
- **Description**: `CTO`
- **Policy Attachment**: `AdministratorAccess` policy attached to user

## 5. Summary
This Terraform configuration sets up a scalable AWS infrastructure including a VPC with two public subnets, security group configurations, EC2 instances for backend and frontend services, an S3 bucket for storage, and an IAM user with administrative privileges. This setup provides a strong foundation for deploying cloud applications while maintaining security best practices.

## Conclusion
This documentation serves as a guide to understanding the deployed AWS infrastructure and can be used as a reference for further enhancements and maintenance.

