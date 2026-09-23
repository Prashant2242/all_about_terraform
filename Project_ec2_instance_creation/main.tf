provider "aws" {
    region = "ap-south-1"  # Set your desired AWS region
}

resource "aws_instance" "example" {
    ami           = "ami-01a00762f46d584a1"  # Specify an appropriate AMI ID
    instance_type = "t3.micro"
    subnet_id= "subnet-0e5a25695eceaab51"
    key_name ="terraform_key"
} 