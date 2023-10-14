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

        stage('Test Endpoints') {
            steps {
                script {
                    // Teste para o endpoint Register
                    def registerResponse = httpRequest(
                        url: 'http://192.168.15.100:5000/register',
                        contentType: 'APPLICATION_JSON',
                        httpMode: 'POST',
                        requestBody: '{"username": "testUser", "password": "testPass"}'
                    )
                    if (registerResponse.status != 200) {
                        error "Failed to register. Response code: ${registerResponse.status}"
                    }


                    
                }
            }
        }
    
    }
}
