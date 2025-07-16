pipeline {
  agent any
  options { skipDefaultCheckout(true) }
  stages {
    stage('Checkout & Setup') {
      steps {
        ws('/var/lib/jenkins/workspace/app') {  // Changed workspace path
          checkout([
            $class: 'GitSCM',
            branches: [[name: '*/main']],
            userRemoteConfigs: [[url: 'https://github.com/Ab-Cloud-dev/To-do-List-App.git']],
            extensions: [
              [$class: 'CloneOption', shallow: true, depth: 1],
              [$class: 'PruneStaleBranch'],
              [$class: 'CleanBeforeCheckout']
            ]
          ])
          sh '''
            sudo python3 -m venv venv
            . venv/bin/activate
            sudo pip install -r requirements.txt
            sudo pytest
          '''
        }
      }
    }
    stage('Deploy Flask Service') {
      steps {
        ws('/var/lib/jenkins/workspace/app') {  // Changed workspace path
          sh '''
            chmod +x deploy_flask.sh
            ./deploy_flask.sh
          '''
        }
      }
    }
  }
  post { always { cleanWs() } }
}
