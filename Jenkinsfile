#!groovy
pipeline {
    agent {
        label "web"
    }

    stages {
        stage('Tests'){
            steps {
                sh "/bin/bats tests/"
            }
        }

        stage('Code inspection'){
            steps {
                sh "/bin/shellcheck --format=checkstyle --shell=bash decomposer > checkstyle.xml"
            }
        }
    }
    post {
        failure {
            emailext body: 'Please go to $BUILD_URL to see the result.',
                     recipientProviders: [[$class: 'RequesterRecipientProvider'], [$class: 'CulpritsRecipientProvider']],
                     subject: '$JOB_NAME ($JOB_BASE_NAME): Build $BUILD_DISPLAY_NAME: FAILED'
        }
        always {
            recordIssues enabledForFailure: true, aggregatingResults: true, tool: checkStyle(pattern: 'checkstyle.xml')
        }
    }
}
