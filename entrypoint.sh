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
CHANNEL=$1
USERNAME=$3
HEADLINE=$2
ICON_EMOJI=$4
BODY=$5
IMAGE_URL=$6

if [[ -z "${HEADLINE}" ]]; then
  echo "You must at least set a headline"
  exit 127
fi
if [[ -z "${CHANNEL}" ]]; then
  echo "You must at least set a CHANNEL"
  exit 127
fi

OUTPUT_JSON=$(cat /templates/full.json | jq ".channel=\"${CHANNEL}\"")
OUTPUT_JSON=$(echo ${OUTPUT_JSON} | jq ".blocks[0].text.text=\"${HEADLINE}\"")

if [[ -z "${USERNAME}" ]]; then
  OUTPUT_JSON=$(echo ${OUTPUT_JSON} | jq "del(.username)")
else
  OUTPUT_JSON=$(echo ${OUTPUT_JSON} | jq ".username=\"${USERNAME}\"")
fi

if [[ -z "${ICON_EMOJI}" ]]; then
  OUTPUT_JSON=$(echo ${OUTPUT_JSON} | jq "del(.icon_emoji)")
else
  OUTPUT_JSON=$(echo ${OUTPUT_JSON} | jq ".icon_emoji=\"${ICON_EMOJI}\"")
fi

if [[ -z "${BODY}" ]]; then
  OUTPUT_JSON=$(echo ${OUTPUT_JSON} | jq "del(.blocks[1,2])")
else
  if [[ -z "${IMAGE_URL}" ]]; then
    OUTPUT_JSON=$(echo ${OUTPUT_JSON} | jq "del(.blocks[2].accessory)")
    OUTPUT_JSON=$(echo ${OUTPUT_JSON} | jq ".blocks[2].text.text=\"${BODY}\"")
  else
    OUTPUT_JSON=$(echo ${OUTPUT_JSON} | jq ".blocks[2].accessory.image_url=\"${IMAGE_URL}\"")
    OUTPUT_JSON=$(echo ${OUTPUT_JSON} | jq ".blocks[2].text.text=\"${BODY}\"")
  fi
fi


#curl -X POST -v -H 'Content-type: application/json' --data @message.json $SLACK_WEBHOOK_URL
curl -X POST -s -H 'Content-type: application/json' --data @message.json $SLACK_WEBHOOK_URL
