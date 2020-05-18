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
          agent any
          when {
            branch 'release/*'
          }
          steps {
            echo 'Building...'
            echo 'Tag...' + env.BRANCH_NAME?.split("/")[1]
            script {
              def dockerfile = "/app/Dockerfile.prod"
              def newBuild = docker.build("kgrondin01/test-app:${env.BRANCH_NAME?.split("/")[1]}", "-f ${dockerfile} .")
              newBuild.push()
            }
          }
        }

      }
    }