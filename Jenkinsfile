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

        stage('Verify endpoints') {
            steps {
                script {
                    // Verificar o endpoint /register
                    def registerResponse = sh(script: '''
                    curl -o /dev/null -s -w "%{http_code}" -X POST -H 'Content-Type: application/json' -d '{"username": "testUser", "password": "testPass"}' http://192.168.15.100:5000/register
                    ''', returnStdout: true).trim()

                    if (registerResponse != "200") {
                        error "Failed to register user. Received status code: ${registerResponse}"
                    }
                    
                    // Verificar o endpoint /generate_qrcode
                    def qrcodeStatusCode = sh(script: '''
                    curl -o /dev/null -s -w "%{http_code}" -X POST -H 'Content-Type: application/json' -H 'x-api-key: 4920f67599cb90f818cb706c3bc9c49f' -d '{"content":"www.linkedin.com/in/caiohenrks"}' http://192.168.15.100:5000/generate_qrcode
                    ''', returnStdout: true).trim()

                    if (qrcodeStatusCode != "200") {
                        error "Failed to generate QR Code. Received status code: ${qrcodeStatusCode}"
                    }
                }
            }
        }
    
    
    }
}
