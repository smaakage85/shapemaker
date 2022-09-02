ARG PY_VERSION
FROM python:${PY_VERSION}-slim-buster

# Build args
ARG AWS_DEFAULT_REGION
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY

# Environment variables
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE=TRUE
ENV DIR_VENV /opt/venv
ENV DIR_CODE /opt/ml/code

# 'sagemaker-training' depends on 'gcc'
RUN apt-get update && \
    apt-get -y install gcc 

# Create venv
RUN pip install --upgrade pip
RUN python3 -m venv ${DIR_VENV}
ENV PATH="${DIR_VENV}/bin:${PATH}"

COPY ./modelpkg ${DIR_CODE}/modelpkg
COPY ./requirements_modelpkg.txt ./train.py ${DIR_CODE}/

# Install model requirements
RUN pip install -r ${DIR_CODE}/requirements_modelpkg.txt
# Install the 'sagemaker-training' toolkit
RUN pip install sagemaker-training

ENV SAGEMAKER_PROGRAM train.py

WORKDIR ${DIR_CODE}
