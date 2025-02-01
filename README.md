Below is a `README.md` file for your GitHub repository that explains the provided Jenkins pipeline code. It includes a description of the pipeline, its stages, and the infrastructure setup. I've also included placeholders for infrastructure images.

---

# Jenkins Pipeline for Building and Deploying a Dockerized Nginx Application

This repository contains a Jenkins pipeline script for automating the build and deployment of a Dockerized Nginx application. The pipeline uses Docker Compose to build the image, tags it with a version, and pushes it to Docker Hub.

---

## Pipeline Overview

The pipeline is defined in a `Jenkinsfile` and consists of the following stages:

1. **Cloning Repository**: Clones the source code from the specified GitHub repository.
2. **Build Docker Image with Docker Compose**: Builds the Docker image using Docker Compose and tags it with a version.
3. **Push to Docker Hub**: Pushes the tagged Docker image to Docker Hub..

---

## Pipeline Code

```groovy
pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "mkushimo/phb-nginx-app"
        IMAGE_TAG = "1.0.${BUILD_NUMBER}"
    }

    stages {
        stage("Cloning Repository") {
            steps {
                git branch: 'main', url: 'https://github.com/mkushimo02/phbapp.git'
            }
        }

        stage("Build Docker Image with Docker Compose") {
            steps {
                script {
                    sh """
                    docker-compose build
                    docker tag nginx:stable-perl ${DOCKER_IMAGE}:${IMAGE_TAG}
                    """
                }
            }
        }

        stage("Push to Docker Hub") {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-cred', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh """
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push ${DOCKER_IMAGE}:${IMAGE_TAG}
                        """
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
```

---

## Pipeline Stages

### 1. Cloning Repository
- **Purpose**: Fetches the source code from the GitHub repository.
- **Tools Used**: Git.
- **Branch**: `main`.
- **Repository URL**: `https://github.com/mkushimo02/phbapp.git`.

### 2. Build Docker Image with Docker Compose
- **Purpose**: Builds the Docker image using Docker Compose and tags it with a version.
- **Tools Used**: Docker Compose (`docker-compose build`), Docker (`docker tag`).
- **Image Name**: `mkushimo/phb-nginx-app`.
- **Image Tag**: `1.0.<BUILD_NUMBER>` (e.g., `1.0.1`, `1.0.2`, etc.).

### 3. Push to Docker Hub
- **Purpose**: Pushes the tagged Docker image to Docker Hub.
- **Tools Used**: Docker (`docker login`, `docker push`).
- **Credentials**: Stored in Jenkins with ID `docker-cred`.

---

## Infrastructure Setup

The pipeline assumes the following infrastructure setup:

1. **Jenkins Server**: Hosts the Jenkins pipeline and orchestrates the build and deployment process.
2. **GitHub Repository**: Contains the source code for the application.
3. **Docker Hub**: Stores the Docker images.
4. **Docker Compose**: Used to build and manage the Docker image.

### Infrastructure Diagram

Below is a high-level diagram of the infrastructure:

---
![Dev-Muisi-Page-7](https://github.com/user-attachments/assets/10dd6281-7573-4686-8b85-864513b15284)

---

## Prerequisites

To run this pipeline, ensure the following are set up:

1. **Jenkins**: Installed and configured with the necessary plugins (Docker, Docker Pipeline, Git).
2. **Docker**: Installed and configured on the Jenkins server.
3. **Docker Compose**: Installed on the Jenkins server.
4. **GitHub Repository**: Accessible by Jenkins.
5. **Docker Hub Account**: Credentials stored in Jenkins.

---

## How to Use

1. Clone this repository or copy the `Jenkinsfile` into your project.
2. Configure Jenkins to use the `Jenkinsfile` as the pipeline script.
3. Ensure all prerequisites are met.
4. Run the pipeline in Jenkins.

---

## Screenshots

### Jenkins Pipeline Success
![image](https://github.com/user-attachments/assets/ddccce08-3321-43b9-b992-4e9ae0a2eca9)

*Successful pipeline execution with the image pushed to Docker Hub.*

### Docker Hub Image
![image](https://github.com/user-attachments/assets/5a49ffe2-9733-4012-89bf-c0e802852021)

*The Docker image tagged and pushed to Docker Hub.*

---

## Notes

- Replace `mkushimo/phb-nginx-app` with your Docker Hub repository name.
- Ensure the `docker-cred` credentials ID in Jenkins matches your Docker Hub credentials.
- Update the `git` URL in the `Cloning Repository` stage to match your repository.

---

## Example Output

After running the pipeline, you will see the following:
- A Docker image tagged with the build number (e.g., `mkushimo/phb-nginx-app:1.0.1`).
- The image will be available in your Docker Hub repository.

---

Feel free to customize this README to suit your project's needs. Let me know if you need further assistance!
