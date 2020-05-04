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


if [[ -z "${INPUT_HEADLINE}" ]]; then
  echo "You must at least set a INPUT_HEADLINE"
  exit 127
fi
if [[ -z "${INPUT_CHANNEL}" ]]; then
  echo "You must at least set a INPUT_CHANNEL"
  exit 127
fi

OUTPUT_JSON=$(cat /templates/full.json | jq ".channel=\"${INPUT_CHANNEL}\"")
OUTPUT_JSON=$(echo ${OUTPUT_JSON} | jq ".text=\"${INPUT_HEADLINE}\"")

OUTPUT_JSON=$(echo ${OUTPUT_JSON} | jq ".blocks[0].text.text=\"${INPUT_HEADLINE}\"")

if [[ -z "${INPUT_USERNAME}" ]]; then
  OUTPUT_JSON=$(echo ${OUTPUT_JSON} | jq "del(.username)")
else
  OUTPUT_JSON=$(echo ${OUTPUT_JSON} | jq ".username=\"${INPUT_USERNAME}\"")
fi

if [[ -z "${INPUT_ICONEMOJI}" ]]; then
  OUTPUT_JSON=$(echo ${OUTPUT_JSON} | jq "del(.icon_emoji)")
else
  OUTPUT_JSON=$(echo ${OUTPUT_JSON} | jq ".icon_emoji=\"${INPUT_ICONEMOJI}\"")
fi

if [[ -z "${INPUT_BODY}" ]]; then
  OUTPUT_JSON=$(echo ${OUTPUT_JSON} | jq "del(.blocks[1,2])")
else
  if [[ -z "${INPUT_IMAGEURL}" ]]; then

    OUTPUT_JSON=$(echo ${OUTPUT_JSON} | jq "del(.blocks[2].accessory)")
    OUTPUT_JSON=$(echo ${OUTPUT_JSON} | jq ".blocks[2].text.text=\"${INPUT_BODY}\"")
  else
    OUTPUT_JSON=$(echo ${OUTPUT_JSON} | jq ".blocks[2].accessory.image_url=\"${INPUT_IMAGEURL}\"")
    OUTPUT_JSON=$(echo ${OUTPUT_JSON} | jq ".blocks[2].text.text=\"${INPUT_BODY}\"")
  fi
fi

#echo $OUTPUT_JSON
#curl -X POST -v -H 'Content-type: application/json' --data @message.json $SLACK_WEBHOOK_URL
curl -X POST -s  --data-urlencode "payload=${OUTPUT_JSON}"  $SLACK_WEBHOOK_URL
