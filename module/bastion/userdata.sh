#!/bin/bash
# Setup SSH Key
mkdir -p /home/ubuntu/.ssh
echo "${privatekey}" > /home/ubuntu/.ssh/id_rsa
chmod 400 /home/ubuntu/.ssh/id_rsa
chown ubuntu:ubuntu /home/ubuntu/.ssh/id_rsa

# Set hostname
hostnamectl set-hostname bastion

# Install CloudWatch Agent (Ubuntu)
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
dpkg -i amazon-cloudwatch-agent.deb
INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)




# Install New Relic
curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash && \
sudo NEW_RELIC_API_KEY="${nr-key}" \
     NEW_RELIC_ACCOUNT_ID="${nr-acc-id}" \
     NEW_RELIC_REGION=EU \
     /usr/local/bin/newrelic install -y