pipeline {
  agent { label 'Node01' }

  stages {
    stage('Git Checkout') {
      steps {
        // You don't need 'git' inside script if using checkout scm later, but if you prefer:
        git url: 'https://github.com/Ab-Cloud-dev/To-do-List-App.git'
      }
    }

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Setup & Test') {
      steps {
        sh '''
          pip install -r requirements.txt
          pytest
        '''
      }
    }

    stage('Deploy Flask Service') {
      steps {
        sh '''
          chmod +x deploy_flask.sh
          ./deploy_flask.sh
        '''
      }
    }
  }
}
