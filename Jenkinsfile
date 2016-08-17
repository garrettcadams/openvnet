#!groovy
properties ([[$class: 'ParametersDefinitionProperty',
  parameterDefinitions: [
    [$class: 'StringParameterDefinition',
      defaultValue: '0', description: 'Leave container after build for debugging.', name: 'LEAVE_CONTAINER'],
    [$class: 'StringParameterDefinition',
      defaultValue: '/var/www/html/repos', description: 'Path to create yum repository', name: 'REPO_BASE_DIR']
  ]
]])

def build_env = """# These parameters are read from bash and docker --env-file.
# So do not use single or double quote for the value part.
LEAVE_CONTAINER=$LEAVE_CONTAINER
REPO_BASE_DIR=$REPO_BASE_DIR
BUILD_CACHE_DIR=/var/lib/jenkins/build-cache
"""

node {
    stage "Checkout"
    checkout scm
    writeFile(file: "build.env", text: build_env)
    stage "Build"
    sh "./deployment/docker/build.sh ./build.env"
}