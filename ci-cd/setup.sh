#!/bin/bash
set -x
AGENTSA=jenkins-agent
NAMESPACE=nebbog-dev

isAgentSa=$(oc -n ${NAMESPACE} get sa ${AGENTSA})
if [[ -z ${isAgentSa} ]];then
  oc -n ${NAMESPACE} create sa ${AGENTSA}
fi

isJenkinsAgentEdit=$(oc -n ${NAMESPACE} get rolebindings ${AGENTSA}-edit)
if [[ -z ${isJenkinsAgentEdit} ]];then
  oc policy --rolebinding-name=${AGENTSA}-edit add-role-to-user edit system:serviceaccount:${NAMESPACE}:${AGENTSA} -n ${NAMESPACE}
fi

isJenkinsAgentImagePull=$(oc -n ${NAMESPACE} get rolebindings ${AGENTSA}-image-puller)
if [[ -z ${isJenkinsAgentImagePull} ]];then
  oc policy --rolebinding-name=${AGENTSA}-image-puller add-role-to-user system:image-puller system:serviceaccount:${NAMESPACE}:${AGENTSA} -n ${NAMESPACE}
fi

isJenkinsService=$(oc -n nebbog-dev get service jenkins)
if [[ -z ${isJenkinsService} ]];then
  oc new-app jenkins-ephemeral -n ${NAMESPACE} 
fi

