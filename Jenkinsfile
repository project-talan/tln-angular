// https://github.com/project-talan/tln-jenkins-shared-libraries
@Library('tln-jenkins-shared-libraries@0.1.0')
import org.talan.jenkins.*

properties([
  parameters([
    // component specific parameters
    string(name: 'COMPONENT_PARAM_HOST', defaultValue: 'localhost' ),
    string(name: 'COMPONENT_PARAM_LSTN', defaultValue: '0.0.0.0' ),
    string(name: 'COMPONENT_PARAM_PORT', defaultValue: '9080' ),
    string(name: 'COMPONENT_PARAM_PORTS', defaultValue: '9443' ),
    string(name: 'TLN_TMP', defaultValue: "${PROJECT_TALAN_TMP}" ),
    //
    string(name: 'SONARQUBE_SERVER', defaultValue: 'sonar4project-talan' ),
    string(name: 'SONARQUBE_SCANNER', defaultValue: 'sonar-scanner4project-talan'),
    booleanParam(name: 'SONARQUBE_QUALITY_GATES', defaultValue: true),
    password(name: 'SONARQUBE_ACCESS_TOKEN', defaultValue: "${PROJECT_TALAN_SONARQUBE_ACCESS_TOKEN}"),
    password(name: 'GITHUB_ACCESS_TOKEN', defaultValue: "${PROJECT_TALAN_GITHUB_ACCESS_TOKEN}")
  ])
])

node {
  //
  def helper = new ScmHelper(this, SONARQUBE_ACCESS_TOKEN, GITHUB_ACCESS_TOKEN)
  //
  stage('Checkout') {
    //
    // Let helper resolve build properties
    def scmVars = checkout scm
    helper.collectBuildInfo(scmVars, params)
    //
    // Create config for detached build
    sh "echo '{\"detach-presets\": \"${TLN_TMP}\"}' > '.tlnclirc'"
    
    //
    // Get information from project's config
    helper.printTopic('Package info')
    packageJson = readJSON file: 'package.json'
    env.COMPONENT_ID = packageJson.name
    env.COMPONENT_VERSION = packageJson.version
    def ids = packageJson.name.split('[.]') as List
    env.COMPONENT_ARTIFACT_ID = ids.removeAt(ids.size()-1)
    env.COMPONENT_GROUP_ID = ids.join('.')
  }
    
  try {

    stage('Setup build environment') {
      // sh 'tln install --depends'
    }

    stage('Build') {
      // sh 'tln prereq:init:build'
    }

    stage('Unit tests') {
      // sh 'tln lint:test'
    }

    stage('SonarQube analysis') {
      helper.runSonarQubeChecks(SONARQUBE_SCANNER, SONARQUBE_SERVER, SONARQUBE_QUALITY_GATES.toString().toBoolean())
    }

    stage('Delivery') {
      if (helper.pullRequest){
      } else {
        // create docker, push artifacts to the Harbor/Nexus/etc.
        // archiveArtifacts artifacts: 'path/2/artifact'
      }
    }

    stage('Deploy') {
      if (helper.pullRequest){
      } else {
      }
    }
  } catch (e) {
    def traceStack = e.toString()
    helper.sendEmailNotification('BUILD FAILED', "${BUILD_URL}\n${traceStack}")
    throw e
  }
}


/*
 *
 */


