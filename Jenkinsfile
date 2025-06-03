pipeline {
    agent {
        docker { image 'dhilsfu/static-base:main' }
    }
    stages {
        stage('Build') {
            steps {
                withAnt {
                    sh 'ant -f build.xml'
                }
                archiveArtifacts artifacts: 'public/**/*', followSymlinks: false, onlyIfSuccessful: true
                emailext body: 'Test Message',
                    subject: 'Test Subject',
                    to: credentials('TEST_EMAIL_LIST')
            }
        }
    }
}
