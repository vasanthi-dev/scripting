pipeline {
    agent { label 'WORKSTATION' }

    stages {
        stage('ansible playbook run') {
            steps {
                sh 'ansible-playbook simple-playbook.yml'
            }
        }
    }
}