pipeline {
    agent {
        dockerfile {
            args '-v ${PWD}:/var/www'
        }
    }
    stages {
        stage('Build') {
            steps {
                sh 'ant -f build.xml'
                 archiveArtifacts artifacts: 'products/*', followSymLinks: false, onlyIfSuccessful: true
            }
        }
    }
}