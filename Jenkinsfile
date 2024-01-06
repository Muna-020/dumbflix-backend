pipeline {
    agent any
    environment{
        credential = 'team2'
        server = 'team2@103.127.132.62'
        dirfe= '/home/team2/dumbflix-frontend'
        dirbe= '/home/team2/dumbflix-backend'
        branch = 'main'
        imagesfe = 'irwanpanai/dffrontend:1.0'
        imagesbe = 'irwanpanai/dfbackend:1.0'
        domainfe = 'https://team2.studentdumbways.my.id/'
        domainbe = 'https://api.team2.studentdumbways.my.id/'
    }
    stages {
        stage('melakukan pull FE dari repository') {
            steps {
                sshagent([credential]){
                    sh '''ssh -o StrictHostKeyChecking=no ${server} << EOF
                    docker compose down 
                    cd ${dirfe}
                    git pull origin ${branch} 
                    exit
                    EOF''' 
                }
                
            }
        }
        
        stage('melakukan pull BE dari repository') {
            steps {
                sshagent([credential]){
                    sh '''ssh -o StrictHostKeyChecking=no ${server} << EOF
                    cd ${dirbe}
                    git pull origin ${branch} 
                    exit
                    EOF''' 
                }
                
            }
        }
        
        stage('melakukan Build untuk aplikasi'){
            steps {
                sshagent([credential]){
                    sh '''ssh -o StrictHostKeyChecking=no ${server} << EOF
                    docker compose ps -a
		    cd ${dirbe}
                    docker rmi ${imagesbe}
                    docker build -t ${imagesbe} .
                    cd ${dirfe}
                    docker rmi ${imagesfe}
                    docker build -t ${imagesfe} .
                    docker compose up -d
	            docker images
                    docker compose ps -a
		    exit
                    EOF''' 
                }
            }   
        }
        
        stage('melakukan Testing pada Aplikasi'){
            steps {
                sshagent([credential]){
                    sh '''ssh -o StrictHostKeyChecking=no ${server} << EOF
                    curl localhost:3000
		    curl localhost:5000
		    wget --spider ${domainbe}
                    wget --spider ${domainfe}
		    docker compose ps -a
                    exit
                    EOF''' 
                }
            }   
        }
        
        stage('melakukan Deploy Aplikasi ke Docker'){
            steps {
                sshagent([credential]){
                    sh '''ssh -o StrictHostKeyChecking=no ${server} << EOF
                    docker compose up -d
                    docker compose ps -a
                    exit
                    EOF''' 
                }
            }   
        }
        
         stage('melakukan Push Image ke Docker Hub'){
            steps {
                sshagent([credential]){
                    sh '''ssh -o StrictHostKeyChecking=no ${server} << EOF
                    docker push ${imagesfe}
                    docker push ${imagesbe}
                    docker compose ps -a
                    exit
                    EOF''' 
                }
            }   
        }
        
        stage('membuat notifikasi ke discord'){
            steps {
              discordSend description: "App test", footer: "dumbflix-app done", link: env.BUILD_URL, result: currentBuild.currentResult, title: JOB_NAME, webhookURL: "https://discord.com/api/webhooks/1192332838146670613/zw60aKSerLPITX3E2cQuvVSaNAiv8yGHuwL0tRG1_es2fHyh8UPL9ZPEuLZr4s3cRUk_"
            }   
        }
    }
}



