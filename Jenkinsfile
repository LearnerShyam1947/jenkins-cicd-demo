pipeline {
    agent any

    tools {
        maven 'maven-3.9.9'
        jdk 'jdk-17'
        nodejs 'nodejs-23.0.0'
    }

    environment {
        DOCKER_CREDENTIALS_ID = 'jenkins_dockerhub_authentication' // Your Docker Hub credentials ID in Jenkins
        DOCKER_IMAGE_NAME = 'karnamshyam1947/springboot-jenkins-cicd-demo' // Update with your Docker Hub username and image name
    }

    stages {
        stage('GitHub Checkout') {
            steps {
                git branch: 'master', credentialsId: 'Jenkins_github_authentication', url: 'https://github.com/LearnerShyam1947/jenkins-cicd-demo' 
            }
        }

        stage('Maven Check') {
            steps {
                sh 'mvn --version' 
            }
        }
        
        stage('Build Spring Boot Project') {
            steps {
                sh 'mvn clean package -DskipTests' 
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    sh "docker build -t ${DOCKER_IMAGE_NAME}:latest ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Login to Docker Hub
                    withCredentials([
                        usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", 
                        passwordVariable: 'DOCKER_PASSWORD', 
                        usernameVariable: 'DOCKER_USERNAME')
                    ]) {
                        sh "echo \$DOCKER_PASSWORD | docker login -u \$DOCKER_USERNAME --password-stdin"
                    }

                    // Push the Docker image
                    sh "docker push ${DOCKER_IMAGE_NAME}:latest"
                }
            }
        }
    }

    post {
        success {
            echo 'Build and push to Docker Hub was successful!'
        }
    }
}
