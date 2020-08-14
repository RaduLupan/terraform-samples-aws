# This template ilustrates the use of remote-exec provisioners and deploys the following resources in AWS:
# 1 x Security Group with ingress rule that allows SSH from anywhere
# 1 x local SSH key pair for the Terraform client to connect to the instance over SSH
# 1 x Key Pair consisting from the public key generated locally
# 1 x EC2 instance with a provisioner of type remote-exec

terraform {
  required_version = "~> 0.12"  
}

provider "aws" {
    version = "~> 2.0"
    region  = var.region
}

resource "aws_security_group" "instance" {
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Uses tls provider to generate private key in Terraform. In real-world usage, you should manage SSH keys outside of Terraform.
resource "tls_private_key" "example" {
    algorithm = "RSA"
    rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
    public_key = tls_private_key.example.public_key_openssh
}

resource "aws_instance" "example" {
    ami                    = "ami-0bbe28eb2173f6167"
    instance_type          = "t3.micro"
    vpc_security_group_ids = [aws_security_group.instance.id]
    key_name               = aws_key_pair.generated_key.key_name

    # By default, it is a creation-time provisioner so it runs during terraform apply and ONLY during the initial creation of the resource.
    # The provisioner will not run on any subsequent calls to terraform apply. If you set the when="destroy" argument on a provisioner it will
    # be a destroy-time provisioner which will run after you run terraform destroy and just before the resource is deleted.
    # You can specify multiple provisioners on the same resource and Terraform will run them one at a time, in order, from top to bottom.
    # You can use on_failure argument to instruct Terraform how to handle errors from the provisioner: if set to "continue", it will ignore the error,
    # if set to "abort", Terraform will abort the creation or destruction. 
    provisioner "remote-exec" {
        inline = ["echo \"Hello, World from $(uname -smp)\""]
    }
    
    # This connection block tells Terraform to connect to the EC2 instance's public IP address using SSH with ubuntu as the user name.
    # Note the use of the self keyword to set the host parameter. You can use self solely in connection and provisioner blocks to refer
    # to an output ATTRIBUTE of a surrounding resource (standard syntax aws_instance_.example.<ATTRIBUTE> would give a circular dependency error).
    connection {
        type        = "ssh"
        host        = self.public_ip
        user        = "ubuntu"
        private_key = tls_private_key.example.private_key_pem
    }
}

# Provisioners with null_resource let you run scripts as part of the Terraform life cycle, but without being attached to any real resource.
resource "null_resource" "example" {

    # Use UUID to force this null_resource to be created on every call to 'terraform apply'.
    triggers = {
        uuid = uuid()
    }
    provisioner "local-exec" {
        command = "echo \"Hello, World from $(uname -smp)\""
    }
}