pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key')  // Add your AWS access key ID
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key') // Add your AWS secret access key
        DOCKER_CREDENTIALS = credentials('docker-credentials') // Add your Docker registry credentials
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Checkout the code from the repository
                git 'https://github.com/your-repo/terraform.git' // Update with your repo URL
            }
        }

        stage('Terraform Init') {
            steps {
                // Initialize Terraform
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                // Generate and show an execution plan
                sh 'terraform plan'
            }
        }

        stage('Terraform Apply') {
            steps {
                // Apply the changes required to reach the desired state of the configuration
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Build Microservice') {
            steps {
                // Build Docker image for your microservice
                sh 'docker build -t my-microservice .'
            }
        }

        stage('Push Docker Image') {
            steps {
                // Log in to Docker registry
                sh "echo $DOCKER_CREDENTIALS_PSW | docker login -u $DOCKER_CREDENTIALS_ID --password-stdin"
                
                // Push Docker image
                sh 'docker tag my-microservice:latest your-docker-repo/my-microservice:latest'
                sh 'docker push your-docker-repo/my-microservice:latest'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                // Update Kubernetes deployment with the new image
                sh 'kubectl set image deployment/my-deployment my-container=your-docker-repo/my-microservice:latest'
                sh 'kubectl rollout status deployment/my-deployment'
            }
        }

        stage('Health Check') {
            steps {
                // Perform health check on the deployed microservice
                script {
                    def healthCheck = sh(script: 'curl --silent --fail http://my-service-url/health', returnStatus: true)
                    if (healthCheck != 0) {
                        error('Health check failed!')
                    }
                }
            }
        }
    }

    post {
        success {
            // Actions to perform on success (e.g., notify via Slack)
            echo 'Pipeline completed successfully!'
        }
        failure {
            // Actions to perform on failure (e.g., notify via Slack)
            echo 'Pipeline failed!'
        }
    }
}
