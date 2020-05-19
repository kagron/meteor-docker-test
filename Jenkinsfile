node {
    stage('Install depencies') {
        /* Let's make sure we have the repository cloned to our workspace */

        checkout scm
        docker.image('node:13.14').inside{
            /* 
             * Install depdencies inside a node container.  By default
             * the current directory is mounted to the docker container
             */
            dir('./meteor/test-app'){
                sh 'npm install'
            }
        }
    }

    stage('Run Tests') {
        docker.image('node:13.14').inside {
            /* Since the directory was mounted above, our node_modules will be in the
             * directory and we can spin up the container to now run tests
             */
            dir('./meteor/test-app') {
                withEnv(["JEST_JUNIT_OUTPUT=./jest-test-results.xml"]) {
                    sh 'npm run test-ci'
                }
                junit 'jest-test-results.xml'
            }
        }
    }

    stage('Build and deploy') {
        if ((env.BRANCH_NAME =~ /release\/.*/)) {
            docker.image('kgrondin01/simple-meteor-image').inside {
                withCredentials([file(credentialsId: 'gpgKey', variable: 'GPG_KEY')]) {
                    sh 'gpg --import $GPG_KEY'
                }
                sh "git-crypt unlock"
                dir('./meteor/test-app/.deploy/staging') {
                    withCredentials([sshUserPrivateKey(credentialsId: 'meteor-test-mup-pem', keyFileVariable: 'PEM_PATH')]) {
                        sh 'cp $PEM_PATH ./'
                        sh 'sed -i "s/PEM_PATH_HERE/.\\/ssh-key-PEM_PATH/" ./mup.js'
                        sh 'mup setup --verbose'
                        sh 'mup deploy --verbose'
                        sh 'rm ./ssh-key-PEM_PATH'
                    }
                }
            }
        }
    }
}