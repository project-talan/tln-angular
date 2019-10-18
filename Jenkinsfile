// https://github.com/project-talan/tln-jenkins-shared-libraries
@Library('tln-jenkins-shared-libraries@0.1.0') _
import org.talan.jenkins.*

properties([
  parameters(
    componentParams.getCommonParameters(paramConstant.PARAMS_COMMON, [
      //'COMPONENT_PARAM_HOST': '',
      //'COMPONENT_PARAM_LSTN': '',
      //'COMPONENT_PARAM_PORT': '',
      //'COMPONENT_PARAM_PORTS': '',
      'TALAN_PRESETS_PATH': "${PROJECT_TALAN_TMP}",
      'SONARQUBE_SERVER': 'sonar4project-talan',
      'SONARQUBE_SCANNER': 'sonar-scanner4project-talan',
      'SONARQUBE_QUALITY_GATES': true,
      'SONARQUBE_ACCESS_TOKEN': "${PROJECT_TALAN_SONARQUBE_ACCESS_TOKEN}",
      'GITHUB_ACCESS_TOKEN': "${PROJECT_TALAN_GITHUB_ACCESS_TOKEN}"
    ])
  )
])

node {
  //
  def helper = new buildHelper(this, SONARQUBE_ACCESS_TOKEN, GITHUB_ACCESS_TOKEN)
  //
  stage('Checkout') {
    //
    // Let helper resolve build properties
    def scmVars = checkout scm
    helper.collectBuildInfo(scmVars, params)
    //
    // Create config for detached build
    sh "echo '{\"detach-presets\": \"${TALAN_PRESETS_PATH}\"}' > '.tlnclirc'"
    
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
      sh 'tln install --depends'
    }

    stage('Build') {
      sh 'tln prereq:init:build'
    }

    stage('Unit tests') {
      sh 'tln lint:test'
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
