# Combined Pipeline for AMIs with Blue-Green Deployments

This folder contains files that can create a pipeline that builds, bakes, and deploys AMIs.

This directory contains the following files:
- [*pipelinespec.yaml*](./pipelinespec.yaml): a pipeline spec for a complete pipeline that builds the application, bakes an AMI from it, and deploys it to an EC2 autoscaling group.
- [*ami_bake.yaml*](./ami_bake.yaml): a component definition file for an AMI bake component.
    This is different from the *custom_bake.yaml* file in other examples as it includes the security groups and environment variables necessary for Packer to work inside CodeBuild. 
- [*bakespec.yaml*](./bakespec.yaml): a CodeBuild spec file that contains the instructions for the bake, such as creating the AMI and preparing the DeploySpec for the deploy stage.
- [*DeploySpec.yaml*](./DeploySpec.yaml): the DeploySpec.yaml file that defines the deployment.
    This differs from the other deployspec files here since it uses the *blue green deployer*, and it uses the `ec2` built-in stack.

You may notice that the *buildspec.yml* and *custom_bake.yaml* files are missing here.
This is because this pipeline shares the same build stage as the *combined-pipeline-rolling-ecs* example.
This shows that the same build stage can be used for both producing AMIs and containers.

## Details

The pipelines in this folder demonstrate that Project Cumulus is capable of building, baking, and deploying AMIs from start to finish.

The main difference between this pipeline and the bluegreen combined pipeline is in the bake stage.
The bake stage differs significantly in that it uses a completely separate bake component (*ami_bake.yaml*).
This is necessary since baking an AMI requires several extra security groups and environment variables that are not available in the standard custom bake component.

The bake spec also differs significantly.
Instead of a simple bake that builds a container and pushes those containers out to different repositories, this bake spec
uses [*Packer*](https://www.packer.io/intro) to stand up an EC2 instance, install the application on that instance, create an AMI out of that instance, and then share and copy those AMIs with other
accounts and regions as necessary.

Unlike in a container build, the specification for an AMI build lies in the *ami/* folder at the root of the repository.
That folder contains the Packer files, [Ansible](https://docs.ansible.com/ansible/latest/user_guide/intro.html) files, and auxillary scripts necessary for the AMI bake to work.

The final difference is in the DeploySpec. The deploy spec here uses the built-in EC2 auto-scaling group stack in order to deploy.
This stack has different parameters than the ECS-on-EC2 stack.
This not only has an effect on the deploy spec, but on the bake spec as well, since the bake spec needs to be modified such that the bake outputs are piped into the right
spot in the DeploySpec (e.g., supplying an AMI instead of supplying a container image)

## Deploying Cumulus Pipeline

Use the pipeline generator in the cumulus tool.

Prerequisite:
```
pip install -U --extra-index-url https://tr1.jfrog.io/tr1/api/pypi/pypi-local/simple cumulus-cli
```

Dev Pipeline in Prod CI/CD Account:

```
cumulus pipelines generate -i .\pipelinespec-dev.yaml -o .\gtm-web_pipeline_cfn_dev.yaml

cloud-tool --profile "tr-integrationpoint-cicd-prod" --region us-east-1 login --role human-role/a205822-PowerUser2 --account-id 918544005421

aws --profile tr-integrationpoint-cicd-prod --region us-east-1 cloudformation deploy --template .\gtm-web_pipeline_cfn_dev.yaml --stack-name a205822-gtm-web-role-pipeline-dev --tags "tr:application-asset-insight-id=205822" "tr:resource-owner=gcrt.devops@thomsonreuters.com" "tr:environment-type=PRE-PRODUCTION" --capabilities CAPABILITY_IAM
```

Prod Pipeline in Prod CI/CD Account:

```
cumulus pipelines generate -i .\pipelinespec-prd.yaml -o .\gtm-web_pipeline_cfn_prod.yaml

cloud-tool --profile "tr-integrationpoint-cicd-prod" --region us-east-1 login --role human-role/a205822-PowerUser2 --account-id 918544005421

aws --profile tr-integrationpoint-cicd-prod --region us-east-1 cloudformation deploy --template .\gtm-web_pipeline_cfn_prod.yaml --stack-name a205822-gtm-web-role-pipeline-prod --tags "tr:application-asset-insight-id=205822" "tr:resource-owner=gcrt.devops@thomsonreuters.com" "tr:environment-type=PRODUCTION" --capabilities CAPABILITY_IAM
```