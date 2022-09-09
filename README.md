# shapemaker <img src='logo.jpg' align="right" height="139" />

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

`shapemaker` targets *full-stack* data scientists with intermediate knowledge of python, Amazon Sagemaker as well as AWS in general, docker, shell scripting and development of web applications.

## :cinema: Demo

Click the screen below to watch a quick walkthrough of some of the most important features of the 'shapemaker' template. The video goes through how to build training and endpoint images and how to create training jobs and endpoints from the command line. Furthermore I show to enable `shapemaker` CI/CD workflows.

[![Watch the video](https://img.youtube.com/vi/tn9sbyskPCI/maxresdefault.jpg)](https://youtu.be/tn9sbyskPCI)

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

**CI/CD**
- [Github Actions](https://github.com/features/actions)

*: *if you want to play around, you can create your own free account and use the [AWS Free Tier](https://aws.amazon.com/free) resources free of charge up to specified limits for each service.*

The template was tested on Linux Ubuntu 22.04 LTS w/AWS CLI v2.

## :file_folder: Template Structure

    ./
    ├── .github/    
    │   └── workflows/            # Workflows for automation, CI/CD.
    ├── modelpkg/                 # Python package defining model logic.
    |   |   construct.py          # Code for constructing and training the model etc.
    │   └── tests/                # Unit tests for model code.
    ├── aws/                      # Shell scripts for integrating the project with Sagemaker.
    ├── configs/                  # Configurations for Sagemaker endpoints, training jobs, etc.
    ├── images/                   # Docker images for model training and model endpoint.
    ├── server/                   # Configuration for a default NGINX web server for the model endpoint.
    ├── .envrc                    # Project-specific environment variables.
    ├── Makefile                  # Command-line functions for project-specific tasks.
    ├── train.py                  # Script for training the model. Builds into the training image.
    ├── app.py                    # Application code for the model endpoint. Builds into the endpoint image.
    ├── requirements_modelpkg.txt # Python packages required by the model.
    └── requirements_dev.txt      # Other python packages required in development mode.

## :abc: Command-line Functions

All tasks related to interacting with the model project are implemented with command-line functions in `./Makefile`, i.e. functions are invoked with `make [target]`, e.g. `make build_training_image`.

`make` + <kbd>space</kbd> + <kbd>tab</kbd> + <kbd>tab</kbd> lists all available `make` targets.

## :repeat: Enable Automation Workflows
Upload your project to Github and connect the Github Repository with your AWS account by providing your AWS credentials as secrets in your `Github` repository with names:

1. *AWS_ACCESS_KEY_ID*
2. *AWS_SECRET_ACCESS_KEY*
