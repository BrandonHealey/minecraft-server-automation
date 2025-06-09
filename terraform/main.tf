provider "aws" {
  region = "us-east-1"
}

variable "key_name" {
  description = "The name of the existing EC2 Key Pair to use"
  type        = string
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "minecraft_sg" {
  name        = "minecraft-sg"
  description = "Allow Minecraft traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow Minecraft"
    from_port   = 25565
    to_port     = 25565
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

resource "aws_instance" "minecraft" {
  ami                    = "ami-07d9b9ddc6cd8dd30" # Ubuntu 22.04 LTS in us-east-1
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.minecraft_sg.id]

  tags = {
    Name = "MinecraftServer"
  }
}

output "public_ip" {
  value = aws_instance.minecraft.public_ip
}
