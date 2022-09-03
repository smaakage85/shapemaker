include .envrc
export

scripts_executable:
	chmod +x ./aws/*.sh

infrastructure: 
	./aws/infrastructure.sh

init: scripts_executable infrastructure

run_tests:
	pytest modelpkg

build_training_image:
	docker-compose build training

build_endpoint_image:
	docker-compose build endpoint

train_bash: 
	docker-compose run training bash

train_run:
	docker-compose run training

train_script:
	python train.py

run_app:
	flask run

serve_endpoint:
	docker-compose run --service-ports endpoint

login_ecr:
	aws ecr get-login-password --region ${AWS_DEFAULT_REGION} \
	| docker login --username AWS --password-stdin ${ECR}

push_training_image: login_ecr
	docker tag ${PROJECT_NAME}.training:latest ${ECR}/${ECR_REPO}:${PROJECT_NAME}.training
	docker push ${ECR}/${ECR_REPO}:${PROJECT_NAME}.training

push_endpoint_image: login_ecr
	docker tag ${PROJECT_NAME}.endpoint:latest ${ECR}/${ECR_REPO}:${PROJECT_NAME}.endpoint
	docker push ${ECR}/${ECR_REPO}:${PROJECT_NAME}.endpoint
	 	
create_training_job: 
	./aws/create_training_job.sh ${ARGS}

create_endpoint: 
	./aws/create_endpoint.sh ${ARGS}

update_endpoint: 
	./aws/create_endpoint.sh -u ${ARGS}

delete_endpoint: 
	aws sagemaker delete-endpoint \
	--endpoint-name ${PROJECT_NAME} \
	--region ${AWS_DEFAULT_REGION}

invoke_endpoint:
	./aws/invoke_endpoint.sh
