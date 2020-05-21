node {
    try {
        stage('Install dependencies') {
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
                    withEnv(["JEST_JUNIT_OUTPUT=./"]) {
                        sh 'npm run test-ci'
                    }
                    junit 'junit.xml'
                }
            }
        }

        stage('Build and Deploy to Staging') {
            if ((env.BRANCH_NAME =~ /release\/.*/) && !env.CHANGE_ID) {
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
            } else {
                echo 'Not on release branch -- skipping deployment'
            }
        }
    } catch (e) {
        currentBuild.result =  "FAILED"
        throw e
    } finally {
        notifyBuild(currentBuild.result)
    }
}

def notifyBuild(String buildStatus = 'STARTED') {
    // build status of null means successful
    buildStatus = buildStatus ?: 'SUCCESS'

    // Default values
    def colorName = 'RED'
    def colorCode = '#FF0000'
    def subject = "${buildStatus}: Pipeline '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
    def summary = "${subject} (${env.BUILD_URL})"
    def details = """<p>STARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
        <p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>"""

    // Override default values based on build status
    if (buildStatus == 'STARTED') {
        color = 'YELLOW'
        colorCode = '#FFFF00'
    } else if (buildStatus == 'SUCCESS') {
        color = 'GREEN'
        colorCode = '#00FF00'
    } else {
        color = 'RED'
        colorCode = '#FF0000'
    }

    // Send notifications
    slackSend (color: colorCode, message: summary)
}