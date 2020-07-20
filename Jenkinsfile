library(
  identifier: 'jenkins-shared-library@1.0.4',
  retriever: modernSCM(
    [
      $class: 'GitSCMSource',
      remote: 'file:///mnt/test-repo/2020/jenkins-shared-library'
      //   remote: 'https://github.com/hoto/jenkins-shared-library.git'
    ]
  )
)

// todo(ajm) mount shared cache folder into all agents for trivy image scan?
def agentConfigImage = 'docker.io/controlplane/gcloud-sdk:latest'
// http://man7.org/linux/man-pages/man7/capabilities.7.html
def agentConfigArgs = '-v /var/run/docker.sock:/var/run/docker.sock ' +
  '--tmpfs /tmp ' +
  '--user=root ' +
  '--cap-drop=ALL ' +
  '--cap-add=DAC_OVERRIDE ' +
  '--cap-add=CHOWN ' +
  '--cap-add=FOWNER ' +
  '--cap-add=DAC_READ_SEARCH '


pipeline {
  agent any // Allow Jenkins to schedule a build job on any worker node

  stages {
    stage('parallel wrapper') {
//      options {
//        //            this doesn't appear to work despite being in the docs https://www.jenkins.io/doc/book/pipeline/syntax/
//            parallelsAlwaysFailFast()
//      }


      parallel {

        stage('static analysis #1') {
          agent {
            docker {
              image agentConfigImage
              args agentConfigArgs
            }
          }
          options {
            timeout(time: 15, unit: 'MINUTES')
            retry(1)
            timestamps()
            // this is needed to use this job as a task/Makefile runner
//        disableConcurrentBuilds()
          }

          steps {
            script {
              sh 'echo I am the respectable first of stages'
//              sh 'env; pwd'
//              sh "find . -printf '%M %u:%g %p\n'"
              sh """
              LIB_PATH="${WORKSPACE}"
              LIB_PATH=\${LIB_PATH%@*}@libs/jenkins-shared-library
#              ls -la \${LIB_PATH}

              docker run --rm -i hadolint/hadolint < Dockerfile || true
              """
            }
          } // steps

        } // stage 1
        stage('container image build') {
          agent {
            docker {
              image agentConfigImage
              args agentConfigArgs
            }
          }
          options {
            timeout(time: 15, unit: 'MINUTES')
            retry(1)
            timestamps()
            // this is needed to use this job as a task/Makefile runner
//        disableConcurrentBuilds()
          }

          environment {
            CONTAINER_TAG='andy-test:latest'
          }

          steps {


            script {
              sh 'echo second stage yo'
//              sh 'env; pwd'
//              sh "find . -printf '%M %u:%g %p\n'"
              sh """
              LIB_PATH="${WORKSPACE}"
              LIB_PATH=\${LIB_PATH%@*}@libs/jenkins-shared-library
              # ls -la \${LIB_PATH}

              docker build --tag ${CONTAINER_TAG} .
              """
            }

            script {
              sh 'echo second stage Part Deux'
              sh """
              cat <<EOF > .trivyignore
              CVE-2018-20843
EOF

              docker run --rm \
                -v ~/.cache:/root/.cache/ \
                -v "\${PWD}/.trivyignore:/.trivyignore" \
                -v /var/run/docker.sock:/var/run/docker.sock \
                aquasec/trivy \
                --ignore-unfixed \
                --exit-code 0 \
                --severity HIGH,CRITICAL \
                ${CONTAINER_TAG}
                """
              }

          } // steps

        } // stage 2
      } // parallel
    } // stages
  } // stage parallel wrapper
} // pipeline

