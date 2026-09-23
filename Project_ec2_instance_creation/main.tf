provider "aws" {
    region = "ap-south-1"  # Set your desired AWS region
}

resource "aws_instance" "example" {
    ami = "ami-01a00762f46d58321"  # Specify an appropriate AMI ID
    instance_type = "t3.micro"
    subnet_id= "subnet-0e2a25695eceaab33"
    key_name ="terraform_key"
} 
