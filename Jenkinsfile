pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        echo 'Building...'
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