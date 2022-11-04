#!/bin/bash
yum update -y
yum install wget unzip -y
echo "Installing Jenkins"
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum upgrade
amazon-linux-extras install java-openjdk11 -y
yum install jenkins -y
systemctl enable jenkins
sudo systemctl start jenkins
systemctl status jenkins
echo "Installing Terraform"
cd /tmp
wget https://releases.hashicorp.com/terraform/1.3.4/terraform_1.3.4_linux_386.zip
unzip terraform_1.3.4_linux_386.zip
sudo mv terraform /usr/bin/
terraform -v
echo "Done"
exit 0