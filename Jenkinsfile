pipeline {
    agent any

    stages {
        stage('ansible playbook run') {
            steps {
                sh 'ansible-playbook simple-playbook.yml'
            }
        }
    }
}