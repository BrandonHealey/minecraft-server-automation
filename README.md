# Minecraft Server Automation

This project fully automates the provisioning and configuration of a Minecraft server on AWS using **Terraform** and **Ansible**. No manual AWS Console interaction or SSH login is required.

---

## Overview

- **Infrastructure as Code**: Terraform provisions an EC2 instance, security group, and key pair.
- **Server Configuration**: Ansible installs Java, sets up the Minecraft server, and ensures it starts on reboot.
- **Zero Manual Interaction**: Everything is automated via CLI.

---

## Requirements

### Tools Needed

- [Terraform](https://developer.hashicorp.com/terraform) (v1.5+)
- [Ansible](https://docs.ansible.com/) (v2.10+)
- [AWS CLI](https://docs.aws.amazon.com/cli/) (v2.x)
- Git

### Setup AWS CLI Credentials

```bash
aws configure
```

> Provide your IAM credentials with EC2 and VPC permissions.

---

## Project Structure

```
minecraft-server-automation/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── ansible/
│   ├── setup.yml
│   └── inventory
└── README.md
```

---

## Setup Guide

### 1. Clone the Repository

```bash
git clone https://github.com/BrandonHealey/minecraft-server-automation.git
cd minecraft-server-automation
```

### 2. Provision EC2 and Networking

```bash
cd terraform
terraform init
terraform apply -var="key_name=minecraft2" -auto-approve
```

> Note the output `public_ip` of the EC2 instance.

### 3. Configure Minecraft Server

Edit the `ansible/inventory` file:

```ini
[minecraft]
<public_ip> ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/minecraft
```

Then run:

```bash
cd ../ansible
ansible-playbook -i inventory setup.yml
```

---

## 🔁 Restart & Verify

### Reboot via AWS CLI

```bash
aws ec2 reboot-instances --instance-ids <instance_id> --region us-east-1
```

### Verify with Nmap

```bash
nmap -sV -Pn -p T:25565 <public_ip>
```

---

## Join the Server

Open Minecraft and connect to:

```
<public_ip>:25565
```