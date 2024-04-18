pipeline {
    agent any
    
    environment {
        IMAGE_REPO_NAME = "reactkube"
        DOCKERHUB_CREDENTIALS= credentials('DOCKER_CRED') 
    }
   
    stages {
        stage('Building image') {
          steps{
            script {
                docker.build("${DOCKERHUB_CREDENTIALS_USR}/${IMAGE_REPO_NAME}:$BUILD_NUMBER", ".")
            }
          }
        }
        
        stage('Login to Docker Hub') {      	
            steps{                       	
        	sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'                		
        	echo 'Login Completed'      
            }           
        } 
  
    // Building Docker images
    
   
    // Uploading Docker images into AWS ECR
    stage('Pushing to ECR') {
     steps{  
         script {
                sh """docker push ${DOCKERHUB_CREDENTIALS_USR}/${IMAGE_REPO_NAME}:$BUILD_NUMBER"""
                sh """docker rmi ${DOCKERHUB_CREDENTIALS_USR}/${IMAGE_REPO_NAME}:$BUILD_NUMBER"""
         }
        }
      }
    stage ('Updating the Deployment File') {
            environment {
                GIT_REPO_NAME = "kubernetesdeployments"
                GIT_USER_NAME = "GauravRaturiDevOps"
            }
            steps {
                withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]){
                    sh '''
                    
                        git clone https://github.com/GauravRaturiDevOps/kubernetesdeployments.git
                        echo "i am here in username"
                        git config  user.email "raturigaurav.seaisainfotech.com"
                        git config  user.name "GauravRaturiDevOps"
                        echo "i am here in username"
                        BUILD_NUMBER=${BUILD_NUMBER}
                        PRE_BUILD_NUMBER=$((BUILD_NUMBER - 1))
                        echo "i am here in build number"
                        cd kubernetesdeployments
                        git checkout development
                        sed -i "21c\\        - image: '${DOCKERHUB_CREDENTIALS_USR}/${IMAGE_REPO_NAME}:\${BUILD_NUMBER}'" dev/react/deployment.yml
                        git add .
                        git commit -m "updated the image ${BUILD_NUMBER}"
                        git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:development

                       
                    '''
                }
            }
        
    }
}
}
