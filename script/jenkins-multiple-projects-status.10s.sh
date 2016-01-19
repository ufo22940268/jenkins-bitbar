#!/bin/bash

configFile=$(dirname $0)/../config.sh
if [[ ! -e $configFile ]]; then
    echo "Config file not exists"
    exit -1
else
    source $configFile
fi

function displaytime {
  local T=$1/1000
  local D=$((T/60/60/24))
  local H=$((T/60/60%24))
  local M=$((T/60%60))
  local S=$((T%60))
  local output=""

  if [[ $D -gt 0  || $H -gt 0 || $M -gt 10 ]]
  then
    output+=">10mn"
  else
    output+="${M}mn ${S}s"
  fi

  echo "${output} ago"
}

# beginning of display
# echo "Jenkins Status"
# echo "---"

for project in "${PROJECTS[@]}"
do
  output="${project}: "
  url="http://${BASE_URL}/job/${project}/lastBuild/api/json?pretty=true"
  query=$(curl --insecure --silent "${url}") # take only the end of output

  success=$(echo "${query}" | grep "result" | awk '{print $3}') # grep the "result" line
  if [[ $success == *"SUCCESS"* ]]
  then
    output+='🔵 '
  elif [[ $success == *"ABORT"* ]] 
  then
    output+='🔴 '
  else
    output+='🎾'
  fi

  echo "${output}"
done
