pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "mkushimo/phb-nginx-app"
        IMAGE_TAG = "1.0.${BUILD_NUMBER}"
    }

    stages {
        stage("Cloning Repository") {
            steps {
                git branch: 'main', url: 'https://github.com/mkushimo02/phb_nginx_app.git'
            }
        }

        stage("Build Docker Image with Docker") {
            steps {
                script {
                    sh """
                    docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} -f dockerfile .
                    """
                }
            }
        }

        stage("Push to Docker Hub") {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'jen-doc', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh """
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push ${DOCKER_IMAGE}:${IMAGE_TAG}
                        """
                    }
                }
            }
        }
        stage ("Deploy to Kubernetes"){
            steps{
                script{
                    kubeconfig(caCertificate: '''MIIDBjCCAe6gAwIBAgIBATANBgkqhkiG9w0BAQsFADAVMRMwEQYDVQQDEwptaW5p
a3ViZUNBMB4XDTI1MDIwNTAxMzkxMFoXDTM1MDIwNDAxMzkxMFowFTETMBEGA1UE
AxMKbWluaWt1YmVDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKkL
RTzwZExX4AxSuh3lIUeoF1DRqtf6yM/jFNIYXJ6ewlYTkxDzY0JwKk0qMuCrZsXE
4PTLTd6paMZI98kHX6Vh2+HiL+rbvyIZWg8CBDrzYayBJ0w3vf5QbQjkBTmQGTlJ
BL/d8sYYnH8wumPwDXeZ90Q/a+58rjSb/ULGeFaG6lRRiUT8LtIlW0F40CiNzXq7
O10+4d+Gkd70nliFzHVHxm5tSH8u80PvSXmrsRXKtbmdZU+zn4ocgi641hNgw308
+MmiY7WuAyU/9UZXL/ajjJIjaAFd+wHM/fdedcbr7LcTbpiu1urV1dUEkQfxJmbl
6SiNwdPpe26wSOnqgu0CAwEAAaNhMF8wDgYDVR0PAQH/BAQDAgKkMB0GA1UdJQQW
MBQGCCsGAQUFBwMCBggrBgEFBQcDATAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQW
BBRw8SVJNZL8avubOLMVPQhAxRGmojANBgkqhkiG9w0BAQsFAAOCAQEAeVQoPSGo
sDaLdTMObEM/hASHeJyiL0ui7QggPEJB681QgvFPvzqxUIHQvzVe2iQZY0BXLcl9
b0124Kg/bIZ0x/s+n7tphQVztcdJqbdtBtLM+Vvw2T8nfMcFMORZNGCJmRmuyx1c
V9VujvF4yFTGjSAC7xC0cJ5jBv+u2lxd/V8PAX5jAftWLnZBDU+bn6dhRwseXP2A
KIqR6sg2uYTHPjggtp8j1yfzcyrE0lYAIBIfaI+HrKJqWo/bUhGtOCWivrD+nqui
Z/+fFVRauyhL6iaJ1/PsXn+vcix+2KaopJ9XOI9HTtRK1ScbYiOdsqzEbDB1C8ev
WqLdsmuYjpwqGw==''', credentialsId: 'kubeconfig', serverUrl: 'https://127.0.0.1:56550') {
                        sh "kubectl apply -f deployment.yaml"
                }
            }
        }
    }
}
    post {
        success {
            echo "🎉 Deployment Successful! Image pushed to Docker Hub: ${DOCKER_IMAGE}:${IMAGE_TAG}"
        }
        failure {
            echo "❌ Deployment Failed! Check logs."
        }
    }
}
