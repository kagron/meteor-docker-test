node {
    def app
    def tag
    def dockerfile = "./meteor/test-app/Dockerfile.prod"
    def repositoryOwner = "kgrondin01"
    def imageName = "test-app"

    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace */

        checkout scm
    }

    stage('Build image') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */
        tag = env.BRANCH_NAME?.split("/")[1]
        app = docker.build("${repositoryOwner}/${imageName}", "-f ${dockerfile} .")
    }

    stage('Test image') {
        app.inside {
            sh 'npm run test'
        }
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