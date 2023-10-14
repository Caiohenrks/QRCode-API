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

        stage('Test Endpoints') {
            steps {
                script {
                    sleep(time: 10, unit: 'SECONDS')
                    
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
                    
                    // Parse the response to get the api_key
                    def slurper = new JsonSlurper()
                    def jsonResponse = slurper.parseText(registerResponse.content)
                    def apiKey = jsonResponse.api_key
                    
                    // Teste para o endpoint Generate QRCode
                    def qrcodeResponse = httpRequest(
                        url: 'http://192.168.15.100:5000/generate_qrcode',
                        contentType: 'APPLICATION_JSON',
                        httpMode: 'POST',
                        headers: [[name: 'x-api-key', value: apiKey]],
                        requestBody: '{"content": "www.linkedin.com/in/caiohenrks"}'
                    )
                    
                    if (qrcodeResponse.status != 200 && qrcodeResponse.status != 401) {
                        error "Failed to generate QRCode. Response code: ${qrcodeResponse.status}"
                    }
                }
            }
        }
    }
}
