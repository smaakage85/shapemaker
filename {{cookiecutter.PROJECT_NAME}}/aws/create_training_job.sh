#!/bin/bash
#
# Create Training Job

Help()
{
  echo "Create Training Job"
  echo
  echo "options:"
  echo "e     Experimental training job. Saves artifacts"
  echo "      in separate S3 prefix. Defaults to 'false'."                                                                                             
  echo "h     Print this Help."
  echo "w     Wait for training job to complete."
  echo
}

# Args
EXPERIMENTAL='false'
WAIT='false'
while getopts ':hwe' flag; do
  case "${flag}" in
    e) EXPERIMENTAL='true' ;;
    h) Help
       exit;;
    w) WAIT='true' ;;
  esac
done

# Create generic name for training job
echo "Creating training job.."
NOW=$(date -u +%Y-%m-%d-%H-%M-%S-%3N)
export TRAINING_JOB_NAME=${PROJECT_NAME}-${NOW} 
S3_OUTPUT_PATH=s3://${BUCKET_ARTIFACTS}
# If training job is set to experimental save to separate prefix
if ${EXPERIMENTAL}; then
  S3_OUTPUT_PATH=${S3_OUTPUT_PATH}/experimental
fi  
export S3_OUTPUT_PATH=${S3_OUTPUT_PATH}/${PROJECT_NAME}
envsubst < configs/${JSON_TRAINING_JOB} > ${DIR_TMP}/${JSON_TRAINING_JOB}
aws sagemaker create-training-job --cli-input-json file://${DIR_TMP}/${JSON_TRAINING_JOB}
if ${WAIT}; then
  echo "Waiting for training job to complete.."               
  aws sagemaker wait training-job-completed-or-stopped --training-job-name ${TRAINING_JOB_NAME}
  echo "Training job completed."
fi
echo ${S3_OUTPUT_PATH}/${TRAINING_JOB_NAME}/output/model.tar.gz
