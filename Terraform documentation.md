# Terraform — Complete Beginner to Advanced Guide

> A practical Terraform reference covering **what Terraform is, why it is used, the problems it solves, how Terraform works internally, its lifecycle, HCL, providers, resources, state, variables, outputs, modules, dependencies, commands, best practices, and a complete AWS example.**

---

# 📚 Table of Contents

* [1. What is Terraform?](#1-what-is-terraform)
* [2. What is Infrastructure as Code?](#2-what-is-infrastructure-as-code)
* [3. What Problem Does Terraform Solve?](#3-what-problem-does-terraform-solve)
* [4. Terraform vs Manual Infrastructure](#4-terraform-vs-manual-infrastructure)
* [5. Why Terraform?](#5-why-terraform)
* [6. How Terraform Works](#6-how-terraform-works)
* [7. Terraform Architecture](#7-terraform-architecture)
* [8. Terraform Core Concepts](#8-terraform-core-concepts)
* [9. HCL](#9-hcl)
* [10. Terraform Configuration Files](#10-terraform-configuration-files)
* [11. Providers](#11-providers)
* [12. Resources](#12-resources)
* [13. Data Sources](#13-data-sources)
* [14. Variables](#14-variables)
* [15. Locals](#15-locals)
* [16. Outputs](#16-outputs)
* [17. Modules](#17-modules)
* [18. Terraform State](#18-terraform-state)
* [19. Desired State vs Current State](#19-desired-state-vs-current-state)
* [20. Dependency Graph](#20-dependency-graph)
* [21. Terraform Lifecycle](#21-terraform-lifecycle)
* [22. Complete Terraform Workflow](#22-complete-terraform-workflow)
* [23. `terraform init`](#23-terraform-init)
* [24. `terraform validate`](#24-terraform-validate)
* [25. `terraform fmt`](#25-terraform-fmt)
* [26. `terraform plan`](#26-terraform-plan)
* [27. `terraform apply`](#27-terraform-apply)
* [28. `terraform destroy`](#28-terraform-destroy)
* [29. Other Important Commands](#29-other-important-commands)
* [30. Terraform Lifecycle Meta-Argument](#30-terraform-lifecycle-meta-argument)
* [31. `depends_on`](#31-depends_on)
* [32. `count` vs `for_each`](#32-count-vs-for_each)
* [33. Implicit Dependencies](#33-implicit-dependencies)
* [34. Explicit Dependencies](#34-explicit-dependencies)
* [35. Terraform State and Drift](#35-terraform-state-and-drift)
* [36. Local vs Remote State](#36-local-vs-remote-state)
* [37. Terraform Backend](#37-terraform-backend)
* [38. Provider Lock File](#38-provider-lock-file)
* [39. Terraform Registry](#39-terraform-registry)
* [40. Terraform Modules](#40-terraform-modules)
* [41. Terraform with AWS](#41-terraform-with-aws)
* [42. Complete AWS EC2 Example](#42-complete-aws-ec2-example)
* [43. What Happens During `terraform apply`](#43-what-happens-during-terraform-apply)
* [44. Terraform Destroy Flow](#44-terraform-destroy-flow)
* [45. Terraform in DevOps](#45-terraform-in-devops)
* [46. Terraform CI/CD](#46-terraform-cicd)
* [47. Terraform Best Practices](#47-terraform-best-practices)
* [48. Common Terraform Mistakes](#48-common-terraform-mistakes)
* [49. Important Terraform Terms](#49-important-terraform-terms)
* [50. Terraform Interview Questions](#50-terraform-interview-questions)
* [51. Recommended Learning Order](#51-recommended-learning-order)
* [52. Quick Revision](#52-quick-revision)

---

# 1. What is Terraform?

**Terraform is an Infrastructure as Code (IaC) tool created by HashiCorp.**

Terraform allows us to define infrastructure using configuration files instead of manually creating infrastructure through a cloud provider's web console.

For example, instead of manually doing:

```text
AWS Console
   ↓
Create VPC
   ↓
Create Subnet
   ↓
Create Security Group
   ↓
Create EC2
   ↓
Attach configuration
   ↓
Configure networking
```

we can describe the infrastructure in Terraform:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t2.micro"
}
```

Terraform then communicates with AWS through the AWS provider and creates the EC2 instance.

HashiCorp describes Terraform as a tool for building, changing, and versioning infrastructure safely and efficiently.

---

# 2. What is Infrastructure as Code?

**Infrastructure as Code = managing infrastructure using code/configuration files.**

Traditional approach:

```text
Human
  ↓
AWS Console
  ↓
Click buttons
  ↓
Create resources
```

Infrastructure as Code:

```text
Terraform Configuration
        ↓
      Terraform
        ↓
   Cloud Provider API
        ↓
   Infrastructure
```

For example:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t2.micro"
}
```

This configuration becomes the description of the infrastructure we want.

---

# 3. What Problem Does Terraform Solve?

Imagine you have to create infrastructure for an application.

You need:

```text
1 VPC
2 Subnets
2 Security Groups
1 Load Balancer
3 EC2 instances
1 Database
1 S3 bucket
```

If you create everything manually, several problems appear.

## Problem 1 — Manual work

You have to repeatedly click through the cloud console.

```text
Click
 ↓
Click
 ↓
Click
 ↓
Configure
 ↓
Click
 ↓
Repeat
```

This is slow.

Terraform:

```text
terraform apply
```

can create the infrastructure described in the configuration.

---

## Problem 2 — Human mistakes

When creating infrastructure manually, someone might configure:

```text
Security Group A → Port 80
Security Group B → Port 8080
Security Group C → Port 22
```

Another person may configure them differently.

Terraform lets the configuration become the source of truth.

---

## Problem 3 — Reproducibility

Suppose you create a production environment.

Later you need the same infrastructure for:

```text
Development
Testing
Staging
Production
```

Manually recreating everything is difficult.

With Terraform:

```text
Terraform Code
      ↓
 ┌────┼────┬────┐
 ↓    ↓    ↓    ↓
DEV  TEST STAGE PROD
```

The same reusable configuration can be adapted using variables and modules.

---

## Problem 4 — Documentation

Manual infrastructure often exists only inside someone's memory.

Terraform configuration becomes documentation.

For example:

```hcl
resource "aws_instance" "web" {
  instance_type = "t2.micro"
}
```

Anyone reading the code can understand that an EC2 instance is part of the infrastructure.

---

## Problem 5 — Tracking changes

Suppose yesterday:

```text
EC2 = t2.micro
```

Today:

```text
EC2 = t3.micro
```

Terraform can show the proposed infrastructure changes using:

```bash
terraform plan
```

Example:

```text
~ aws_instance.web

    instance_type: "t2.micro" -> "t3.micro"
```

You can review the change before applying it.

---

# 4. Terraform vs Manual Infrastructure

## Manual

```text
Engineer
   |
   v
Cloud Console
   |
   +---- Create EC2
   |
   +---- Create VPC
   |
   +---- Create Security Group
   |
   +---- Create Load Balancer
   |
   +---- Configure networking
```

Problems:

* Slow
* Human errors
* Difficult to reproduce
* Difficult to review
* Difficult to automate
* Difficult to maintain at scale

---

## Terraform

```text
Terraform Files
      |
      v
 terraform plan
      |
      v
 Review Changes
      |
      v
 terraform apply
      |
      v
 Cloud Provider
      |
      v
 Infrastructure
```

---

# 5. Why Terraform?

Terraform provides several important benefits.

## 5.1 Infrastructure as Code

Infrastructure is represented as code.

```text
Infrastructure
      ↓
     Code
      ↓
     Git
      ↓
 Version History
```

---

## 5.2 Repeatability

You can reproduce infrastructure.

```text
Same Terraform Code

      ↓

DEV
STAGING
PRODUCTION
```

---

## 5.3 Automation

Terraform can be integrated into CI/CD.

```text
Git Push
   ↓
CI/CD
   ↓
terraform plan
   ↓
Approval
   ↓
terraform apply
   ↓
Infrastructure
```

---

## 5.4 Version Control

Terraform code can be stored in Git.

```text
Git
 |
 +-- v1
 |
 +-- v2
 |
 +-- v3
```

You can review infrastructure changes through pull requests.

---

## 5.5 Multi-provider

Terraform can work with many platforms through providers.

Examples:

```text
AWS
Azure
GCP
Kubernetes
GitHub
Cloudflare
Datadog
Helm
```

Terraform providers communicate with the APIs of these services.

---

# 6. How Terraform Works

The most important concept is:

> **Terraform compares what you declared with what currently exists and determines what changes are required.**

The basic model is:

```text
             Terraform Configuration
                       |
                       v
                 Desired State
                       |
                       |
                       v
                  Terraform
                       |
             +---------+---------+
             |                   |
             v                   v
        Terraform State     Provider API
             |                   |
             |                   v
             |             Real Infrastructure
             |                   |
             +---------+---------+
                       |
                       v
                  Difference
                       |
                       v
                     Plan
                       |
                       v
                    Apply
```

---

# 7. Terraform Architecture

A simplified Terraform architecture looks like this:

```text
                 Terraform Configuration
                         |
                         | HCL
                         v
                 +---------------+
                 |   Terraform   |
                 |      CLI      |
                 +---------------+
                    |     |     |
                    |     |     |
                    v     v     v
               State   Modules  Graph
                    |
                    v
              Provider Plugin
                    |
                    v
              Provider API
                    |
                    v
          +---------+---------+
          |                   |
          v                   v
       AWS API            Azure API
          |                   |
          v                   v
       AWS Infra          Azure Infra
```

The Terraform CLI itself does not directly know how to create every possible AWS, Azure, Kubernetes, GitHub, or other service resource.

**Providers give Terraform that capability.**

HashiCorp describes providers as plugins that allow Terraform to interact with platforms and services through their APIs.

---

# 8. Terraform Core Concepts

The most important Terraform concepts are:

```text
Terraform
│
├── Configuration
│
├── HCL
│
├── Providers
│
├── Resources
│
├── Data Sources
│
├── Variables
│
├── Locals
│
├── Outputs
│
├── Modules
│
├── State
│
├── Dependency Graph
│
├── Plan
│
└── Apply
```

If you understand these concepts, you understand the foundation of Terraform.

---

# 9. HCL

## What is HCL?

HCL stands for:

**HashiCorp Configuration Language**

Terraform configuration is normally written using HCL.

HashiCorp describes HCL as the syntax used by Terraform's configuration language.

Example:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t2.micro"
}
```

HCL is designed to be readable by humans.

---

## HCL vs Programming Language

Terraform is not primarily a general-purpose programming language like:

```text
C++
Java
Python
JavaScript
```

Terraform is a **declarative configuration language**.

You tell Terraform:

> "This is the infrastructure I want."

You generally do not write instructions such as:

```text
first create X
then call API Y
then wait
then create Z
```

Instead:

```hcl
resource "aws_instance" "web" {
  instance_type = "t2.micro"
}
```

Terraform determines how to reach that desired state.

---

# 10. Terraform Configuration Files

Terraform normally uses files ending with:

```text
.tf
```

A common project structure:

```text
terraform-project/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── terraform.tfvars
├── versions.tf
├── .gitignore
└── README.md
```

These files are not mandatory individually.

Terraform loads `.tf` configuration files in the working directory as one configuration.

---

## `main.tf`

Usually contains resources.

```hcl
resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t2.micro"
}
```

---

## `variables.tf`

Contains input variables.

```hcl
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
```

---

## `outputs.tf`

Contains values you want Terraform to expose.

```hcl
output "public_ip" {
  value = aws_instance.web.public_ip
}
```

---

## `providers.tf`

Provider configuration.

```hcl
provider "aws" {
  region = "ap-south-1"
}
```

---

## `terraform.tfvars`

Variable values.

```hcl
instance_type = "t2.micro"
```

---

# 11. Providers

A **provider** is a plugin that allows Terraform to communicate with an external platform or service.

Examples:

```text
Terraform
   |
   +---- AWS Provider ------> AWS
   |
   +---- Azure Provider ----> Azure
   |
   +---- Google Provider ---> GCP
   |
   +---- Kubernetes --------> Kubernetes
   |
   +---- GitHub ------------> GitHub
```

Example:

```hcl
provider "aws" {
  region = "ap-south-1"
}
```

Terraform uses the AWS provider to communicate with AWS APIs.

---

## Why are providers necessary?

Terraform itself cannot contain custom implementation for every infrastructure platform.

Instead:

```text
Terraform Core
      |
      v
Provider
      |
      v
External API
```

For AWS:

```text
Terraform
   ↓
AWS Provider
   ↓
AWS API
   ↓
EC2 / VPC / S3 / RDS / etc.
```

---

# 12. Resources

A **resource** represents an infrastructure object Terraform manages.

Example:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t2.micro"
}
```

Here:

```text
resource
   ↓
aws_instance
   ↓
web
```

The syntax is:

```hcl
resource "<RESOURCE_TYPE>" "<LOCAL_NAME>" {
  
}
```

Example:

```hcl
resource "aws_instance" "web" {
}
```

`aws_instance` is the resource type.

`web` is the local name.

---

# 13. Data Sources

A resource generally manages something.

A data source generally **reads existing information**.

Example:

```hcl
data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]
}
```

Conceptually:

```text
Resource

Terraform
   |
   v
Create / Update / Delete
   |
   v
Infrastructure
```

Data source:

```text
Terraform
   |
   v
Read existing information
   |
   v
Use information in configuration
```

Example:

```text
Find latest Ubuntu AMI
       ↓
Use AMI ID
       ↓
Create EC2
```

---

# 14. Variables

Variables make Terraform configurations reusable.

Without variables:

```hcl
resource "aws_instance" "web" {
  instance_type = "t2.micro"
}
```

With a variable:

```hcl
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
```

Then:

```hcl
resource "aws_instance" "web" {
  instance_type = var.instance_type
}
```

Now we can change:

```text
t2.micro
```

to:

```text
t3.micro
```

without changing the resource itself.

HashiCorp describes variables as the input interface of a module.

---

## Variable flow

```text
terraform.tfvars
       |
       v
   variable
       |
       v
  var.instance_type
       |
       v
     resource
```

---

# 15. Locals

Locals allow you to define reusable values inside a module.

Example:

```hcl
locals {
  project_name = "my-app"
  environment  = "dev"
}
```

Then:

```hcl
tags = {
  Project     = local.project_name
  Environment = local.environment
}
```

Think of locals as reusable calculated values.

HashiCorp describes locals as named expressions that can reference variables, resources, data sources, and other locals.

---

# 16. Outputs

Outputs expose useful information from Terraform.

Example:

```hcl
output "instance_public_ip" {
  value = aws_instance.web.public_ip
}
```

After:

```bash
terraform apply
```

you might see:

```text
instance_public_ip = "13.234.xxx.xxx"
```

Think of an output like a function's return value.

```text
Resource
   |
   v
Terraform
   |
   v
Output
   |
   v
User / Another Module / Automation
```

HashiCorp documents outputs as a way to expose infrastructure information to the CLI, parent modules, other configurations, and automation.

---

# 17. Modules

A module is a reusable collection of Terraform configuration.

Without modules:

```text
main.tf
1000 lines
```

With modules:

```text
root
│
├── main.tf
│
├── modules/
│   ├── networking/
│   ├── compute/
│   └── database/
```

For example:

```text
VPC Module
   |
   +-- VPC
   +-- Subnets
   +-- Route Tables
   +-- Internet Gateway
```

Then:

```text
EC2 Module
   |
   +-- EC2
   +-- Security Group
```

Modules allow infrastructure to be reused and composed.

---

# 18. Terraform State

This is one of the **most important Terraform concepts**.

Terraform maintains information about infrastructure in a **state**.

With local state, this is commonly:

```text
terraform.tfstate
```

Terraform uses state to understand which real infrastructure objects correspond to the resources declared in your configuration.

Simplified:

```text
Terraform Code
      |
      v
Resource:
aws_instance.web
      |
      v
Terraform State
      |
      v
Real EC2 Instance
```

Example state relationship:

```text
Terraform resource
aws_instance.web
        |
        v
State
        |
        v
AWS EC2
i-0123456789abcdef
```

The state allows Terraform to track the relationship between configuration and real infrastructure.

---

# 19. Desired State vs Current State

This is the heart of Terraform.

## Desired State

What your Terraform code says should exist.

Example:

```hcl
resource "aws_instance" "web" {
  instance_type = "t2.micro"
}
```

Desired state:

```text
EC2
type = t2.micro
```

---

## Current State

What actually exists in the infrastructure.

Maybe:

```text
EC2
type = t3.micro
```

Terraform compares these.

```text
             Terraform Configuration
                       |
                       v
                  Desired State
                       |
                       |
                       v
                  Terraform
                       ^
                       |
                  Current State
                       |
                       v
                AWS Infrastructure
```

Terraform determines the required changes.

```text
Desired:
t2.micro

Current:
t3.micro

Difference:
change instance type
```

Then:

```bash
terraform plan
```

shows the proposed change.

---

# 20. Dependency Graph

Terraform creates a graph of dependencies between resources.

Example:

```text
VPC
 |
 v
Subnet
 |
 v
EC2
```

Terraform understands:

```text
EC2 depends on Subnet
Subnet depends on VPC
```

Therefore:

```text
Create VPC
   ↓
Create Subnet
   ↓
Create EC2
```

Terraform can perform independent operations in parallel where possible.

Example:

```text
          VPC
         /   \
        v     v
    Subnet A Subnet B
       |        |
       v        v
     EC2 A    EC2 B
```

Terraform does not necessarily need to create everything one-by-one if resources are independent.

---

# 21. Terraform Lifecycle

Terraform's overall infrastructure lifecycle can be understood as:

```text
             WRITE
               |
               v
        Terraform Code
               |
               v
             INIT
               |
               v
           VALIDATE
               |
               v
             PLAN
               |
               v
           REVIEW PLAN
               |
               v
             APPLY
               |
               v
      Infrastructure Created
               |
               v
        Infrastructure Exists
               |
               v
        Configuration Changes
               |
               v
             PLAN
               |
               v
             APPLY
               |
               v
      Infrastructure Updated
               |
               v
            DESTROY
               |
               v
      Infrastructure Removed
```

---

# 22. Complete Terraform Workflow

HashiCorp's core workflow can be summarized as:

```text
WRITE → PLAN → APPLY
```

Initialization is required before the main workflow.

A practical workflow is:

```text
                Write Configuration
                        |
                        v
                terraform init
                        |
                        v
               terraform fmt
                        |
                        v
             terraform validate
                        |
                        v
                terraform plan
                        |
                        v
                   Review
                        |
                        v
               terraform apply
                        |
                        v
                  Infrastructure
```

HashiCorp documents initialization, planning, and applying as the core Terraform workflow.

---

# 23. `terraform init`

Command:

```bash
terraform init
```

This is normally the first Terraform command after creating or cloning a configuration.

It prepares the working directory.

Initialization can:

* Configure the backend
* Download providers
* Download modules
* Prepare the working directory
* Create/update the dependency lock file

HashiCorp states that `terraform init` is safe to run multiple times and is required before commands such as `plan` and `apply`.

---

## Example

```bash
terraform init
```

Conceptually:

```text
Terraform Configuration
        |
        v
terraform init
        |
        +---- Backend
        |
        +---- Provider
        |
        +---- Modules
        |
        +---- Lock File
        |
        v
Initialized Directory
```

---

# 24. `terraform validate`

Command:

```bash
terraform validate
```

It checks whether the Terraform configuration is syntactically valid and internally consistent.

Example:

```hcl
resource "aws_instance" "web" {
  instance_type = "t2.micro"
}
```

If there is a configuration error, Terraform can report it.

Important:

`terraform validate` does **not** prove that AWS itself will accept or successfully execute every operation.

HashiCorp specifically notes that validation checks the configuration rather than remote services or provider APIs.

---

# 25. `terraform fmt`

Command:

```bash
terraform fmt
```

It formats Terraform files into Terraform's standard style.

Example:

```bash
terraform fmt
```

This is useful before committing code to Git.

A common workflow:

```bash
terraform fmt
terraform validate
terraform plan
```

HashiCorp recommends `terraform fmt` for consistent formatting and notes that it works well as a pre-commit step.

---

# 26. `terraform plan`

Command:

```bash
terraform plan
```

This is one of the most important commands.

Terraform evaluates:

```text
Configuration
      +
Current Infrastructure / State
      ↓
Terraform Plan
```

The plan shows what Terraform intends to change.

Example:

```text
Plan: 1 to add, 0 to change, 0 to destroy.
```

Symbols commonly seen:

```text
+  create
~  update
-  destroy
-/+ replace
```

Example:

```text
+ aws_instance.web
```

means Terraform plans to create the resource.

Important:

```bash
terraform plan
```

does **not** normally modify the real infrastructure.

HashiCorp describes `plan` as a preview of the changes required to reach the desired state.

---

# 27. `terraform apply`

Command:

```bash
terraform apply
```

This actually performs the planned infrastructure changes.

Typical workflow:

```text
terraform plan
      |
      v
Review
      |
      v
terraform apply
      |
      v
Approval
      |
      v
Infrastructure Changes
```

Terraform normally creates a plan and asks for approval when using `terraform apply` without a saved plan file.

HashiCorp describes `apply` as executing the operations proposed by a Terraform plan.

---

## Auto approve

```bash
terraform apply -auto-approve
```

This skips the interactive approval.

Use this carefully, especially in production.

---

# 28. `terraform destroy`

Command:

```bash
terraform destroy
```

This destroys resources managed by the current Terraform configuration.

Example:

```text
Terraform
   |
   v
terraform destroy
   |
   v
EC2 deleted
VPC deleted
Security Group deleted
etc.
```

HashiCorp documents `terraform destroy` as a convenience form of destroy-mode apply.

---

## Safe approach

First:

```bash
terraform plan -destroy
```

Review the result.

Then:

```bash
terraform destroy
```

---

# 29. Other Important Commands

## Show Terraform version

```bash
terraform version
```

---

## Show help

```bash
terraform -help
```

---

## Format

```bash
terraform fmt
```

---

## Validate

```bash
terraform validate
```

---

## Plan

```bash
terraform plan
```

---

## Apply

```bash
terraform apply
```

---

## Destroy

```bash
terraform destroy
```

---

## Show state

```bash
terraform show
```

---

## List resources in state

```bash
terraform state list
```

---

## Show a particular resource

```bash
terraform state show aws_instance.web
```

---

## Generate dependency graph

```bash
terraform graph
```

Terraform provides `graph` for visualizing the dependency graph.

---

# 30. Terraform Lifecycle Meta-Argument

Terraform also provides a `lifecycle` block.

Example:

```hcl
resource "aws_instance" "web" {

  lifecycle {
    create_before_destroy = true
  }

}
```

Lifecycle settings influence how Terraform creates, updates, or destroys a resource.

Common lifecycle options include:

```text
create_before_destroy
prevent_destroy
ignore_changes
```

---

## `create_before_destroy`

Normally Terraform may:

```text
Destroy old
    ↓
Create new
```

With:

```hcl
lifecycle {
  create_before_destroy = true
}
```

Terraform attempts:

```text
Create new
    ↓
Destroy old
```

This can help reduce downtime when supported by the resource/provider.

---

## `prevent_destroy`

Example:

```hcl
lifecycle {
  prevent_destroy = true
}
```

This tells Terraform to reject plans that would destroy that resource.

Useful for resources where accidental deletion would be dangerous.

---

## `ignore_changes`

Example:

```hcl
lifecycle {
  ignore_changes = [
    tags
  ]
}
```

Terraform can ignore changes to specified attributes when deciding whether to update the resource.

Use this carefully because it can intentionally create differences between Terraform configuration and real infrastructure.

---

# 31. `depends_on`

`depends_on` creates an explicit dependency.

Example:

```hcl
resource "aws_instance" "web" {

  depends_on = [
    aws_security_group.web
  ]

}
```

This tells Terraform:

```text
Security Group
      ↓
    EC2
```

Use `depends_on` when Terraform cannot infer a dependency automatically.

---

# 32. `count` vs `for_each`

Terraform can create multiple instances of a resource.

## `count`

Example:

```hcl
resource "aws_instance" "web" {
  count = 3

  ami           = "ami-xxxxxxxx"
  instance_type = "t2.micro"
}
```

Terraform creates:

```text
aws_instance.web[0]
aws_instance.web[1]
aws_instance.web[2]
```

---

## `for_each`

Example:

```hcl
resource "aws_instance" "web" {

  for_each = {
    frontend = "t2.micro"
    backend  = "t2.small"
  }

  instance_type = each.value
}
```

Resources become:

```text
aws_instance.web["frontend"]
aws_instance.web["backend"]
```

---

## Simple rule

Use:

```text
count
```

when you need multiple similar instances based mainly on quantity.

Use:

```text
for_each
```

when each instance has a meaningful key or different configuration.

---

# 33. Implicit Dependencies

Terraform can automatically detect dependencies from references.

Example:

```hcl
resource "aws_security_group" "web" {
  name = "web-sg"
}

resource "aws_instance" "web" {

  vpc_security_group_ids = [
    aws_security_group.web.id
  ]

}
```

Terraform sees:

```text
EC2 references Security Group
```

Therefore:

```text
Security Group
       ↓
      EC2
```

This is an **implicit dependency**.

---

# 34. Explicit Dependencies

Sometimes Terraform cannot determine a dependency from a direct reference.

Then:

```hcl
depends_on = [
  aws_some_resource.example
]
```

creates an explicit dependency.

---

# 35. Terraform State and Drift

## What is drift?

Drift means:

> Real infrastructure has changed outside Terraform and no longer matches Terraform's recorded/configured expectations.

Example:

Terraform says:

```text
EC2
instance_type = t2.micro
```

Someone manually changes AWS:

```text
EC2
instance_type = t3.micro
```

Now there is a difference.

```text
Terraform Configuration
        |
        | says t2.micro
        v
Terraform

        ^
        | actual t3.micro
        |
AWS
```

Terraform can detect differences during planning/refresh-related operations.

---

## Why drift is important

Terraform works best when infrastructure changes go through Terraform.

Instead of:

```text
Terraform
   +
Manual AWS Console Changes
   +
Random Scripts
```

prefer:

```text
Terraform
   ↓
Infrastructure
```

This creates a more predictable workflow.

---

# 36. Local vs Remote State

## Local State

Default simple setup:

```text
terraform.tfstate
```

stored locally.

Example:

```text
Developer Laptop
      |
      +-- Terraform Code
      |
      +-- terraform.tfstate
```

Good for:

```text
Learning
Small experiments
Personal projects
```

---

## Remote State

For teams, state is commonly stored remotely.

Conceptually:

```text
Developer A
      |
      |
Developer B
      |
      v
Remote State
      |
      v
Shared Infrastructure State
```

Remote state helps teams collaborate.

---

# 37. Terraform Backend

A backend determines where Terraform stores state and how state operations are handled.

Conceptually:

```text
Terraform
    |
    v
 Backend
    |
    v
 State Storage
```

Common backend examples include:

```text
S3
HCP Terraform
Terraform Enterprise
Azure Storage
Google Cloud Storage
```

For AWS environments, a common architecture is:

```text
Developer
    |
    v
Terraform
    |
    v
AWS Backend
    |
    v
S3
    |
    v
terraform.tfstate
```

For production/team environments, remote state is usually preferable to every engineer keeping separate local state.

---

# 38. Provider Lock File

After initialization, Terraform can create:

```text
.terraform.lock.hcl
```

This file records provider dependency selections/checksums.

Example:

```text
.terraform.lock.hcl
```

It should generally be committed to version control for reproducible provider installations.

---

# 39. Terraform Registry

Terraform has a registry containing providers and modules.

Conceptually:

```text
Terraform Registry
       |
       +---- AWS Provider
       |
       +---- Azure Provider
       |
       +---- Kubernetes Provider
       |
       +---- GitHub Provider
       |
       +---- Modules
```

Instead of building everything from scratch, you can use existing providers and modules.

---

# 40. Terraform Modules

A useful production-style structure might look like:

```text
terraform-project/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
│
└── modules/
    │
    ├── network/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── compute/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── database/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

## Module communication

Modules communicate using:

```text
Inputs
  ↓
Module
  ↓
Outputs
```

Example:

```text
Network Module
      |
      | output subnet_id
      v
Root Module
      |
      v
Compute Module
      |
      | input subnet_id
      v
EC2
```

HashiCorp describes variables, locals, and outputs as the mechanisms that make modules flexible and composable.

---

# 41. Terraform with AWS

Terraform is very commonly used with AWS.

Typical infrastructure:

```text
                    AWS
                     |
          +----------+----------+
          |                     |
         VPC                   IAM
          |
    +-----+------+
    |            |
 Subnet        Subnet
    |            |
   EC2          EC2
    |
 Security Group
    |
 Load Balancer
    |
 Database
```

Terraform can manage these resources through the AWS provider.

---

# 42. Complete AWS EC2 Example

Here is a small Terraform project.

## Project structure

```text
terraform-aws-ec2/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── .gitignore
└── README.md
```

---

## `main.tf`

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "example" {
  ami           = "ami-xxxxxxxx"
  instance_type = var.instance_type

  tags = {
    Name = "terraform-example"
  }
}
```

---

## `variables.tf`

```hcl
variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}
```

---

## `outputs.tf`

```hcl
output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.example.id
}

output "public_ip" {
  description = "EC2 public IP"
  value       = aws_instance.example.public_ip
}
```

---

## `terraform.tfvars`

```hcl
instance_type = "t2.micro"
```

---

## `.gitignore`

```gitignore
.terraform/
*.tfstate
*.tfstate.*
crash.log
crash.*.log
*.tfvars
*.tfvars.json
```

> Be careful with `.tfvars`: do not commit files containing passwords, access keys, tokens, or other secrets.

---

# 43. What Happens During `terraform apply`?

This is extremely important for understanding Terraform.

Suppose we have:

```hcl
resource "aws_instance" "example" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t2.micro"
}
```

Run:

```bash
terraform apply
```

Conceptually:

```text
                terraform apply
                       |
                       v
              Read configuration
                       |
                       v
             Load provider plugins
                       |
                       v
               Read Terraform state
                       |
                       v
             Check infrastructure
                       |
                       v
             Build dependency graph
                       |
                       v
              Calculate changes
                       |
                       v
                Create plan
                       |
                       v
                 Ask approval
                       |
                       v
                   APPROVE
                       |
                       v
              AWS Provider Plugin
                       |
                       v
                   AWS API
                       |
                       v
               Create EC2
                       |
                       v
             Update Terraform State
```

The important idea is:

```text
Terraform does NOT simply execute the `.tf` file line-by-line.
```

It evaluates the configuration, determines dependencies, compares state/current infrastructure, creates a plan, and then performs the required operations.

---

# 44. Terraform Destroy Flow

Suppose:

```text
Terraform State
      |
      v
EC2
Security Group
VPC
Subnet
```

Run:

```bash
terraform destroy
```

Terraform calculates a destroy plan.

Conceptually:

```text
terraform destroy
       |
       v
Destroy Plan
       |
       v
Dependency Graph
       |
       v
Destroy dependent resources
       |
       v
Destroy infrastructure
       |
       v
Update state
```

Dependencies matter.

For example:

```text
VPC
 ↓
Subnet
 ↓
EC2
```

The resources cannot simply be deleted in arbitrary order.

Terraform uses its dependency graph to determine an appropriate operation order.

---

# 45. Terraform in DevOps

Terraform is extremely useful in a DevOps workflow.

A typical DevOps environment might look like:

```text
Developer
    |
    v
    Git
    |
    v
CI/CD Pipeline
    |
    +----------------+
    |                |
    v                v
Terraform Plan    Tests
    |
    v
Approval
    |
    v
Terraform Apply
    |
    v
Cloud Infrastructure
```

Terraform commonly works alongside:

```text
Git
GitHub/GitLab
Jenkins
GitHub Actions
AWS
Docker
Kubernetes
Ansible
Monitoring
```

---

# 46. Terraform CI/CD

A simple CI/CD workflow:

```text
Developer
    |
    v
git push
    |
    v
GitHub
    |
    v
GitHub Actions
    |
    v
terraform fmt
    |
    v
terraform validate
    |
    v
terraform plan
    |
    v
Review
    |
    v
terraform apply
```

This creates a repeatable infrastructure deployment process.

---

# 47. Terraform vs Ansible

These tools are often confused.

## Terraform

Primarily focuses on **provisioning and managing infrastructure**.

Example:

```text
Create:
VPC
EC2
Load Balancer
Database
S3
```

---

## Ansible

Primarily focuses on **configuration and automation of systems**.

Example:

```text
Install Nginx
Install Node.js
Copy configuration
Start service
```

A simplified combination:

```text
Terraform
    |
    v
Create EC2
    |
    v
Ansible
    |
    v
Configure EC2
```

They can complement each other.

---

# 48. Terraform vs CloudFormation

Terraform:

```text
Multi-provider
        |
        +---- AWS
        +---- Azure
        +---- GCP
        +---- Kubernetes
        +---- GitHub
```

AWS CloudFormation is AWS-focused.

Terraform uses providers to interact with different platforms.

The choice between tools depends on the organization's requirements, existing ecosystem, governance, and operational model.

---

# 49. Terraform vs Docker

Terraform and Docker solve different problems.

## Terraform

Infrastructure:

```text
EC2
VPC
S3
Load Balancer
RDS
Kubernetes
```

## Docker

Application/container packaging:

```text
Application
    ↓
Docker Image
    ↓
Container
```

They can work together:

```text
Terraform
   ↓
Create AWS infrastructure
   ↓
EC2 / ECS / EKS
   ↓
Docker
   ↓
Application Container
```

---

# 50. Terraform and Kubernetes

Terraform can manage Kubernetes resources through a Kubernetes provider.

Example architecture:

```text
Terraform
    |
    v
AWS
    |
    v
EKS
    |
    v
Kubernetes
    |
    +---- Pods
    +---- Services
    +---- Deployments
```

Terraform can therefore participate in both infrastructure provisioning and certain platform-resource management workflows.

---

# 51. Terraform and AWS IAM

Terraform can also manage IAM resources.

Example:

```hcl
resource "aws_iam_role" "example" {
  name = "example-role"

  assume_role_policy = jsonencode({
    ...
  })
}
```

Conceptually:

```text
Terraform
    |
    v
AWS Provider
    |
    v
AWS IAM API
    |
    +---- Roles
    +---- Policies
    +---- Users
```

---

# 52. Terraform Project Lifecycle

A real project may go through this lifecycle:

```text
                PROJECT START
                     |
                     v
             Write Terraform
                     |
                     v
              terraform init
                     |
                     v
             terraform validate
                     |
                     v
                terraform plan
                     |
                     v
               Review changes
                     |
                     v
               terraform apply
                     |
                     v
              Infrastructure
                     |
                     v
            Application deployed
                     |
                     v
           Configuration changes
                     |
                     v
                New plan
                     |
                     v
                  Apply
                     |
                     v
            Infrastructure updated
                     |
                     v
             Project completed
                     |
                     v
                 Destroy
```

---

# 53. Terraform State: Important Commands

## List resources

```bash
terraform state list
```

Example:

```text
aws_instance.example
aws_security_group.web
```

---

## Show resource state

```bash
terraform state show aws_instance.example
```

---

## Show complete state

```bash
terraform show
```

---

## Remove resource from state

```bash
terraform state rm aws_instance.example
```

Important:

`terraform state rm` removes the Terraform state association.

It does **not necessarily destroy the real infrastructure**.

This is very different from:

```bash
terraform destroy
```

---

# 54. Import Existing Infrastructure

Suppose an EC2 instance already exists in AWS.

You want Terraform to manage it.

Conceptually:

```text
Existing AWS Resource
        |
        v
Terraform Import
        |
        v
Terraform State
        |
        v
Terraform Configuration
```

Terraform provides import functionality for associating existing infrastructure with Terraform resources.

Example:

```bash
terraform import aws_instance.example i-xxxxxxxx
```

After importing, you still need appropriate Terraform configuration describing the resource.

---

# 55. Terraform Workspaces

Terraform workspaces allow separate state instances for the same configuration.

Conceptually:

```text
Terraform Configuration
        |
        +---- dev workspace
        |
        +---- staging workspace
        |
        +---- production workspace
```

Each workspace has its own state.

However, workspaces are not automatically the right solution for every environment architecture. For larger systems, separate configurations/directories or separate state boundaries may be more appropriate.

---

# 56. Terraform Security

Terraform itself does not automatically make infrastructure secure.

You must manage:

```text
Credentials
Secrets
IAM
State
Network
Security Groups
Encryption
Access Control
```

---

## Never hardcode secrets

Avoid:

```hcl
password = "mySuperSecretPassword"
```

Instead use appropriate secret-management mechanisms and sensitive variables where suitable.

Example:

```hcl
variable "db_password" {
  type      = string
  sensitive = true
}
```

---

# 57. Terraform State Security

Remember:

```text
terraform.tfstate
```

may contain sensitive infrastructure information.

Therefore:

```text
DO NOT blindly upload terraform.tfstate to GitHub.
```

Use:

```gitignore
*.tfstate
*.tfstate.*
```

For team environments, use an appropriate remote state solution with access control.

---

# 58. Terraform Best Practices

## 1. Use Git

Store Terraform code in version control.

```text
Terraform
   ↓
Git
   ↓
GitHub
```

---

## 2. Use `.terraform.lock.hcl`

Commit the provider lock file.

---

## 3. Don't commit state

Usually:

```gitignore
*.tfstate
*.tfstate.*
```

---

## 4. Don't commit secrets

Never commit:

```text
AWS Access Keys
Passwords
API Keys
Tokens
Private Keys
```

---

## 5. Run formatting

```bash
terraform fmt
```

---

## 6. Validate

```bash
terraform validate
```

---

## 7. Always review plan

```bash
terraform plan
```

before applying significant infrastructure changes.

---

## 8. Use variables

Instead of:

```hcl
instance_type = "t2.micro"
```

consider:

```hcl
instance_type = var.instance_type
```

for reusable configurations.

---

## 9. Use modules when appropriate

Don't immediately create 100 modules for a tiny project.

Start simple.

As the project grows:

```text
Simple Terraform
       ↓
Reusable components
       ↓
Modules
```

---

## 10. Use remote state for team environments

Avoid multiple engineers independently maintaining unrelated local state for the same infrastructure.

---

# 59. Common Terraform Mistakes

## Mistake 1 — Running apply without understanding the plan

Bad habit:

```bash
terraform apply -auto-approve
```

without reviewing the changes.

Better:

```bash
terraform plan
```

Review.

Then:

```bash
terraform apply
```

---

## Mistake 2 — Manually changing infrastructure

Example:

```text
Terraform manages EC2
       +
Engineer changes EC2 manually
```

This can create drift.

---

## Mistake 3 — Committing state

Never blindly commit:

```text
terraform.tfstate
```

---

## Mistake 4 — Hardcoding credentials

Never put:

```hcl
access_key = "..."
secret_key = "..."
```

directly into Git-tracked Terraform code.

Use secure authentication mechanisms.

---

## Mistake 5 — Using `depends_on` everywhere

Terraform can automatically infer many dependencies.

Don't add explicit dependencies unless they are actually required.

---

## Mistake 6 — Using `-auto-approve` carelessly

Especially dangerous in production.

---

## Mistake 7 — Not understanding destroy

Always remember:

```bash
terraform destroy
```

can remove managed infrastructure.

---

# 60. Terraform File Structure

A beginner project:

```text
terraform-project/
│
├── main.tf
├── variables.tf
├── outputs.tf
└── provider.tf
```

A more organized project:

```text
terraform-project/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── versions.tf
├── terraform.tfvars
├── .terraform.lock.hcl
├── .gitignore
└── README.md
```

Larger project:

```text
terraform-project/
│
├── environments/
│   ├── dev/
│   ├── staging/
│   └── prod/
│
├── modules/
│   ├── network/
│   ├── compute/
│   ├── database/
│   └── load-balancer/
│
└── README.md
```

---

# 61. Terraform Mental Model

The easiest way to remember Terraform is:

```text
YOU SAY:

"This is what I want."

        ↓

TERRAFORM CHECKS:

"What exists?"

        ↓

TERRAFORM COMPARES:

"What is different?"

        ↓

TERRAFORM CREATES:

"What changes are required?"

        ↓

PLAN:

"Here is what I intend to do."

        ↓

APPLY:

"Perform those changes."

        ↓

STATE:

"Remember what is being managed."
```

---

# 62. Terraform's Most Important Diagram

```text
                  ┌──────────────────────┐
                  │ Terraform Code (.tf) │
                  │                      │
                  │   Desired State      │
                  └──────────┬───────────┘
                             │
                             v
                  ┌──────────────────────┐
                  │      Terraform       │
                  │                      │
                  │  Read Configuration  │
                  │  Read State          │
                  │  Build Graph         │
                  │  Calculate Changes   │
                  └──────────┬───────────┘
                             │
                             v
                  ┌──────────────────────┐
                  │        PLAN          │
                  │                      │
                  │ + Create             │
                  │ ~ Update             │
                  │ - Destroy            │
                  └──────────┬───────────┘
                             │
                         Approval
                             │
                             v
                  ┌──────────────────────┐
                  │       APPLY          │
                  └──────────┬───────────┘
                             │
                             v
                  ┌──────────────────────┐
                  │       PROVIDER       │
                  │                      │
                  │    AWS / Azure /     │
                  │    GCP / Kubernetes  │
                  └──────────┬───────────┘
                             │
                             v
                  ┌──────────────────────┐
                  │  REAL INFRASTRUCTURE │
                  │                      │
                  │ EC2 / VPC / S3 /    │
                  │ RDS / LB / etc.      │
                  └──────────┬───────────┘
                             │
                             v
                  ┌──────────────────────┐
                  │   Terraform State    │
                  │                      │
                  │ Infrastructure ↔ ID  │
                  └──────────────────────┘
```

---

# 63. Terraform Complete Lifecycle Diagram

```text
                     ┌───────────────┐
                     │     WRITE     │
                     │   .tf files   │
                     └───────┬───────┘
                             │
                             v
                     ┌───────────────┐
                     │     INIT      │
                     │ Providers     │
                     │ Modules       │
                     │ Backend       │
                     └───────┬───────┘
                             │
                             v
                     ┌───────────────┐
                     │     FMT       │
                     └───────┬───────┘
                             │
                             v
                     ┌───────────────┐
                     │   VALIDATE    │
                     └───────┬───────┘
                             │
                             v
                     ┌───────────────┐
                     │     PLAN      │
                     │               │
                     │ Compare:      │
                     │ Desired       │
                     │ Current       │
                     │ State         │
                     └───────┬───────┘
                             │
                             v
                     ┌───────────────┐
                     │    REVIEW     │
                     └───────┬───────┘
                             │
                             v
                     ┌───────────────┐
                     │     APPLY     │
                     └───────┬───────┘
                             │
                             v
                  ┌──────────────────────┐
                  │ Real Infrastructure  │
                  └──────────┬───────────┘
                             │
                             v
                     ┌───────────────┐
                     │     STATE     │
                     └───────┬───────┘
                             │
                             │
                 Configuration changes?
                             │
                    ┌────────┴────────┐
                    │                 │
                   YES                NO
                    │                 │
                    v                 v
                  PLAN              DONE
                    │
                    v
                  APPLY
```

---

# 64. Terraform Create / Update / Destroy

Terraform manages three fundamental types of changes:

```text
             Terraform Plan
                   |
        +----------+----------+
        |          |          |
        v          v          v
      CREATE     UPDATE     DESTROY
        +          ~          -
```

Example:

```text
+ aws_instance.web
```

Create.

```text
~ aws_instance.web
```

Update.

```text
- aws_instance.web
```

Destroy.

Sometimes Terraform may need to replace a resource:

```text
-/+ aws_instance.web
```

Conceptually:

```text
Destroy old
    +
Create new
```

---

# 65. Terraform vs Imperative Scripts

Imperative approach:

```text
1. Call API
2. Create VPC
3. Call API
4. Create subnet
5. Call API
6. Create EC2
7. Call API
8. Configure security group
```

You tell the system **how** to do something.

Terraform is declarative:

```hcl
resource "aws_instance" "web" {
  instance_type = "t2.micro"
}
```

You describe **what you want**.

Terraform determines the required actions.

---

# 66. Terraform Declarative Model

Think:

```text
I want:

3 EC2 instances
1 VPC
2 subnets
1 load balancer
```

not:

```text
Create VPC
then create subnet
then call API
then create EC2
then call API
...
```

Terraform determines the required execution order using dependencies.

---

# 67. Terraform Idempotency

A useful concept is that repeatedly applying the same configuration should generally not create duplicate resources unnecessarily.

Example:

First:

```bash
terraform apply
```

creates:

```text
EC2
```

Second:

```bash
terraform apply
```

if nothing changed:

```text
No changes
```

Conceptually:

```text
Configuration
      |
      v
Terraform
      |
      v
Infrastructure already matches
      |
      v
No changes required
```

This is a major reason Terraform is useful for infrastructure automation.

---

# 68. Terraform Drift Example

Suppose Terraform created:

```text
EC2
instance_type = t2.micro
```

Someone manually changes AWS:

```text
instance_type = t3.micro
```

Now:

```text
Terraform desired state:
t2.micro

AWS:
t3.micro
```

Terraform can detect that difference during planning.

Depending on the configuration and operation, Terraform may propose changing the resource back toward the declared configuration.

The important lesson:

> Avoid making unmanaged manual changes to infrastructure that Terraform is responsible for.

---

# 69. Terraform Dependency Example

Suppose:

```text
VPC
 |
 v
Subnet
 |
 v
Security Group
 |
 v
EC2
```

Terraform can construct a graph:

```text
VPC
 |
 +----> Subnet
          |
          +----> Security Group
                     |
                     +----> EC2
```

The graph tells Terraform how resources relate.

---

# 70. Terraform Parallelism

If two resources don't depend on each other:

```text
        VPC
       /   \
      v     v
 Subnet A  Subnet B
```

Terraform may perform independent operations concurrently.

Conceptually:

```text
VPC
 |
 +------> Subnet A
 |
 +------> Subnet B
```

instead of unnecessarily doing:

```text
VPC
 ↓
Subnet A
 ↓
Subnet B
```

Terraform uses its dependency graph to determine operation ordering.

---

# 71. Terraform and Git

A common workflow:

```text
Developer
   |
   v
Terraform Code
   |
   v
terraform fmt
   |
   v
terraform validate
   |
   v
Git commit
   |
   v
GitHub
```

Another developer can clone:

```bash
git clone <repository>
```

then:

```bash
terraform init
```

and work from the same infrastructure code.

---

# 72. Example Git Workflow

```bash
git clone <repository>

cd terraform-project

terraform init

terraform fmt

terraform validate

terraform plan

terraform apply
```

After making changes:

```bash
terraform fmt
terraform validate
terraform plan
terraform apply
```

---

# 73. Terraform DevOps Roadmap

If you are learning Terraform for DevOps, follow this order:

```text
1. Linux
      ↓
2. Networking
      ↓
3. Cloud fundamentals
      ↓
4. AWS
      ↓
5. Terraform basics
      ↓
6. Terraform state
      ↓
7. Variables / Outputs
      ↓
8. Modules
      ↓
9. Remote State
      ↓
10. Terraform + Git
      ↓
11. Terraform + CI/CD
      ↓
12. Terraform + Docker
      ↓
13. Terraform + Kubernetes
      ↓
14. Infrastructure automation
```

---

# 74. What You Should Know Before Terraform

You do NOT need to know every AWS service before learning Terraform.

You should understand basic:

```text
EC2
VPC
Subnet
Security Group
IAM
S3
Region
Availability Zone
IP address
CIDR
DNS
```

And basic Linux:

```text
SSH
Files
Permissions
Processes
Networking
Services
```

Terraform then becomes much easier.

---

# 75. Terraform Learning Levels

## Level 1 — Beginner

Learn:

```text
What is Terraform?
What is IaC?
HCL
Providers
Resources
terraform init
terraform plan
terraform apply
terraform destroy
```

---

## Level 2 — Intermediate

Learn:

```text
Variables
Outputs
Locals
Data Sources
State
Backend
Dependency Graph
count
for_each
lifecycle
depends_on
```

---

## Level 3 — Advanced

Learn:

```text
Modules
Remote State
CI/CD
State Management
Provider Versioning
Workspaces
Import
Drift
Terraform Cloud / HCP Terraform
Policy/Governance
Testing
Security
```

---

# 76. Terraform Interview Questions

## Q1. What is Terraform?

Terraform is an Infrastructure as Code tool developed by HashiCorp that allows infrastructure to be defined, provisioned, changed, and managed using declarative configuration.

---

## Q2. What is IaC?

Infrastructure as Code means managing infrastructure using code/configuration rather than relying primarily on manual configuration.

---

## Q3. What is HCL?

HCL stands for HashiCorp Configuration Language and is the primary language used for Terraform configuration.

---

## Q4. What is a provider?

A provider is a Terraform plugin that allows Terraform to communicate with an external platform or service.

---

## Q5. What is a resource?

A resource represents an infrastructure object managed by Terraform.

Example:

```hcl
resource "aws_instance" "web" {
}
```

---

## Q6. What is Terraform state?

Terraform state records information Terraform uses to map configuration resources to real infrastructure objects and track their current known state.

---

## Q7. What does `terraform init` do?

It initializes a Terraform working directory and installs required providers/modules while configuring the backend.

---

## Q8. What does `terraform plan` do?

It calculates and displays proposed infrastructure changes without normally applying them.

---

## Q9. What does `terraform apply` do?

It executes the infrastructure changes proposed by Terraform's plan.

---

## Q10. What does `terraform destroy` do?

It destroys resources managed by the current Terraform configuration.

---

## Q11. What is a module?

A module is a reusable collection of Terraform configuration.

---

## Q12. What is a variable?

A variable provides configurable input to a Terraform module.

---

## Q13. What is an output?

An output exposes information from a Terraform module.

---

## Q14. What is drift?

Drift is a difference between Terraform's expected/recorded infrastructure and changes that occurred in the real infrastructure outside the normal Terraform workflow.

---

## Q15. What is `depends_on`?

It creates an explicit dependency between resources or other supported Terraform objects.

---

## Q16. What is `for_each`?

It allows Terraform to create/manage multiple resource instances based on a collection with meaningful keys.

---

## Q17. What is `count`?

It creates multiple instances based on a numeric count.

---

## Q18. What is a backend?

A backend determines where Terraform stores state and how state operations are handled.

---

# 77. Terraform Cheat Sheet

```text
Initialize:
terraform init

Format:
terraform fmt

Validate:
terraform validate

Plan:
terraform plan

Apply:
terraform apply

Apply without confirmation:
terraform apply -auto-approve

Destroy:
terraform destroy

Destroy plan:
terraform plan -destroy

Show state:
terraform show

List state resources:
terraform state list

Show one resource:
terraform state show <resource>

Terraform version:
terraform version

Terraform help:
terraform -help

Dependency graph:
terraform graph

Import:
terraform import <resource> <id>
```

---

# 78. Most Important Terraform Concepts to Remember

If you forget everything else, remember this:

```text
                    TERRAFORM
                        |
       +----------------+----------------+
       |                |                |
       v                v                v
 Configuration        State           Provider
       |                |                |
       |                |                |
       +--------+-------+                |
                |                        |
                v                        v
             PLAN --------------------> API
                |                        |
                v                        v
             APPLY -----------------> Cloud
```

And:

```text
Configuration
      ↓
Desired State
      ↓
Terraform
      ↓
Compare with current infrastructure/state
      ↓
Plan
      ↓
Apply
      ↓
Infrastructure
      ↓
State
```

---

# 79. The 10 Commands You Should Know First

For a beginner, focus on these:

```bash
terraform version
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform destroy
terraform show
terraform state list
terraform state show
```

You do not need to memorize every Terraform command immediately.

---

# 80. Simple Real-World Example

Imagine your company needs:

```text
1 VPC
2 Subnets
2 EC2 instances
1 Load Balancer
1 Database
```

Without Terraform:

```text
Engineer
   |
   +--> AWS Console
   |
   +--> Create VPC
   |
   +--> Create Subnets
   |
   +--> Create EC2
   |
   +--> Configure Load Balancer
   |
   +--> Create Database
```

With Terraform:

```text
Terraform Code
      |
      v
terraform plan
      |
      v
Review
      |
      v
terraform apply
      |
      v
AWS Infrastructure
```

Later:

```text
Change configuration
      |
      v
terraform plan
      |
      v
See exactly what Terraform proposes
      |
      v
terraform apply
```

This is the main value of Infrastructure as Code.

---

# 81. Final Terraform Mental Model

Think of Terraform as a **translator and manager between your infrastructure code and cloud APIs**.

```text
             YOU
              |
              | "I want this infrastructure"
              v
       Terraform HCL
              |
              v
          Terraform
              |
       +------+------+
       |             |
       v             v
     State        Provider
                     |
                     v
                  API
                     |
                     v
              Cloud Platform
                     |
                     v
              Real Resources
```

The most important sentence to remember:

> **Terraform allows you to describe the infrastructure you want as code, compare that desired configuration with the infrastructure Terraform manages, generate a plan of changes, and apply those changes through providers.**

---

# 82. One-Page Terraform Summary

```text
Terraform
│
├── IaC Tool
│
├── Declarative
│
├── Configuration written in HCL
│
├── Providers communicate with APIs
│
├── Resources represent infrastructure
│
├── Data sources read existing information
│
├── Variables provide inputs
│
├── Locals provide reusable expressions
│
├── Outputs expose information
│
├── Modules provide reusable configuration
│
├── State tracks managed infrastructure
│
├── Dependency graph determines ordering
│
├── Plan previews changes
│
├── Apply performs changes
│
└── Destroy removes managed resources
```

---

# 83. Terraform Core Workflow — Memorize This

```text
                 WRITE
                   ↓
              terraform init
                   ↓
              terraform fmt
                   ↓
           terraform validate
                   ↓
             terraform plan
                   ↓
                REVIEW
                   ↓
             terraform apply
                   ↓
            INFRASTRUCTURE
                   ↓
             STATE UPDATED
                   ↓
          Change configuration?
              /          \
            YES           NO
             |             |
             v             v
           PLAN           DONE
             |
             v
           APPLY
```

---

# 84. Official Documentation

For deeper reference, use the official HashiCorp Terraform documentation:

* Terraform Documentation
* Terraform Configuration Language
* Terraform CLI
* Terraform Providers
* Terraform Modules
* Terraform State
* Terraform Registry

Official documentation:

**HashiCorp Terraform Documentation**

https://developer.hashicorp.com/terraform/docs

---

# 85. Final Takeaway

Terraform is not simply a command that creates an EC2 instance.

It is an **Infrastructure as Code system** built around a few fundamental ideas:

```text
              CONFIGURATION
                    |
                    v
              DESIRED STATE
                    |
                    v
                TERRAFORM
                    |
             +------+------+
             |             |
             v             v
           STATE       PROVIDER
                           |
                           v
                         API
                           |
                           v
                    INFRASTRUCTURE
                           |
                           v
                     ACTUAL STATE
                           |
                           v
                     PLAN CHANGES
                           |
                           v
                         APPLY
```

If you understand these concepts:

1. **IaC**
2. **Declarative configuration**
3. **HCL**
4. **Providers**
5. **Resources**
6. **Data Sources**
7. **Variables**
8. **Locals**
9. **Outputs**
10. **Modules**
11. **State**
12. **Desired vs actual state**
13. **Dependency graph**
14. **Plan**
15. **Apply**
16. **Destroy**
17. **Backends**
18. **Drift**
19. **Lifecycle**
20. **CI/CD**

then you have the foundation required to move from beginner Terraform usage toward using Terraform in real DevOps environments.

---

## 🔗 HashiCorp Reference

This README is based primarily on the official HashiCorp Terraform documentation and CLI references.

* Terraform overview
* Terraform configuration language
* Terraform CLI
* `terraform init`
* `terraform validate`
* `terraform plan`
* `terraform apply`
* `terraform destroy`
* Terraform variables
* Terraform locals
* Terraform outputs
* Terraform modules
* Terraform state

**Official Terraform documentation:**
https://developer.hashicorp.com/terraform/docs

---

# ⭐ Quick Memory Trick

Remember Terraform as:

```text
WRITE
  ↓
INIT
  ↓
PLAN
  ↓
REVIEW
  ↓
APPLY
  ↓
STATE
  ↓
CHANGE
  ↓
PLAN AGAIN
  ↓
APPLY AGAIN
  ↓
DESTROY WHEN NEEDED
```

And remember:

```text
Terraform = Infrastructure as Code

HCL = Language

Provider = Talks to API

Resource = Thing Terraform manages

Data Source = Reads existing information

Variable = Input

Local = Reusable value

Output = Result

Module = Reusable Terraform code

State = Terraform's record of managed infrastructure

Plan = Preview

Apply = Execute

Destroy = Remove
```
