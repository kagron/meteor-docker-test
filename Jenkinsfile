pipeline {
    agent {
        docker {
            image 'node:14'
            args '-p 3000:3000'
        }
    }

    environment {
        CI = 'true'
    }
    stages {
        stage('Build') {
            steps {
                echo 'Building...'
                sh 'cp .env.example .env'
                dir('meteor/test-app') {
                    sh 'npm install'
                }
                // step([
                //     $class: 'DockerComposeBuilder',
                //     dockerComposeFile: 'docker-compose.yml',
                //     option: [
                //         $class: 'StartAllServices'
                //     ], 
                //     useCustomDockerComposeFile: false
                // ])
                // step([
                //     $class: 'DockerComposeBuilder',
                //     dockerComposeFile: 'docker-compose.yml',
                //     option: [
                //         $class: 'ExecuteCommandInsideContainer',
                //         command: 'npm run test',
                //         index: 1,
                //         privilegedMode: false,
                //         service: 'meteor',
                //         workDir: ''
                //     ],
                //     useCustomDockerComposeFile: false
                // ])
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