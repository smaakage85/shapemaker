# shapemaker <img src='logo.png' align="right" height="139" />

## :eyeglasses: Overview
`shapemaker` is an end-to-end template for Amazon SageMaker AWS projects aiming for maximum flexibility. 

The template includes:

- a minimalistic template for model code
- a template for a docker image for model training
- an endpoint docker image template for real-time inference
- command-line functions for interacting with the model/endpoint
- command-line functions for delivering and integrating the model w/Sagemaker
- workflows enabling continuous integration/delivery.

`shapemaker` builds on the [Bring Your Own Container (BYOC)](https://towardsdatascience.com/bring-your-own-container-with-amazon-sagemaker-37211d8412f4) SageMaker functionality for **full developer control**. 

In other words, if you find, SageMaker *does not offer enough flexibility* out-of-the-box with respect to customizing either

1. training jobs
2. endpoints or
3. how to serve endpoints

then `shapemaker` might be a good fit for you.

`shapemaker` targets *full-stack* data scientists with intermediate knowledge of python, Amazon SageMaker as well as AWS in general, docker, shell scripting and development of web applications.

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

## :information_source: How to use

### :new: Create project from template
Create a project from the `shapemaker` template using `Cookiecutter`:

```
cookiecutter gh:smaakage85/shapemaker
```

The inputs for the template are described below:

| Input | Description |
| --- | --- |
| PROJECT_NAME | Name of model project. |
| PY_VERSION | Which version of python to use, e.g. '3.9'. |
| DIR_MODEL_LOCAL | Local directory for model artifact storage, e.g. './artifacts'.|
| DIR_TMP | Temporary files directory, e.g. '/tmp'. |
| AWS_ACCOUNT_ID | 12-digit AWS account ID. |
| AWS_DEFAULT_REGION | AWS default region. |
| ECR_REPO | Name of AWS ECR repository, where containers are published. |
| SAGEMAKER_ROLE | Name of the Sagemaker execution role to be assumed by Sagemaker. |
| BUCKET_ARTIFACTS | Name of S3 bucket for model artifact storage. **NOTE**: prefix with 'sagemaker' for immediate Sagemaker access, e.g. 'sagemaker_artifacts_blablabla'. |

**NOTE**: do *NOT* enquote input values.

### :wrench: Set-up project
Initialize project by executing `make init` from the command line in the project directory. The `init` target makes the included shell scripts executable and provisions relevant AWS infrastructure.

Export project-specific environment variables automatically with `direnv`, i.e. by invoking `direnv allow`.

### :file_folder: Template structure
To help you navigate in the `shapemaker` template here is an overview of the folder structure:

    ./
    ├── .github/    
    │   └── workflows/            # Workflows for automation, CI/CD.
    ├── modelpkg/                 # Python package defining model logic.
    |   |   construct.py          # Code for constructing and training the model etc.
    │   └── tests/                # Unit tests for model code.
    ├── aws/                      # Shell scripts for integrating the project with Sagemaker.
    ├── configs/                  # Configurations for Sagemaker endpoints, training jobs, etc.
    ├── images/                   # Docker images for model training and model endpoint.
    ├── server/                   # Configuration for a default NGINX web server for the model endpoint.*
    ├── .envrc                    # Project-specific environment variables.
    ├── Makefile                  # Command-line functions for project-specific tasks.
    ├── train.py                  # Script for training the model. Builds into training image.
    ├── app.py                    # Application code for the model endpoint. Builds into endpoint image.
    ├── requirements_modelpkg.txt # Python packages required by the model.
    └── requirements_dev.txt      # .. All other python packages needed in development mode.

*: template from [AWS example](https://github.com/RamVegiraju/SageMaker-Deployment/tree/master/RealTime/BYOC/PreTrained-Examples/SpacyNER).

The level of modification needed for the individual files will depend on your specific use-case.

### :shell: Command-line functions
All tasks related to interacting with the model project are implemented as command-line functions in `./Makefile` implying that functions are invoked with `make [target]`, e.g. `make build_training_image`.

If you want to build, train and deploy a model **on-the-fly** you can do it by invoking a sequence of `make` targets, i.e.:

1. `make init`
2. `make build_training_image`
3. `make push_training_image`
4. `make create_training_job`
5. `make build_endpoint_image`
6. `make push_endpoint_image`
7. `make create_endpoint`

`make` + <kbd>space</kbd> + <kbd>tab</kbd> + <kbd>tab</kbd> lists all available `make` targets.

### :repeat: CI/CD workflows
`shapemaker` ships with a number of automation (CI/CD) workflows implemented with Github Actions.

To enable CI/CD workflows, upload your project to Github and connect the Github repository with your AWS account by providing your AWS credentials as `Github` Secrets. Secrets should have names:

1. *AWS_ACCESS_KEY_ID*
2. *AWS_SECRET_ACCESS_KEY*

By default, every commit to `main` triggers a workflow `./github/workflows/deliver_images.yaml`, that runs unit tests and builds and pushes training and endpoint images. 

All workflows can be [run manually](https://docs.github.com/en/actions/managing-workflow-runs/manually-running-a-workflow).

## :loudspeaker: Shout-outs

A big thanks for the inspiration goes to: 

- [Maria Vexlard](https://github.com/m-romanenko) for [this blog post](https://www.sicara.fr/blog-technique/amazon-sagemaker-model-training) on how to train a model with Amazon SageMaker BYOC.
- [Ram Vegiraju](https://github.com/RamVegiraju) for [this blog post](https://towardsdatascience.com/bring-your-own-container-with-amazon-sagemaker-37211d8412f4) on how to create an endpoint with Amazon SageMaker BYOC. 

## :mailbox: Contact

Please direct any questions and feedbacks to [me](mailto:lars_kjeldgaard@hotmail.com)\!

If you want to contribute, open a [PR](https://github.com/smaakage85/shapemaker/pulls).

If you encounter a bug or want to suggest an enhancement, please [open an issue](https://github.com/smaakage85/shapemaker/issues).

