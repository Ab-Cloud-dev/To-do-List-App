#!groovy
pipeline {
  agent any

  options {
    // Avoid the implicit checkout to control when/what code is fetched
    skipDefaultCheckout(true)
    // Keep workspace clean between runs (optional)
    buildDiscarder(logRotator(numToKeepStr: '10'))
  }

  stages {
    stage('Checkout & Setup') {
      steps {
        // Single checkout step using declarative style; can add shallow clone and refspec options
        checkout([
          $class: 'GitSCM',
          branches: [[name: '*/main']],  // or your desired branch
          userRemoteConfigs: [[
            url: 'https://github.com/Ab-Cloud-dev/To-do-List-App.git'
          ]],
          extensions: [
            // only fetch the latest commit
            [$class: 'CloneOption', shallow: true, depth: 1, noTags: false],
            // reduce data fetch
            [$class: 'PruneStaleBranch'],
            [$class: 'CleanBeforeCheckout']
          ]
        ])

        // Combined setup and test commands into one shell block
        sh '''
          python3 -m venv venv && \
          . venv/bin/activate && \
          pip install -r requirements.txt && \
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

  post {
    always {
      cleanWs()  // wipe workspace after build
    }
  }
}
