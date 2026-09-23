# 🚀 AWS EC2 Deployment using Terraform

This is a small Terraform project that creates an **AWS EC2 instance** using Infrastructure as Code (IaC). The project demonstrates the basic relationship between **Terraform, AWS Provider, Region, AMI, EC2 Instance Type, VPC, Subnet, and SSH Key Pair**.

---

## 📌 Project Overview

In this project, Terraform is used to create and manage an EC2 instance in the AWS `ap-south-1` (Mumbai) region.

The infrastructure is defined using a Terraform configuration file instead of manually creating the EC2 instance from the AWS Console.

### Architecture

```text
                         Terraform
                             │
                             │ AWS Provider
                             ↓
                    AWS ap-south-1
                         (Mumbai)
                             │
                             ↓
                           VPC
                             │
                             ↓
                          Subnet
                             │
                             ↓
                      ┌──────────────┐
                      │     EC2      │
                      │              │
                      │  t3.micro    │
                      │              │
                      │  Linux AMI   │
                      │              │
                      │ terraform_key│
                      └──────────────┘
```

---

# 🛠️ Technologies Used

* **Terraform**
* **AWS EC2**
* **AWS VPC**
* **AWS Subnet**
* **AWS AMI**
* **AWS Key Pair**
* **AWS CLI**
* **PowerShell / Windows**

---

# 📁 Project Structure

```text
terraform/
│
├── main.tf
├── terraform.tfstate
├── terraform.tfstate.backup
└── .terraform/
```

> `.terraform/` and `terraform.tfstate*` should normally be added to `.gitignore` before pushing a real project to GitHub.

Recommended `.gitignore`:

```gitignore
.terraform/
*.tfstate
*.tfstate.*
*.tfvars
*.pem
```

---

# 📝 Terraform Configuration

The main Terraform configuration is stored in `main.tf`.

```hcl
provider "aws" {

  region = "ap-south-1"

}

resource "aws_instance" "example" {

  ami           = "ami-04a00762f46d582a2"
  instance_type = "t3.micro"

  subnet_id = "subnet-0e2a25695eceaab23"

  key_name = "terraform_key"

}
```

---

# 🔍 Understanding the Terraform Code

## 1. AWS Provider

```hcl
provider "aws" {
  region = "ap-south-1"
}
```

The `provider` tells Terraform which cloud provider it should communicate with.

```text
Terraform
    ↓
AWS Provider
    ↓
AWS API
    ↓
AWS Resources
```

Here, the provider is AWS.

### Region

```hcl
region = "ap-south-1"
```

`ap-south-1` is the AWS Mumbai region.

AWS has multiple regions around the world, for example:

```text
ap-south-1 → Mumbai
us-east-1  → N. Virginia
eu-west-1  → Ireland
```

The region is important because many AWS resources, especially **AMI IDs**, are region-specific.

---

# 2. AWS EC2 Resource

```hcl
resource "aws_instance" "example" {
```

This tells Terraform that we want to create/manage an **AWS EC2 instance**.

The syntax is:

```text
resource "<RESOURCE_TYPE>" "<RESOURCE_NAME>"
```

In this project:

```text
Resource Type → aws_instance
Resource Name → example
```

Terraform internally refers to this resource as:

```text
aws_instance.example
```

---

# 3. AMI

```hcl
ami = "ami-01a00762f46d584a1"
```

AMI stands for **Amazon Machine Image**.

An AMI is a template used to create an EC2 instance.

It can contain:

* Operating system
* System configuration
* Required software
* Boot configuration

The relationship is:

```text
AMI
 ↓
Create EC2
 ↓
Linux Server
```

The AMI ID used in this project is:

```text
ami-02a00732f46d582a3
```

### Important

AMI IDs are generally **region-specific**.

Therefore, an AMI that works in:

```text
ap-south-1
```

may not exist in:

```text
us-east-1
```

This was an important issue encountered while creating this project.

---

# 4. Instance Type

```hcl
instance_type = "t3.micro"
```

The instance type defines the resources available to the EC2 instance.

It determines things such as:

* CPU
* Memory
* Network performance
* Burstable CPU behavior

Examples of instance types include:

```text
t3.micro
t3.small
t3.medium
t3.large
```

For this learning project, a small instance type such as `t3.micro` is sufficient.

> AWS Free Tier eligibility can vary by account and current AWS terms, so the instance type should be checked against the account's current eligibility before deployment.

---

# 5. Subnet

```hcl
subnet_id = "subnet-0e5a25695eceaab51"
```

A **subnet** is a smaller network inside an AWS VPC.

The relationship is:

```text
AWS Region
     │
     ↓
   VPC
     │
     ↓
  Subnet
     │
     ↓
   EC2
```

The `subnet_id` tells AWS exactly which subnet should contain the EC2 instance.

