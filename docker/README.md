# Development Environment with Docker

## Requirements
1. Install Docker with Docker Compose
1. Install a version of the `make` command
1. AWS credentials (Using an Access Key)

### Creating your AWS Access Key
*If you already have an AWS access key, skip this.*
1. Log in to the [AWS Console](https://544748063362.signin.aws.amazon.com/console)
1. Go to the [IAM Service](https://console.aws.amazon.com/iam/home?region=ca-central-1#/home)
1. Click on Users in the left side menu
1. Select your user account from the list
1. Go to the "Security credentials" tab
1. Under "Access keys" click "Create access key"
1. Download the `.csv` file containing the key and ID since it cannot be viewed on AWS again

### Setting up your credentials for the container

There is a folder in this repo called `docker/secrets` which is ignored by git.  This is where the scripts will look for your AWS credentials.  

Create the following **plain text** files containing your Access key ID and Access key respectively.  
- `docker/secrets/AWS_ACCESS_KEY_ID.txt`
- `docker/secrets/AWS_SECRET_ACCESS_KEY.txt`

## Using the environment

### Building the images

In order to run the project in a container, an image must first be built locally; which will contain all the required dependencies for the project.  

1. Open a terminal window
1. Change the directory to the root of this reposititory
1. Run the command `make bd` to build the project image

### Running the project

Once the project image has been built, the project can be started with a make target.  

1. Open a terminal window
1. Change the directory to the root of this reposititory
1. Run the command `make run` to run the project in a container using the pre-built image

### Other make commands

There are several other shortcuts packaged in the make file.  To avoid duplication of the documentaiton, the details can be displayed by running the `help` make target.  

1. Open a terminal window
1. Change the directory to the root of this reposititory (`/docker`)
1. Run the command `make help` to list the available make commands and their descriptions

### Using the local 'pg-db' database container

By default, this project connects to the AWS database.  To use the database packeged with the docker development environment, rename the `env.yml.example` file in the root of the project directory to `env.yml`.

### Modifying dependency lists

When dependency lists are updates (ie. package.json or requirements.txt), the containers need to be re-built using the new depencency lists.  Run the build command from above to re-build the images with the new depencencies.  

Fortunately, docker is able to cache parts of the build process, therefore it may be able to avoid building the images from scratch.  However, it is possible for a situation to occur where something is cached which is causing an issue with a new build.  To re-build the images without using the docker cache, run `make bd-f` from the root of the repo folder.  

## Useful Docker commands

`docker ps` - A list of all actively running containers and the local ports which have been exposed.  
`docker image ls` - A list of locally stored images
`docker logs <image name>` - get logs from a docker image
`docker inspect <container id>` - inspect container details
