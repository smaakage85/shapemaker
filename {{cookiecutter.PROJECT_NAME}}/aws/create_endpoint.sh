#!/bin/bash
#
# Create/Update Endpoint

Help()
{
  echo "Create/Update Endpoint"
  echo
  echo "Creates model, endpoint configuration and creates"
  echo "(or updates) endpoint."
  echo
  echo "options:"
  echo "e     Name of endpoint to create/update. Defaults to"
  echo "      the project name."
  echo "h     Print this Help."
  echo "u     Update endpoint? Defaults to 'false'."
  echo "m     Model data url. Defaults to latest model artifact."
  echo "w     Wait for endpoint to be in service. Defaults to"
  echo "      'false'."
  echo
}

# Args
UPDATE_ENDPOINT='false'
ENDPOINT_NAME=${PROJECT_NAME}
WAIT='false'
while getopts 'e::hm:uw' flag; do
  case "${flag}" in
    e) ENDPOINT NAME=${OPTARG} ;;
    h) Help
       exit;;
    m) MODEL_DATA=${OPTARG} ;;
    u) UPDATE_ENDPOINT='true' ;;
    w) WAIT='true' ;;
  esac
done

# Make model data argument default to latest model artifact.
# Some black magic bash to get the name of the artifact. 
# Assumes S3 prefixes end with timestamps (!).
if [ "${MODEL_DATA}" = "" ]; then
  LATEST_MODEL=$(aws s3 ls ${BUCKET_ARTIFACTS}/${PROJECT_NAME}/ \
                 | sort -r \
                 | head --lines 1 \
                 | awk '{print $NF}' \
                 | rev \
                 | cut -c2- \
                 | rev)
  MODEL_DATA=s3://${BUCKET_ARTIFACTS}/${PROJECT_NAME}/${LATEST_MODEL}/output/model.tar.gz
fi
export MODEL_DATA=${MODEL_DATA}
export MODEL_NAME=${PROJECT_NAME}-$(date -u +%Y-%m-%d-%H-%M-%S-%3N)

echo "Creating model: ${MODEL_NAME}.."
echo "Compiling model data: ${MODEL_DATA}.."
envsubst < configs/${JSON_MODEL} > ${DIR_TMP}/${JSON_MODEL}
aws sagemaker create-model --cli-input-json file://${DIR_TMP}/${JSON_MODEL}

echo "Creating endpoint configuration.."
envsubst < configs/${JSON_ENDPOINT_CONFIG} > ${DIR_TMP}/${JSON_ENDPOINT_CONFIG}
aws sagemaker create-endpoint-config \
  --cli-input-json file://${DIR_TMP}/${JSON_ENDPOINT_CONFIG}

if ! ${UPDATE_ENDPOINT}; then
  echo "Creating endpoint.."
  aws sagemaker create-endpoint --endpoint-name ${ENDPOINT_NAME} \
    --endpoint-config-name ${MODEL_NAME}
else
  echo "Updating endpoint.."
  aws sagemaker update-endpoint --endpoint-name ${ENDPOINT_NAME} \
    --endpoint-config-name ${MODEL_NAME}
fi

if ${WAIT}; then
  echo "Waiting for endpoint to be in service.."               
  aws sagemaker wait endpoint-in-service --endpoint-name ${ENDPOINT_NAME}
  echo "Endpoint in service."
fi
