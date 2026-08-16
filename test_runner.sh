#!/bin/bash
set -e

export SLACK_WEBHOOK_URL="" #Set this for testing.
export INPUT_USERNAME="Github Action"
export INPUT_ICONEMOJI=":gatsby:"
export INPUT_CHANNEL="#jobward_development"
export INPUT_HEADLINE="This is a test"
export INPUT_BODY="Starting the process to build and deploy the *Public Web Site*"
export INPUT_IMAGEURL="https://bit.ly/3d82tTU"

./send_slack_message.sh
