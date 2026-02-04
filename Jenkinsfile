pipeline {
    agent any

    parameters {
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Select the action to perform')
    }

    triggers {
        pollSCM('* * * * *') // Runs every minute
    }

    environment {
        SLACKCHANNEL = '12th-january-2026-pet-adoption-auto-discovery-project-eu-team'
        SLACKCREDENTIALS = credentials('slack-cred')
    }

    stages {
        stage('IAC Scan') {
            steps {
                script {
                    sh 'pip install pipenv'
                    sh 'pipenv run pip install checkov'
                    def checkovStatus = sh(script: 'pipenv run checkov -d . -o cli --output-file checkov-results.txt --quiet', returnStatus: true)
                    junit allowEmptyResults: true, testResults: 'checkov-results.txt' 
                }
            }
        }

        stage('Install Terraform') {
            steps {
                sh '''
                  set -e
                  TERRAFORM_VERSION=1.6.0
                  ARCH=$(uname -m)
                  OS=$(uname -s | tr '[:upper:]' '[:lower:]')

                  if [ "$ARCH" = "x86_64" ]; then
                      ARCH=amd64
                  elif [ "$ARCH" = "aarch64" ]; then
                      ARCH=arm64
                  fi

                  echo "Installing Terraform v$TERRAFORM_VERSION for $OS-$ARCH..."
                  curl -fsSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_${OS}_${ARCH}.zip -o terraform.zip
                  unzip -o terraform.zip
                  sudo mv terraform /usr/local/bin/
                  rm terraform.zip

                  terraform version
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Format') {
            steps {
                sh 'terraform fmt --recursive'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }

        stage('Terraform Action') {
            steps {
                script {
                    sh "terraform ${params.action} -auto-approve"
                }
            }
        }
    }

    post {
        always {
            script {
                slackSend(
                    channel: env.SLACKCHANNEL,
                    tokenCredentialId: env.SLACKCREDENTIALS,
                    color: currentBuild.result == 'SUCCESS' ? 'good' : 'danger',
                    message: "Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL}) has been completed."
                )
            }
        }
        failure {
            slackSend(
                channel: env.SLACKCHANNEL,
                tokenCredentialId: env.SLACKCREDENTIALS,
                color: 'danger',
                message: "Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' has failed. Check console output at ${env.BUILD_URL}."
            )
        }
        success {
            slackSend(
                channel: env.SLACKCHANNEL,
                tokenCredentialId: env.SLACKCREDENTIALS,
                color: 'good',
                message: "Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' completed successfully. Check console output at ${env.BUILD_URL}."
            )
        }
    }
}
