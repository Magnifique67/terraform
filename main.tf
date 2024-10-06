provider "aws" {
  region  = "eu-north-1"
  profile = "S3ReadOnlyUser"
}

resource "aws_instance" "microservice_instance" {
  ami           = "ami-08eb150f611ca277f"  # Replace with a valid AMI for eu-north-1
  instance_type = "t3.micro"

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name # Associate the IAM instance profile with the EC2 instance

  tags = {
    Name = "MicroserviceInstance"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow inbound HTTP traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "S3ReadOnlyUser"  # Use the name of your existing instance profile
  role = "EC2DynamoDBRole"  # Use the name of your existing IAM role
}
