import groovy.json.JsonSlurper

pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }  
        
        stage('SonarQube analysis') {
            steps {
                sh '/opt/sonar-scanner/bin/sonar-scanner -Dsonar.projectKey=QRCODE-API -Dsonar.sources=. -Dsonar.host.url=http://dockerlab:9000 -Dsonar.login=sqp_f677840b9cb916dcb525fbc1b0b2e0dc5c9fd8fc'
            }
        }

        stage('Docker build') {
            steps {
                sh 'docker rm -f qrcodeapi || true'
                sh 'docker rmi -f qrcodeapi || true'
                sh 'docker build -t qrcodeapi .'
                sh 'docker run -d -p 5000:5000 --name qrcodeapi qrcodeapi'
            }
        }

        stage('Push Nexus') {
            steps {
                script {
                    def nexusUrl = '192.168.15.100:8082'
                    def repoName = 'docker'
                    def nexusCredentials = 'admin:051014'
                    
                    sh "docker login -u admin -p 051014 ${nexusUrl}"
                    sh "docker tag qrcodeapi ${nexusUrl}/${repoName}:latest"
                    sh "docker push ${nexusUrl}/${repoName}:latest"
                }
            }
        }

        stage('Test Endpoints') {
            steps {
                sleep(time: 10, unit: 'SECONDS')
                sh 'sudo chmod +x test_endpoints.sh'
                sh './test_endpoints.sh'
            }
        }
    }
}
