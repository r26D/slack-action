#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

OUTPUT_JSON=$(jq --arg channel "${INPUT_CHANNEL}" '.channel=$channel' "$SCRIPT_DIR/templates/full.json")
OUTPUT_JSON=$(echo "${OUTPUT_JSON}" | jq --arg text "${INPUT_HEADLINE}" '.text=$text')
OUTPUT_JSON=$(echo "${OUTPUT_JSON}" | jq --arg text "${INPUT_HEADLINE}" '.blocks[0].text.text=$text')

if [[ -z "${INPUT_USERNAME}" ]]; then
  OUTPUT_JSON=$(echo "${OUTPUT_JSON}" | jq 'del(.username)')
else
  OUTPUT_JSON=$(echo "${OUTPUT_JSON}" | jq --arg val "${INPUT_USERNAME}" '.username=$val')
fi

if [[ -z "${INPUT_ICONEMOJI}" ]]; then
  OUTPUT_JSON=$(echo "${OUTPUT_JSON}" | jq 'del(.icon_emoji)')
else
  OUTPUT_JSON=$(echo "${OUTPUT_JSON}" | jq --arg val "${INPUT_ICONEMOJI}" '.icon_emoji=$val')
fi

if [[ -z "${INPUT_BODY}" ]]; then
  OUTPUT_JSON=$(echo "${OUTPUT_JSON}" | jq 'del(.blocks[1,2])')
else
  if [[ -z "${INPUT_IMAGEURL}" ]]; then
    OUTPUT_JSON=$(echo "${OUTPUT_JSON}" | jq 'del(.blocks[2].accessory)')
    OUTPUT_JSON=$(echo "${OUTPUT_JSON}" | jq --arg val "${INPUT_BODY}" '.blocks[2].text.text=$val')
  else
    OUTPUT_JSON=$(echo "${OUTPUT_JSON}" | jq --arg val "${INPUT_IMAGEURL}" '.blocks[2].accessory.image_url=$val')
    OUTPUT_JSON=$(echo "${OUTPUT_JSON}" | jq --arg val "${INPUT_BODY}" '.blocks[2].text.text=$val')
  fi
fi

RESPONSE=$(curl -X POST -s -w "\n%{http_code}" --data-urlencode "payload=${OUTPUT_JSON}" "${SLACK_WEBHOOK_URL}")
HTTP_CODE=$(echo "${RESPONSE}" | tail -1)
BODY=$(echo "${RESPONSE}" | sed '$d')

if [[ "${HTTP_CODE}" -lt 200 || "${HTTP_CODE}" -ge 300 ]]; then
  echo "Slack webhook failed with HTTP ${HTTP_CODE}: ${BODY}"
  exit 1
fi
