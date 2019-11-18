pipeline{
    agent {
        // presuming Jenkins has an agent with docker installed
        label = "docker"        
    }
    stages{
        stage("checkout"){
            steps{
                checkout scm
            }        
        }
        stage("build"){
            steps{
                docker build -t "mkdocs" .
            }
        }
        stage("test"){
            steps{
                sh "test.sh"
            }        
        }   
    }
}
