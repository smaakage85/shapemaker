#!/bin/bash
#
# Provisioning of AWS resources

echo "Provisioning AWS resources.."

# If the Sagemaker execution role doesn't exist, create it
if ! aws iam get-role --role-name ${SAGEMAKER_ROLE} > /dev/null 2>&1; then
  echo "Creating Sagemaker execution role: ${SAGEMAKER_ROLE}"
  aws iam create-role --role-name ${SAGEMAKER_ROLE} \
    --assume-role-policy-document file://./configs/${JSON_SAGEMAKER_ROLE}
fi

# Attach policies to role
aws iam attach-role-policy --role-name ${SAGEMAKER_ROLE} \
    --policy-arn arn:aws:iam::aws:policy/AmazonSageMakerFullAccess
aws iam attach-role-policy --role-name ${SAGEMAKER_ROLE} \
    --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess

# If the ECR repository doesn't exist, create it
if ! aws ecr describe-repositories --repository-names ${ECR_REPO} > /dev/null 2>&1; then
  echo "Creating ECR repository: ${ECR_REPO}"
  aws ecr create-repository --repository-name ${ECR_REPO}
fi

# If the S3 bucket doesn't exist, create it
if ! aws s3api head-bucket --bucket ${BUCKET_ARTIFACTS} 2>/dev/null; then
  echo "Creating artifacts S3 bucket: ${BUCKET_ARTIFACTS}"
  aws s3api create-bucket \
    --bucket ${BUCKET_ARTIFACTS} \
    --region ${AWS_DEFAULT_REGION} \
    --create-bucket-configuration LocationConstraint=${AWS_DEFAULT_REGION}
fi

echo "Done."
