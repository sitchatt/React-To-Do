pipeline {
    agent any
    environment {
        REACT_APP_NAME = "react-app"
        DOCKER_IMAGE = "sitabjadocker/react-app"
        DOCKER_REGISTRY = "https://hub.docker.com"
        MINIKUBE_CONTEXT = "minikube"
        EMAIL_RECIPIENT = "sitabjachatterjee158@gmail.com"
        REPOSITORY = "https://github.com/sitchatt/React-To-Do.git"
    }
    stages {
        stage('Clone Repository') {
            steps {
                script {
                    try {
                        git '$REPOSITORY'
                    } catch (Exception e) {
                        currentBuild.result = 'FAILURE'
                        error "Failed to clone the repository"
                    }
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    try {
                        sh 'docker build -t $DOCKER_IMAGE .'
                    } catch (Exception e) {
                        currentBuild.result = 'FAILURE'
                        error "Docker build failed"
                    }
                }
            }
        }
        stage('Scan Image with Trivy') {
            steps {
                script {
                    try {
                        sh 'trivy image $DOCKER_IMAGE'
                    } catch (Exception e) {
                        currentBuild.result = 'FAILURE'
                        error "Trivy scan failed"
                    }
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    try {
                        sh 'docker push $DOCKER_IMAGE'
                    } catch (Exception e) {
                        currentBuild.result = 'FAILURE'
                        error "Docker push failed"
                    }
                }
            }
        }
        stage('Deploy to Minikube') {
            steps {
                script {
                    try {
                        sh 'kubectl --context=$MINIKUBE_CONTEXT apply -f kubernetes/deployment.yaml'
                        sh 'kubectl --context=$MINIKUBE_CONTEXT apply -f kubernetes/service.yaml'
                        sh 'kubectl --context=$MINIKUBE_CONTEXT apply -f kubernetes/ingress.yaml'
                    } catch (Exception e) {
                        currentBuild.result = 'FAILURE'
                        error "Kubernetes deployment failed"
                    }
                }
            }
        }
    }
    post {
        success {
            mail to: "$EMAIL_RECIPIENT",
                 subject: "Pipeline Successful",
                 body: "The pipeline has completed successfully. Your app is now deployed!"
        }
        failure {
            mail to: "$EMAIL_RECIPIENT",
                 subject: "Pipeline Failed",
                 body: "The pipeline failed during one of the steps. Please check the logs. Error: ${currentBuild.currentResult}"
        }
    }
}
