#!/usr/bin/env bash


echo "$INPUT_JSON_KEY" > /service_account.json
export GOOGLE_APPLICATION_CREDENTIALS=/service_account.json

cd $INPUT_CONTEXT

firebase use $INPUT_PROJECT
if [ -z "$INPUT_ONLY_ARG" ]; then 
    firebase deploy
else
    firebase deploy --only $INPUT_ONLY_ARG
fi

