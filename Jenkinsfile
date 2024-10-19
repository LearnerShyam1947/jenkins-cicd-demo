pipeline {
    agent any

    tools {
        maven 'maven-3.9.9'
        jdk 'jdk-17'
    }

    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub_credentials' 
        DOCKER_IMAGE_NAME = 'karnamshyam1947/springboot-jenkins-cicd-demo' 
    }

    stages {

        stage('GitHub Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/LearnerShyam1947/jenkins-cicd-demo' 
            }
        }

        stage('Maven Check') {
            steps {
                sh 'mvn --version' 
            }
        }
        
        stage('Build Spring Boot Project') {
            steps {

                
                sh "mvn -Dmaven.test.failure.ignore=true -DskipTests clean package"
            }
        }

        stage('SonarQube analysis'){
            steps{
                withSonarQubeEnv('SonaeQubeServer') { 
                    // If you have configured more than one global server connection, you can specify its name
                    // sh "${scannerHome}/bin/sonar-scanner"
                    // sh "mvn sonar:sonar"
                    sh "mvn sonar:sonar  "
                }
            }

            // environment {
            //     SCANNER_HOME = tool 'SonarQubeScanner'
            // }
            // steps {
            //     withSonarQubeEnv('SonaeQubeServer') {
            //         sh" ${SCANNER_HOME}}/bin/sonar-scanner \
            //         -Dsonar.projectKey=Jenkins-cicd-demo \
            //         -Dsonar.projectName='Jenkins-cicd-demo' \
            //         -Dsonar.sources=. "
            //     }
            // }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    
                    sh "docker build -t ${DOCKER_IMAGE_NAME}:latest ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    
                    withCredentials([
                        usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", 
                        passwordVariable: 'DOCKER_PASSWORD', 
                        usernameVariable: 'DOCKER_USERNAME')
                    ]) {
                        sh "echo \$DOCKER_PASSWORD | docker login -u \$DOCKER_USERNAME --password-stdin"
                    }

                    
                    sh "docker push ${DOCKER_IMAGE_NAME}:latest"
                }
            }
        }
    }

    post {
        success {
            echo 'Build and push to Docker Hub was successful!'
        }
        failure {
            echo 'Build and push to Docker Hub was not successful!'
        }
    }
}
