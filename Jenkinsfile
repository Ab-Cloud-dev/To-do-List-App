pipeline {
  agent any
  options { skipDefaultCheckout(true) }
  stages {
    stage('Checkout & Setup') {
      steps {
        ws('/home/ec2-user/app') {
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
            python3 -m venv venv
            . venv/bin/activate
            pip install -r requirements.txt
            pytest
          '''
        }
      }
    }
    stage('Deploy Flask Service') {
      steps {
        ws('/home/ec2-user/app') {
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
