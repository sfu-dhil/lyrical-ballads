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
            }
        }
    }
}