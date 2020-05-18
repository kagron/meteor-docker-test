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
          environment {
            BRANCH = env.BRANCH_NAME
            TAG = env.BRANCH_NAME?.split("/")[0]
          }
          steps {
            echo 'Deploying...'
            sh 'echo "Tag is $TAG"'
          }
        }

      }
    }