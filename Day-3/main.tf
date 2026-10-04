provider "aws" {
  region = "ap-south-1"
}

module "ec2_instance" {
  source = "./modules/ec2_instance"
  ami_value = "ami-054a0c53c*****" # replace this
  instance_type_value = "t3.micro"

}
