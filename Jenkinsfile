pipeline {
    agent {
        docker {
            image 'kgrondin01/simple-meteor-image:latest'
            args '-p 3000:3000'
        }
    }

    environment {
        CI = 'true'
    }
    stages {
        stage('Install Dependencies') {
            steps {
                echo 'Installing...'
                sh 'cp .env.example .env'
                dir('meteor/test-app') {
                    sh 'npm install'
                }
            }
        }

        stage('Test') {
          steps {
            echo 'Testing...'
            dir('meteor/test-app') {
                sh 'npm run test-ci'
            }
          }
        }

        stage('Build') {
          when {
            branch 'release/*'
          }
          steps {
            echo 'Building...'
            echo 'Tag...' + env.BRANCH_NAME?.split("/")[1]
            step(
              [
                $class: 'DockerBuilderPublisher',
                cleanImages: false,
                cleanupWithJenkinsJobDelete: false,
                cloud: '',
                dockerFileDirectory: '/app/meteor/test-app/Dockerfile.prod',
                fromRegistry: [],
                pushCredentialsId: 'dockerhub',
                pushOnSuccess: true,
                tagsString: 'kgrondin01/test-app:$BRANCH_NAME'
              ]
            )
          }
        }

      }
    }