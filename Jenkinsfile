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
                post {
                        success {
                            echo "🎉 Deployment Successful! Image pushed to Docker Hub: ${DOCKER_IMAGE}:${IMAGE_TAG}"
                }
                        failure {
                            echo "❌ Deployment Failed! Check logs."
                        }
                }    
}
}
