#!/usr/bin/env groovy

@Library('jenkins-shared-library@docker-build') _

pipeline {
    agent none
    stages {
        stage ('Example') {
            steps {
                // log.info 'Starting' 
                script { 
                    buildImage.checkout
                }
            }
        }
    }
}