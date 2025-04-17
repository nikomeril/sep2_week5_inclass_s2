pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS_ID = 'hub'
        SONARQUBE_SERVER = 'SonarQubeServer'
        SONAR_TOKEN = credentials('sonarqube') // Jenkins credential ID for SonarQube token
        DOCKER_IMAGE = 'yourdockerhubusername/devops-demo:latest'
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

        stage('Docker Build & Push') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', env.DOCKERHUB_CREDENTIALS_ID) {
                        def image = docker.build("${env.DOCKER_IMAGE}")
                        image.push()
                    }
                }
            }
        }
    }
}
