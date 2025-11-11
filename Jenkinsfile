pipeline {
    agent any

    environment {
        AWS_REGION     = "us-east-2"
        DOCKERHUB_USER = "muthuraja25"
        IMAGE_NAME     = "muthuraja25/myapp"
        IMAGE_TAG      = "build-${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout Code') {
            steps {
                deleteDir()
                git branch: 'main', url: 'https://github.com/MUTHURAJA25/mxk_infra_applicatication.git'
                sh "ls -la"
            }
        }

        stage('Terraform Init') {
    steps {
        dir('infra') {
            withCredentials([[
                $class: 'AmazonWebServicesCredentialsBinding',
                credentialsId: 'aws-crendentails-vgs'
            ]]) {
                sh "terraform init -reconfigure"
            }
        }
    }
}


        stage('Terraform Plan') {
            steps {
                dir('infra') {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-crendentails-vgs'
                    ]]) {
                        sh "terraform plan -var-file=terraform.tfvars -out=tfplan"
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('infra') {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-crendentails-vgs'
                    ]]) {
                        sh "terraform apply -auto-approve tfplan"
                    }
                }
            }
        }

        stage('Get Terraform Outputs') {
            steps {
                dir('infra') {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-crendentails-vgs'
                    ]]) {
                        sh "terraform output"
                    }
                }
            }
        }

        stage('Get EC2 Public IP') {
            steps {
        dir('infra') {
            script {
                env.EC2_PUBLIC_IP = sh(
                    script: "terraform output -raw ec2_public_ip",
                    returnStdout: true
                ).trim()

                echo "✅ EC2 PUBLIC IP = ${env.EC2_PUBLIC_IP}"
            }
        }
    }
}


        stage('Build Docker Image') {
            steps {
                sh "ls -R"
                sh """
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                    docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest
                """
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh """
                        echo "$PASS" | docker login -u "$USER" --password-stdin
                        docker push ${IMAGE_NAME}:${IMAGE_TAG}
                        docker push ${IMAGE_NAME}:latest
                        docker logout
                    """
                }
            }
        }

        stage('Deploy to EC2') {
    steps {
        withCredentials([sshUserPrivateKey(
            credentialsId: 'ec2-ssh-key',
            keyFileVariable: 'SSH_KEY',
            usernameVariable: 'SSH_USER'
        )]) {
            sh '''
                chmod 600 "$SSH_KEY"

                echo "🚀 Deploying container to EC2..."

                ssh -o StrictHostKeyChecking=no -i "$SSH_KEY" "$SSH_USER"@"$EC2_PUBLIC_IP" '
                    sudo systemctl start docker || true
                    sudo docker stop myapp || true
                    sudo docker rm myapp || true
                    sudo docker pull muthuraja25/myapp:latest
                    sudo docker run -d --name myapp -p 80:80 muthuraja25/myapp:latest
                '
            '''
        }
    }
}



    post {
        always {
            echo "✅ Deployment finished — visit: http://${EC2_PUBLIC_IP}"
        }
    }
}