In this project:

```text
Subnet ID:
subnet-0e2a25895eceaab63
```

### VPC vs Subnet

A simple way to remember:

```text
VPC   = Complete virtual network
Subnet = Smaller network section inside the VPC
EC2   = Server placed inside the subnet
```

For example:

```text
VPC
│
├── Public Subnet
│     ├── EC2
│     └── Load Balancer
│
└── Private Subnet
      ├── Backend
      └── Database
```

---

# 6. Key Pair

```hcl
key_name = "terraform_key"
```

The `key_name` specifies the AWS EC2 **Key Pair** associated with the instance.

Key pairs are commonly used for SSH authentication.

The basic flow is:

```text
Your Computer
     │
     │ SSH
     │
     ↓
   EC2
```

The AWS key pair contains the public key, while the private key is kept on your computer.

For example:

```text
terraform_key
      │
      └── terraform_key.pem
```

SSH can then be used to connect to the EC2 instance.

```bash
ssh -i terraform_key.pem ubuntu@<PUBLIC-IP>
```

The actual username depends on the operating system used by the AMI.

---

# 🌐 AWS Networking

The EC2 instance created by this project has both public and private networking.

Example:

```text
Internet
    │
    ↓
Public IP
3.111.49.39
    │
    ↓
EC2
    │
    ↓
Private IP
172.31.29.84
```

### Public IP

A public IPv4 address allows the instance to communicate with the internet when the appropriate AWS networking and security rules are configured.

Example:

```text
3.111.49.39
```

### Private IP

The private IP is used for communication inside the VPC/private AWS network.

Example:

```text
172.31.29.84
```

---

# 🏗️ AWS Architecture

The complete architecture can be represented as:

```text
                           INTERNET
                               │
                               │
                         Public IP
                       3.111.49.39
                               │
                               ↓
                    ┌───────────────────┐
                    │       AWS         │
                    │   ap-south-1      │
                    │     Mumbai        │
                    │                   │
                    │       VPC         │
                    │         │         │
                    │       Subnet      │
                    │         │         │
                    │         ↓         │
                    │   ┌───────────┐   │
                    │   │    EC2    │   │
                    │   │           │   │
                    │   │ t3.micro  │   │
                    │   │           │   │
                    │   │   Linux   │   │
                    │   └───────────┘   │
                    │         │         │
                    │         ↓         │
                    │ Private IP        │
                    │ 172.31.29.84      │
                    └───────────────────┘
```

---

# ⚙️ Terraform Workflow

Terraform follows a basic workflow:

```text
Write Configuration
        ↓
terraform init
        ↓
terraform plan
        ↓
terraform apply
        ↓
AWS Infrastructure
```

---

## Step 1: Initialize Terraform

Run:

```powershell
terraform init
```

This initializes the Terraform project and downloads the required provider.

For this project, Terraform downloads the AWS provider.

---

## Step 2: Validate Configuration

Run:

```powershell
terraform validate
```

This checks whether the Terraform configuration is syntactically valid.

---

## Step 3: Create a Plan

Run:

```powershell
terraform plan
```

Terraform checks the configuration and shows what it intends to create/change/destroy.

Example:

```text
Plan: 1 to add, 0 to change, 0 to destroy.
```

---

## Step 4: Create the EC2 Instance

Run:

```powershell
terraform apply
```

Terraform asks for confirmation:

```text
Do you want to perform these actions?
Only 'yes' will be accepted to approve.
```

Enter:

```text
yes
```

Terraform then communicates with AWS and creates the EC2 instance.

---

# 🔎 Check the Infrastructure

After applying Terraform, the AWS Console can be used to verify:

```text
Instance ID
Public IP
Private IP
Instance Type
VPC
Subnet
AMI
Key Pair
Instance State
```

Example:

```text
Instance State → Running
Instance Type  → t3.micro
Region         → ap-south-1
Platform       → Linux/UNIX
```

---

# 🧹 Destroy the Infrastructure

When finished practicing, run:

```powershell
terraform destroy
```

Terraform will show the resources that will be deleted.

Confirm with:

```text
yes
```

This is important when learning AWS because running resources can incur charges depending on the resource, account, and current AWS pricing/free-tier eligibility.

---

# 🧠 Key Concepts Learned

Through this small project, the following AWS and DevOps concepts were practiced:

* [x] Terraform Provider
* [x] AWS Region
* [x] AWS EC2
* [x] AMI
* [x] EC2 Instance Type
* [x] VPC
* [x] Subnet
* [x] Public IP
* [x] Private IP
* [x] EC2 Key Pair
* [x] Terraform `init`
* [x] Terraform `validate`
* [x] Terraform `plan`
* [x] Terraform `apply`
* [x] Terraform `destroy`

---


