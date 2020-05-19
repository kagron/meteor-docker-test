node {
    def app
    def tag
    def dockerfile = "./meteor/test-app/Dockerfile.prod"
    def repositoryOwner = "kgrondin01"
    def imageName = "test-app"

    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace */

        checkout scm
        docker.image('node:13').withRun("--mount type=bind,source='$(pwd)',target=/app") { c ->
            docker.image('node:13').inside {
                dir('/app/meteor/test-app') {
                    sh 'npm install'
                }
            }
        }
    }

    stage('Test image') {
        docker.image('node:13').withRun("--mount type=bind,source='$(pwd)',target=/app") { c ->
            docker.image('node:13').inside {
                dir('/app/meteor/test-app') {
                    sh 'npm run test'
                }
            }
        }
    }

    stage('Build image') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */
        tag = env.BRANCH_NAME?.split("/")[1]
        app = docker.build(
            "${repositoryOwner}/${imageName}",
            "--build-arg NODE_ENV=production " +
            "--build-arg MONGO_URL=mongodb://mongo:27017/${imageName} " +
            "-f ${dockerfile} ./meteor/test-app"
        )
    }

    stage('Push image') {
        /* Finally, we'll push the image with two tags:
         * First, the incremental build number from Jenkins
         * Second, the 'latest' tag.
         * Pushing multiple tags is cheap, as all the layers are reused. */
        docker.withRegistry('https://registry.hub.docker.com', 'personal-dockerhub') {
            app.push("${tag}")
            app.push("latest")
        }
    }
}