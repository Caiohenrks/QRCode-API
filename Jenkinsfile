pipeline {
    agent any

    environment {
        IMAGE_NAME = 'QRCodeAPI'
        NEXUS_REPO = 'http://dockerlab:8081/repository/docker/'
        NEXUS_CREDENTIALS_ID = 'admin:051014'
    }

    stages {
        stage('Checkout from Git') {
            steps {
                git scm
            }
        }
        stage('SonarQube Analysis') {
            steps {
                script {
                    withSonarQubeEnv('Scan Sonarqube') {
                        sh """
                            sonar-scanner \
                            -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                            -Dsonar.sources=. \
                            -Dsonar.host.url=http://dockerlab:9000 \
                            -Dsonar.login=token_de_login_sonarqube
                        """
                    }
                }
            }
        }

        stage('Check if Image Exists') {
            steps {
                script {
                    def imageExists = sh(script: "docker images | grep ${IMAGE_NAME}", returnStatus: true)
                    if (imageExists == 0) {
                        echo "Image ${IMAGE_NAME} already exists. Deleting..."
                        sh "docker rmi ${IMAGE_NAME}"
                    } else {
                        echo "Image ${IMAGE_NAME} does not exist."
                    }
                }
            }
        }
        
        stage('Build Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }

        stage('Run Image') {
            steps {
                sh "docker run -d -p 5000:5000 ${IMAGE_NAME}"
            }
        }

        stage('Push to Nexus') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${NEXUS_CREDENTIALS_ID}", passwordVariable: 'NEXUS_PASSWORD', usernameVariable: 'NEXUS_USERNAME')]) {
                    sh "docker login ${NEXUS_REPO} -u ${NEXUS_USERNAME} -p ${NEXUS_PASSWORD}"
                    sh "docker tag ${IMAGE_NAME} ${NEXUS_REPO}:${IMAGE_NAME}"
                    sh "docker push ${NEXUS_REPO}:${IMAGE_NAME}"
                }
            }
        }
    }
}
