pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS_ID = 'hub'
        SONARQUBE_SERVER = 'SonarQubeServer'
        DOCKERHUB_REPO = 'nikome1/dev-ops-demo'
        DOCKER_IMAGE_TAG = 'ver1'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/ADirin/sep2_week5_inclass_s2.git'
            }
        }

        stage('Build') {
            steps {
                bat 'mvn clean install'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withCredentials([string(credentialsId: 'SONAR_TOKEN', variable: 'SONAR_TOKEN')]) {
                    withSonarQubeEnv('SonarQubeServer') {
                        bat """
                            sonar-scanner ^
                            -Dsonar.projectKey=devops-demo ^
                            -Dsonar.sources=src ^
                            -Dsonar.projectName=DevOps-Demo ^
                            -Dsonar.host.url=http://localhost:9000 ^
                            -Dsonar.token=${env.SONAR_TOKEN} ^
                            -Dsonar.java.binaries=target/classes
                        """
                    }
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
