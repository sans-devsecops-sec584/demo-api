#!/usr/bin/env groovy

@Library('jenkins-shared-library@docker-build') _

pipelineDemo([
  stages: [
    gitSecrets: true,
    gitCommitConformance: true,
    containerLint: true,
    containerBuild: true,
    containerScan: true,
//    shfmt: true,
//    unitTest: [
//      command: "make test-unit",
//      reports: "test/output/*.xml"
//    ]
  ],
])
