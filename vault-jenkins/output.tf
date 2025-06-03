output "jenkins_public_ip" {
  value = aws_instance.jenkins-server.public_ip
}

output "vault_public_ip" {
  value = aws_instance.vault-server.public_ip
}