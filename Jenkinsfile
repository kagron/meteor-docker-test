node {
    def app
    def tag
    def isRelease = (env.BRANCH_NAME =~ /release\/.*/)

    stage('Install depencies') {
        /* Let's make sure we have the repository cloned to our workspace */

        checkout scm
        docker.image('node:13.14').inside{
            /* 
             * Install depdencies inside a node container.  By default
             * the current directory is mounted to the docker container
             */
            sh 'npm install'
        }
    }

    stage('Run Tests') {
        docker.image('node:13.14').inside {
            /* Since the directory was mounted above, our node_modules will be in the
             * directory and we can spin up the container to now run tests
             */
            sh 'npm run test-ci'
        }
    }

    stage('Build and deploy') {
        if (isRelease) {
            docker.image('node:13.14').inside {
                dir('../') {
                    sh 'wget https://www.agwa.name/projects/git-crypt/downloads/git-crypt-0.6.0.tar.gz'
                    sh 'tar -xf git-crypt-0.6.0.tar.gz'
                    dir('git-crypt-0.6.0') {
                        sh 'make'
                        sh 'make install PREFIX=/usr/local'
                        sh 'curl https://install.meteor.com/ | sh'
                        sh 'export METEOR_ALLOW_SUPERUSER=true'
                        withCredentials([file(credentialsId: 'gpgKey', variable: 'GPG_KEY')]) {
                            sh 'gpg --import $GPG_KEY'
                        }
                    }
                }
                sh 'git-crypt unlock'
                sh 'npm i -g mup'
                dir('./deploy/staging') {
                    withCredentials([sshUserPrivateKey(credentialsId: 'meteor-test-mup-pem', keyFileVariable: 'PEM_PATH')]) {
                        sh "sed -i 's/PEM_PATH_HERE/$PEM_PATH'"
                    }
                    sh 'mup setup --verbose'
                    sh 'mup deploy --verbose'
                }
            }
        }
    }
}