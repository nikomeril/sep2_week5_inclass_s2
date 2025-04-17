pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS_ID = 'hub'
        DOCKERHUB_REPO = 'nikome1/devops-demo'
        DOCKER_IMAGE_TAG = 'ver1'
        SONARQUBE_SERVER = 'SonarQubeServer'  // The name of the SonarQube server configured in Jenkins
        SONAR_TOKEN = 'squ_d4c7d7154a5445aa9bae67771f1c8696e7b2c4b8' // Store the token securely (or use credentials)
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/nikome/sep2_week5_inclass_s2.git'
            }
        }

        stage('Build') {
            steps {
                bat 'mvn clean install'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQubeServer') {
                    bat """
                        sonar-scanner ^
                        -Dsonar.projectKey=devops-demo ^
                        -Dsonar.sources=src ^
                        -Dsonar.projectName=DevOps-Demo ^
                        -Dsonar.host.url=http://localhost:9000 ^
                        -Dsonar.login=${env.SONAR_TOKEN} ^
                        -Dsonar.java.binaries=target/classes
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${env.DOCKERHUB_REPO}:${env.DOCKER_IMAGE_TAG}")
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', env.DOCKERHUB_CREDENTIALS_ID) {
                        docker.image("${env.DOCKERHUB_REPO}:${env.DOCKER_IMAGE_TAG}").push()
                    }
                }
            }
        }
    }
}
