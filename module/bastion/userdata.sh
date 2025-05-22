#!/bin/bash
# Setup SSH Key
mkdir -p /home/ubuntu/.ssh
echo "${privatekey}" > /home/ubuntu/.ssh/id_rsa
chmod 400 /home/ubuntu/.ssh/id_rsa
chown ubuntu:ubuntu /home/ubuntu/.ssh/id_rsa

# Set hostname
hostnamectl set-hostname bastion

# install amazon-ssm-agent
sudo dnf install -y https://s3."${region}".amazonaws.com/amazon-ssm-"${region}"/latest/linux_amd64/amazon-ssm-agent.rpm
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm" -o "session-manager-plugin.rpm"
sudo yum install -y session-manager-plugin.rpm

# Installing awscli
sudo yum install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
sudo ln -svf /usr/local/bin/aws /usr/bin/aws

# Install New Relic
curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash && \
sudo NEW_RELIC_API_KEY="${nr-key}" \
     NEW_RELIC_ACCOUNT_ID="${nr-acc-id}" \
     NEW_RELIC_REGION=EU \
     /usr/local/bin/newrelic install -y