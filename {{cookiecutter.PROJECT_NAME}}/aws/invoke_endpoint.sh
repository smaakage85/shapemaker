#!/bin/bash
#
# Invoke Sagemaker Endpoint

echo "Invoking endpoint with input data:"

cat ./configs/${JSON_REQUEST} 

aws sagemaker-runtime invoke-endpoint \
  --endpoint-name ${PROJECT_NAME} \
  --body fileb://configs/${JSON_REQUEST} \
  --content-type "application/json" \
  --accept "application/json" \
  --region ${AWS_DEFAULT_REGION} \
  ${DIR_TMP}/invoke_output.txt

echo "Predictions:"

cat ${DIR_TMP}/invoke_output.txt

echo
 