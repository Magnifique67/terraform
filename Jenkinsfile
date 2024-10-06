pipeline {
  agent any
  
  stages {
    stage('Checkout') {
      steps {
        git 'https://github.com/Magnifique67/terraform.git'
      }
    }

    stage('Terraform Init') {
      steps {
        sh 'cd infrastructure/terraform && terraform init'
      }
    }

    stage('Terraform Apply') {
      steps {
        sh 'cd infrastructure/terraform && terraform apply -auto-approve'
      }
    }

    stage('Build and Deploy Microservice') {
      steps {
        sh 'docker build -t microservice-image .'
        sh 'docker run -d -p 80:80 microservice-image'
      }
    }
  }
}
