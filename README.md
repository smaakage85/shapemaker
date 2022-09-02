# shapemaker <img src='logo.png' align="right" height="65" />

## :eyeglasses: Overview

`shapemaker` is an end-to-end template for Amazon Sagemaker AWS projects aiming for maximum flexibility. 

The template includes:

- a minimalistic template for model code
- a template for a docker image for model training
- an endpoint docker image template
- functions for interacting with the model/endpoint
- functions for delivering and integrating the model w/Sagemaker
- workflows enabling continuous integration/delivery

`shapemaker` builds on the [Bring Your Own Container (BYOC)](https://towardsdatascience.com/bring-your-own-container-with-amazon-sagemaker-37211d8412f4) Sagemaker functionality for full developer control.

`shapemaker` targets *full-stack* data scientists with basic knowledge of python, Amazon Sagemaker (BYOC) as well as AWS in general, docker, shell scripting, python and development of web applications.

## :movie_camera: Demo

...

## :computer: Requirements

**Cloud Services**
- Amazon Web Services*

**Operating systems** 
- Linux
- macOS

**Software**
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [direnv](https://direnv.net/docs/installation.html) 
- [gettext](https://www.drupal.org/docs/8/modules/potion/how-to-install-setup-gettext) 
- [docker](https://docs.docker.com/get-docker/)
- [docker compose](https://docs.docker.com/compose/install/)
- [python](https://www.python.org/downloads/)
- [Cookiecutter](https://pypi.org/project/cookiecutter/)

*: *if you want to play around, you can create your own free account and use the [AWS Free Tier](https://aws.amazon.com/free) resources free of charge up to specified limits for each service.*

The template was tested on Linux Ubuntu 22.04 LTS w/AWS CLI v2.

## :file_folder: Structure

    ./
    ├── .github/    
    │   └── workflows/            # Workflows for automation, CI/CD.
    ├── modelpkg/                 # Python package defining model logic.
    |   |   construct.py          # Code for constructing the model etc.
    │   └── tests/                # Unit tests for model code.
    ├── aws/                      # Shell scripts for integrating the project with Sagemaker.
    ├── configs/                  # Configurations for Sagemaker endpoints, training jobs, etc.
    ├── images/                   # Docker images for model training and model endpoint.
    ├── server/                   # Configuration of web server for model endpoint.
    ├── .envrc                    # Project-specific environment variables.
    ├── Makefile                  # Project-specific tasks.
    ├── train.py                  # Script for training the model.
    ├── app.py                    # Application code for the model endpoint.
    ├── requirements_modelpkg.txt # Python packages required by the model.
    └── requirements_dev.txt      # Python packages required in development mode.

## :file_folder: Tasks

All tasks related to interacting with the model project are implemented with shell functions in `Makefile`.

`make` + <kbd>space</kbd> + <kbd>tab</kbd> + <kbd>tab</kbd> lists all available `make` targets.

## :repeat: Enable Automation Workflows

Connect the Github Repository with your AWS account by providing your AWS credentials as secrets in your `Github` repository with names *AWS_ACCESS_KEY_ID* and *AWS_SECRET_ACCESS_KEY*.


# shapemaker
