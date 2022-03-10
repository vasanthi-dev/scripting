pipeline {
    agent { label 'WORKSTATION' }
    options {
        ansiColor('xterm')
    }

    stages {
        stage('ansible playbook run') {
            steps {
                sh 'ansible-playbook simple-playbook.yml'
            }
        }
    }
}