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
      sh 'tln install --depends'
    }

    stage('Build') {
      sh 'tln prereq:init:build'
    }

    stage('Unit tests') {
      sh 'tln lint:test'
    }

    stage('SonarQube analysis') {
      helper.setGithubBuildStatus('quality_gates', '', BUILD_URL, 'pending');
      if (SONARQUBE_SERVER && SONARQUBE_SCANNER) {
        def scannerHome = tool "${SONARQUBE_SCANNER}"
        withSonarQubeEnv("${SONARQUBE_SERVER}") {
          if (helper.isPullRequest){
            sh "${scannerHome}/bin/sonar-scanner -Dsonar.analysis.mode=preview -Dsonar.github.pullRequest=${helper.pullId} -Dsonar.github.repository=${helper.org}/${helper.repo} -Dsonar.github.oauth=${GITHUB_ACCESS_TOKEN} -Dsonar.login=${SONARQUBE_ACCESS_TOKEN}"
          } else {
            sh "${scannerHome}/bin/sonar-scanner -Dsonar.login=${SONARQUBE_ACCESS_TOKEN}"
            // check SonarQube Quality Gates
            if (SONARQUBE_QUALITY_GATES.toString().toBoolean()) {
              //// Pipeline Utility Steps
              def props = readProperties  file: '.scannerwork/report-task.txt'
              echo "properties=${props}"
              def sonarServerUrl=props['serverUrl']
              def ceTaskUrl= props['ceTaskUrl']
              def ceTask
              //// HTTP Request Plugin
              timeout(time: 1, unit: 'MINUTES') {
                waitUntil {
                  def response = httpRequest "${ceTaskUrl}"
                  println('Status: '+response.status)
                  println('Response: '+response.content)
                  ceTask = readJSON text: response.content
                  return (response.status == 200) && ("SUCCESS".equals(ceTask['task']['status']))
                }
              }
              //
              def qgResponse = httpRequest sonarServerUrl + "/api/qualitygates/project_status?analysisId=" + ceTask['task']['analysisId']
              def qualitygate = readJSON text: qgResponse.content
              echo qualitygate.toString()
              if ("ERROR".equals(qualitygate["projectStatus"]["status"])) {
                setGithubBuildStatus(org, repo, token, 'quality_gates', '', BUILD_URL, 'failure', commitSha);
                currentBuild.description = "Quality Gate failure"
                error currentBuild.description
              }
            }
          }
        }
      }
      setGithubBuildStatus(org, repo, token, 'quality_gates', '', BUILD_URL, 'success', commitSha);
    }

    stage('Delivery') {
      if (helper.isPullRequest){
      } else {
        // create docker, push artifacts to the Harbor/Nexus/etc.
        // archiveArtifacts artifacts: 'path/2/artifact'
      }
    }

    stage('Deploy') {
      if (helper.isPullRequest){
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


