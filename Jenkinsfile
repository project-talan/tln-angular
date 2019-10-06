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
  // Define 
  def pullRequest = false
  def commitSha = ''
  def buildBranch = ''
  def pullId = ''
  def lastCommitAuthorEmail = ''
  def origin = ''
  def repo = ''
  def org = ''

  stage('Checkout') {
    //
    //
    def scmVars = checkout scm
    printTopic('Job input parameters');
    println(params)
    printTopic('SCM variables')
    println(scmVars)
    //
    // Be able to work with standard pipeline and multibranch pipeline identically
    printTopic('Build info')
    commitSha = scmVars.GIT_COMMIT
    buildBranch = scmVars.GIT_BRANCH
    if (buildBranch.contains('PR-')) {
      // multibranch PR build
      pullRequest = true
      pullId = CHANGE_ID
    } else if (params.containsKey('sha1')){
      // standard PR build
      pullRequest = true
      pullId = ghprbPullId
    } else {
      // PUSH build
    }
    echo "[PR:${pullRequest}] [BRANCH:${buildBranch}] [COMMIT: ${commitSha}] [PULL ID: ${pullId}]"
    printTopic('Environment variables')
    echo sh(returnStdout: true, script: 'env')
    //
    // Extract organisation and repository names
    printTopic('Repo parameters')
    origin = sh(returnStdout: true, script: 'git config --get remote.origin.url')
    org = sh(returnStdout: true, script:'''git config --get remote.origin.url | rev | awk -F'[./:]' '{print $2}' | rev''').trim()
    repo = sh(returnStdout: true, script:'''git config --get remote.origin.url | rev | awk -F'[./:]' '{print $1}' | rev''').trim()
    echo "[origin:${origin}] [org:${org}] [repo:${repo}]"
    //
    // Get authors' emails
    printTopic('Author(s)')
    lastCommitAuthorEmail = sh(returnStdout: true, script:'''git log --format="%ae" HEAD^!''').trim()
    if (!pullRequest){
      lastCommitAuthorEmail = sh(returnStdout: true, script:'''git log -2 --format="%ae" | paste -s -d ",\n"''').trim()
    }
    echo "[lastCommitAuthorEmail:${lastCommitAuthorEmail}]"
    //
    // Create config for detached build
    sh "echo '{\"detach-presets\": \"${TLN_TMP}\"}' > '.tlnclirc'"
    
    //
    // Get information from project's config
    printTopic('Package info')
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
      setGithubBuildStatus('quality_gates', 'PENDING', ${env.BUILD_URL}, commitSha)
      if (SONARQUBE_SERVER && SONARQUBE_SCANNER) {
        printTopic('Sonarqube properties')
        echo sh(returnStdout: true, script: 'cat sonar-project.properties')
        def scannerHome = tool "${SONARQUBE_SCANNER}"
        withSonarQubeEnv("${SONARQUBE_SERVER}") {
          if (pullRequest){
            sh "${scannerHome}/bin/sonar-scanner -Dsonar.analysis.mode=preview -Dsonar.github.pullRequest=${pullId} -Dsonar.github.repository=${org}/${repo} -Dsonar.github.oauth=${GITHUB_ACCESS_TOKEN} -Dsonar.login=${SONARQUBE_ACCESS_TOKEN}"
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
                setGithubBuildStatus('quality_gates', 'FAILURE', ${env.BUILD_URL}, commitSha)
                currentBuild.description = "Quality Gate failure"
                error currentBuild.description
              }
            }
          }
        }
      }
      setGithubBuildStatus('quality_gates', 'SUCCESS', ${env.BUILD_URL}, commitSha)
    }
    
    stage('Delivery') {
      if (pullRequest){
      } else {
        // create docker, push artifacts to the Harbor/Nexus/etc.
        // archiveArtifacts artifacts: 'path/2/artifact'
      }
    }   

    stage('Deploy') {
      if (pullRequest){
      } else {
      }
    }
  } catch (e) {
    sendEmailNotification('BUILD FAILED', lastCommitAuthorEmail, e.toString())
    throw e
  }
}

/*
 *
 */
def sendEmailNotification(subj, recepients, traceStack) {
    emailext body: "${BUILD_URL}\n${traceStack}",
    recipientProviders: [
      [$class: 'CulpritsRecipientProvider'],
      [$class: 'DevelopersRecipientProvider'],
      [$class: 'RequesterRecipientProvider']
    ],
    subject: subj,
    to: "${recepients}"
}

/*
 *
 */
def printTopic(topic) {
  println("[*] ${topic} ".padRight(80, '-'))
}

/*
 *
 */
// 'PENDING', 'SUCCESS', 'FAILURE', 'ERROR'
def setGithubBuildStatus(message, state, context, sha) {
  step([
    $class: "GitHubCommitStatusSetter",
    //reposSource: [$class: "ManuallyEnteredRepositorySource", url: "https://github.com/<your-repo-url>"],
    contextSource: [$class: "ManuallyEnteredCommitContextSource", context: context],
    errorHandlers: [[$class: "ChangingBuildStatusErrorHandler", result: "UNSTABLE"]],
    commitShaSource: [$class: "ManuallyEnteredShaSource", sha: sha ],
    //statusBackrefSource: [$class: "ManuallyEnteredBackrefSource", backref: "${BUILD_URL}<your-url>/"],
    statusResultSource: [$class: "ConditionalStatusResultSource", results: [[$class: "AnyBuildResult", message: message, state: state]] ]
  ]);
}

