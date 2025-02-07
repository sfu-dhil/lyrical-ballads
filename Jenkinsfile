pipeline {
    agent {
        docker { image 'dhilsfu/static-base:main' }
    }
    stages {
        stage('Build') {
            steps {
                sh 'ant -f build.xml'
                archiveArtifacts artifacts: 'products/*', followSymlinks: false, onlyIfSuccessful: true
            }
        }
    }
}