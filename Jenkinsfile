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
                    def response = sh(script: '''
                    curl -s -X POST -H "Content-Type: application/json" -d '{"username": "testUser", "password": "testPass"}' http://192.168.15.100:5000/register
                    ''', returnStdout: true).trim()

                    def expectedResponse = '{"message": "Username already taken!"}'
                    if (response != expectedResponse) {
                        error "Response is incorrect!"
                    }
                        
                    def statusCode = sh(script: '''
                    curl -o /dev/null -s -w "%{http_code}" -X POST -H "Content-Type: application/json" -H "x-api-key: 4920f67599cb90f818cb706c3bc9c49f" -d '{"content":"www.linkedin.com/in/caiohenrks"}' http://192.168.15.100:5000/generate_qrcode
                    ''', returnStdout: true).trim()

                    if (statusCode != "200") {
                        error "Failed to generate QR Code. Received status code: ${statusCode}"
                    }
                }
            }
        }
    
    
    }
}
