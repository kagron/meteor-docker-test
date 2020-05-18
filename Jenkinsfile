pipeline {
    agent none

    environment {
        CI = 'true'
    }
    stages {
        stage('Install Dependencies') {
          agent {
              docker {
                  image 'kgrondin01/simple-meteor-image:latest'
                  args '-p 3000:3000'
              }
          }
          steps {
              echo 'Installing...'
              sh 'cp .env.example .env'
              dir('meteor/test-app') {
                  sh 'npm install'
              }
          }
        }

        stage('Test') {
          agent {
              docker {
                  image 'kgrondin01/simple-meteor-image:latest'
                  args '-p 3000:3000'
              }
          }
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
            sh 'ls -l .'
            sh 'ls -l /var/jenkins_home'
            sh 'docker ps'
            // script {
            //   def dockerfile = "./meteor/test-app/Dockerfile.prod"
            //   def newBuild = docker.build("kgrondin01/test-app:${env.BRANCH_NAME?.split("/")[1]}", "-f ${dockerfile} .")
            //   docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
            //     newBuild.push();
            //   }
            // }
          }
        }
      }
    }