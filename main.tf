# Declare the variables for AWS credentials
variable "AWS_ACCESS_KEY_ID" {
  description = "AWS Access Key ID"
  type        = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS Secret Access Key"
  type        = string
}

provider "aws" {
  region     = "eu-north-1"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}

resource "aws_instance" "microservice_instance" {
  ami           = "ami-08eb150f611ca277f"  # Replace with a valid AMI for eu-north-1
  instance_type = "t3.micro"

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name  # Associate the IAM instance profile

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

# Optionally, create an Elastic IP and associate it with the instance
resource "aws_eip" "instance_eip" {
  instance = aws_instance.microservice_instance.id
}

output "instance_id" {
  value = aws_instance.microservice_instance.id
}

output "instance_public_ip" {
  value = aws_eip.instance_eip.public_ip
}
