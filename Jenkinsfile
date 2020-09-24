#!/usr/bin/env groovy

@Library('jenkins-shared-library') _

// if library isn't loaded in jenkins:

// library identifier: 'jenkins-shared-library@master',
//         retriever: modernSCM(
//           [
//             $class: 'GitSCMSource',
//             remote: 'https://github.com/controlplaneio/jenkins-shared-library.git'
//           ])

pipelineDemo([
  stages: [
    gitSecrets          : true,
    gitCommitConformance: true,
    containerLint       : true,
    // TODO(ajm) escaping vuln
    containerBuild      : true,
    containerScan       : true,
    containerPush       : false,
  ],
])

