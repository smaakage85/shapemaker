ARG PY_VERSION
FROM python:${PY_VERSION}-slim-buster

# Build args
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_DEFAULT_REGION

# Environment variables
# PYTHONUNBUFFERED keeps Python from buffering our standard
# output stream, which means that logs can be delivered to the user quickly. PYTHONDONTWRITEBYTECODE
# keeps Python from writing the .pyc files which are unnecessary in this case. 
ENV PYTHONUNBUFFERED=TRUE
ENV PYTHONDONTWRITEBYTECODE=TRUE
ENV DIR_CODE /opt/program
ENV DIR_VENV /opt/venv

RUN apt-get -y update && apt-get install -y --no-install-recommends \
         wget \
         nginx \
         ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create venv
RUN pip install --upgrade pip
RUN python3 -m venv ${DIR_VENV}
# Update PATH so that python programs are found when the container is invoked
ENV PATH="${DIR_VENV}/bin:${DIR_CODE}:${PATH}"

COPY ./modelpkg ${DIR_CODE}/modelpkg
COPY ./server/* ./app.py ./requirements_modelpkg.txt ${DIR_CODE}

# Install model requirements
RUN pip install -r ${DIR_CODE}/requirements_modelpkg.txt
# Install web server/app requirements
RUN pip install gunicorn flask

# Make 'serve' executable
RUN chmod +x ${DIR_CODE}/serve

WORKDIR ${DIR_CODE}