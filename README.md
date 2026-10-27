# AWS Terraform Project 1 — Highly Available Web Architecture

Infrastructure as Code project that provisions a secure, highly available web application environment on AWS using **Terraform**.

The stack is deployed in **N. Virginia (`us-east-1`)** across **two Availability Zones**, with web servers running in private subnets behind an Application Load Balancer, and a jump server (bastion) for SSH access.

---

## Architecture

 <img width="1111" height="743" alt="AdobeExpressPhotos_f49a407f5f8743209f036123ea493956_CopyEdited" src="https://github.com/user-attachments/assets/ef80b0bb-e43b-4125-927c-7c094a828e5b" />


```
                         Internet
                            |
                          [ IGW ]
                            |
                         [ ALB ]
          ┌─────────────────┴─────────────────┐
          |                VPC                |
   ┌──────┴───────┐                    ┌──────┴───────┐
   |     AZ1      |                    |     AZ2      |
   | Public       |                    | Public       |
   | 192.168.3.0/24                    | 192.168.4.0/24
   | [Jump Server]|                    | [NAT Gateway]|
   |              |                    |              |
   | Private      |                    | Private      |
   | 192.168.1.0/24                    | 192.168.2.0/24
   | [Web Server 1]  <-- Auto Scaling Group -->  [Web Server 2]
   └──────────────┘                    └──────────────┘
                                              |
                              IAM Role + S3 Policy ──► [ S3 Bucket ]
```

### Components

| Component | Description |
|---|---|
| **VPC** | Custom VPC spanning two Availability Zones |
| **Public subnets** | `192.168.3.0/24` (AZ1) and `192.168.4.0/24` (AZ2) |
| **Private subnets** | `192.168.1.0/24` (AZ1) and `192.168.2.0/24` (AZ2) |
| **Internet Gateway (IGW)** | Gives the public subnets internet access |
| **NAT Gateway** | Lets instances in private subnets reach the internet (updates, packages) without being exposed |
| **Jump Server** | EC2 instance in a public subnet, the only entry point for SSH (port 22) |
| **Application Load Balancer** | Distributes incoming HTTP traffic across the web servers |
| **Auto Scaling Group** | Runs the web servers (EC2) in the private subnets across both AZs |
| **IAM Role + S3 Policy** | Lets the web servers access the S3 bucket without hard-coded credentials |
| **S3 Bucket** | Object storage accessed by the web servers |

### Routing

| Route Table | Destination | Next hop |
|---|---|---|
| Public | `0.0.0.0/0` | Internet Gateway |
| Private | `0.0.0.0/0` | NAT Gateway |

### Security Groups

| Security Group | Inbound ports | Attached to |
|---|---|---|
| Jump server SG | `22` (SSH) | Jump server |
| Web server SG | `22`, `80` | Web servers (ASG) |

> **Note:** For production, restrict port 22 to your own IP (or to the jump server's security group) instead of `0.0.0.0/0`.

---

## Prerequisites

- An AWS account and an IAM user/role with permissions to create the resources above
- [Terraform](https://developer.hashicorp.com/terraform/downloads) `
- [AWS CLI](https://aws.amazon.com/cli/) configured with your credentials:

  ```bash
  aws configure
  ```



---

## Project Structure

> TODO: replace with the real structure of the repo (output of `tree`).

```
.
├── main.tf          # Provider and core resources
├── variables.tf     # Input variables
├── outputs.tf       # Output values
├── terraform.tfvars # Variable values (do not commit secrets)
└── README.md

```
## Remote State (S3 Backend)

Terraform state is stored remotely in an S3 bucket (`backend.tf`) instead of locally.

> The S3 bucket must exist **before** running `terraform init`.
---

## Usage

1. **Clone the repository**

   ```bash
   git clone https://github.com/zeyad14456-boop/AWS-TERRAFORM-PROJECT-1.git
   cd AWS-TERRAFORM-PROJECT-1
   ```

2. **Initialize Terraform**

   ```bash
   terraform init
   ```

3. **Review the execution plan**

   ```bash
   terraform plan
   ```

4. **Deploy the infrastructure**

   ```bash
   terraform apply
   ```

   Type `yes` when prompted.

5. **Access the application** using the ALB DNS name printed in the outputs.

6. **SSH into a private web server** through the jump server:

   ```bash
   ssh -i <key>.pem -J ec2-user@<jump-server-public-ip> ec2-user@<web-server-private-ip>
   ```

---

## Variables

| Name | Description | Default |
|---|---|---|
| `region` | AWS region | `us-east-1` |
| `vpc_cidr` | CIDR block of the VPC | 
| `instance_type` | EC2 instance type for web servers | 
| `key_name` | EC2 key pair name | 

## Outputs

| Name | Description |
|---|---|
| `alb_dns_name` | DNS name of the Application Load Balancer |
| `jump_server_public_ip` | Public IP of the jump server |

---

## Clean Up

To avoid ongoing AWS charges (the NAT Gateway and ALB are billed hourly), destroy everything when you are done:

```bash
terraform destroy
```
---

## Author

**Zeyad Ahmed** — [GitHub](https://github.com/Zeyad-Ahmed2461)
