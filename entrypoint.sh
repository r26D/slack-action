#!/bin/bash
##!/bin/sh -l
set -e
replace_in_file() {
  local -r key="${1:?key is required}"
  local -r value="${2:?value is required}"
  local safe_value=$(echo $value | sed -e 's/[\/&]/\\&/g')
  local -r filename="${3:?filename is required}"
  #echo "sed -i -e \"s/$key/$safe_value/\" $filename"
  sed -i -e "s/$key/$safe_value/" $filename
}

if [[ -z "${SLACK_WEBHOOK_URL}" ]]; then
  echo "SLACK_WEBHOOK_URL missing!"
  exit 127
fi
if [[ -z "${1}" ]]; then
  echo "You must at least set a headline"
  exit 127
fi
if [[ -z "${2}" ]]; then
  #Just a headline
  cp -f "templates/headline.json" "message.json"

  replace_in_file "HEADLINE" "${1}" "message.json"

else
  if [[ -z "${3}" ]]; then
    cp -f "templates/body.json" "message.json"

    replace_in_file "HEADLINE" "${1}" "message.json"
    replace_in_file "BODY" "${2}" "message.json"
  else
    cp -f "templates/body_with_image.json" "message.json"

    replace_in_file "HEADLINE" "${1}" "message.json"
    replace_in_file "BODY" "${2}" "message.json"

    replace_in_file "IMAGE_URL" "${3}" "message.json"
  fi
fi

curl -X POST -v -H 'Content-type: application/json' --data @message.json $SLACK_WEBHOOK_URL
