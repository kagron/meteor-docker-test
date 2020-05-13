pipeline {
    agent any

    environment {
        CI = 'true'
    }
    stages {
        stage('Build') {
            steps {
                echo 'Building...'
                sh 'cp .env.example .env'
                step([
                    $class: 'DockerComposeBuilder',
                    dockerComposeFile: 'docker-compose.yml',
                    option: [
                        $class: 'ExecuteCommandInsideContainer',
                        command: 'npm run test',
                        index: 1,
                        privilegedMode: false,
                        service: 'meteor',
                        workDir: ''
                    ],
                    useCustomDockerComposeFile: false
                ])
            }
        }
        stage('Test') {
            steps {
                echo 'Testing...'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying...'
            }
        }
    }
}