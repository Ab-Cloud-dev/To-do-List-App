pipeline {
  agent { label 'Node01' }
  environment {
    SERVER_IP = credentials('prod-server-ip')
  }
  stages {
    stage('git') {
      agent { label "Node01" }
      steps {
        script {
          checkout([
            $class: 'GitSCM',
            branches: [[name: '*/main']],
            userRemoteConfigs: [[url: 'https://github.com/Ab-Cloud-dev/To-do-List-App.git']],
            extensions: [[
              $class: 'RelativeTargetDirectory',
              relativeTargetDir: 'test-pipeline'
            ]]
          ])
        }
      }
    }
  
  stages {
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
