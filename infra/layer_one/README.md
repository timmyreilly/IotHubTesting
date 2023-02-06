# Azdo-Modular-Infrastructure-Pipelines

### Main Build Status 

[![Build Status](https://dev.azure.com/csebraveheart/Azdo-Modular-Infrastructure-Pipelines/_apis/build/status/Pre-provisioning?branchName=main)](https://dev.azure.com/csebraveheart/Azdo-Modular-Infrastructure-Pipelines/_build/latest?definitionId=36&branchName=main)

### Staging Build Status 
[![Build Status](https://dev.azure.com/csebraveheart/Azdo-Modular-Infrastructure-Pipelines/_apis/build/status/staging-pre-provisioning?branchName=staging)](https://dev.azure.com/csebraveheart/Azdo-Modular-Infrastructure-Pipelines/_build/latest?definitionId=38&branchName=staging)
- ^ *This would be a customer's first edit* 

  
## Summary 

This solution was designed to support infrastructure 'module' development for Azure. It supports developers with a platform for flexible deployment methodologies. Provided in this repository is a sample of techniques and core infrastructure required for an API that triggers Azure Devops Build Pipelines for managing Azure Resources. The solution was designed to expose pipelines in a secure and extensible way providing customization for any client application and backend requirements.  

One of the key features of this solution is the ability to manage resources in a private network. The solution can be configured to isolate execution to a private azdo agent, which becomes the exclusive entry-point to a customer architecture. 

The solution is still under development, but is ready for deployment and module creation in development subscriptions.  

To deploy the solution your team will need an Azure Devops organization an Azure Key Vault with service principal credentials provisioned and to create and trigger the pre-provisioning azure pipeline. (See demo video)

To add modules to your solution, create a pipeline in Azure Devops and point to the already existing yaml in each module. (prefixed with 'azdo-' as a convention)

We also recommended watching our video for deployment instructions here: [private demo video](https://msit.microsoftstream.com/video/2d40a1ff-0400-9fb2-790d-f1eb04dc9df9)

And if you have any questions feel free to reach out directly to the team. 

### Contents of this repository include a number of patterns for building with Azure Devops:  

- Deploying idempotent network configuration using terraform and ansible: [network module](src/modules/network/)

- Creating a vm to host an Azure Devops Private Agent with Ansible: [ubuntu azdo agent](src/modules/ubuntu_azdo_agent)

- Creating a an ubuntu vm with terraform and configuring post deployment with ansible: [ubuntu worker](src/modules/ubuntu_worker)

- Creating a new windows vm with terraform, configuring winrm, and configuring post deployment with ansible: [windows machine ready for config](src/modules/windows_worker)

- Measuring network throughput on the azure backbone with go: [network tests](src/network-tests)

## Running and Developing Modules

Dependencies: 
- A linux terminal with Python 3.6+ and pip or docker or see run with docker below. 
    - To get up and running with WSL see Reference Material > [Getting started with WSL for Python3 and Pip3](#getting-started-with-wsl-for-python3-and-pip3) 

1. Create and activate virtual env 
    - `python3 -m venv venv` 
    - `source venv/bin/activate` 
1. Install project dependencies with pip
`pip install -r requirements.txt`
1. Install ansible: `pip3 install ansible` 
1. Validate ansible installation
`ansible --version` 
1. Run `sudo ./ubuntu_host_setup.sh` 
1. export SECRETS/Subscription information, app-insights keys, and debugging level/format. 

```
Sample ENV File
export ANSIBLE_STDOUT_CALLBACK=debug
export SUBSCRIPTION_NAME=whgriffi 
export STORAGE_ACCOUNT_NAME=corestorageaccountwus 
export CONTAINER_NAME=state 
export ARM_TENANT_ID=SECRET86f1-41af-91ab-2d7cd011db47
export ARM_CLIENT_SECRET=SECRETKwfFd~FRKkmvb8h7Qu8A_8xbW
export ARM_CLIENT_ID=SECRET56ef-4c21-bae6-a6c32c7cb9c5
export ARM_SUBSCRIPTION_ID=SECRET1982-4b4d-9efa-a9b845a55b13
export ARM_ACCESS_KEY=SECRETxfghAvvsFF9OqWeVNs5zEpWYpvRF15StV1j7Mch93kjRw6F+k12v0RZrL7xlufKl9H5KRagcmk9SA== 
```
Then you can run any playbook in the solution...
See example usage in each module:
- [network module example usage](/src/modules/network/example_usage.md) 
- [ubuntu worker example usage](/src/modules/ubuntu_worker/example_usage.md)

After code is validated locally or in a jumpbox, you can commit and deploy to azure devops using Azure Pipelines, this requires opening the organization and adding a pipeline and pointing to the existing azdo pipeline yaml in the module.  (prefixed 'azdo-' by convention)



# Reference Material: 

## Getting started with WSL for Python3 and Pip3 

Install ubuntu 18.04 distribution on your windows machine using these instructions: 
Connect to that machine
```
> wsl --set-default Ubuntu-18.04
> bash 
```

Run these commands in your new linux shell 

```
$ sudo apt-get update && sudo apt-get upgrade
$ sudo apt install software-properties-common
$ sudo apt-get install gcc libpq-dev build-essential libssl-dev libffi-dev -y
$ sudo apt-get install python3-pip python3-venv -y
```

Create a virtual environment 

```
$ python3 -m venv venv 
$ source venv/bin/activate 
$ pip3 install wheel
$ pip3 list 
```

Now you can install ansible or a `requirements.txt` or ansible directly 

```
$ pip3 install ansible 
$ pip3 install -r requirements.txt
```

# Troubleshooting 

*tip for use: 'ctrl+f' and enter a piece of the error you've run into to see if it's a known development workaround*

### Failing to update

```
fatal: [localhost]: FAILED! => {"changed": false, "msg": "Failed to update apt cache: E:Release file for https://packages.microsoft.com/repos/microsoft-ubuntu-focal-prod/dists/focal/InRelease is not valid yet (invalid for another 4d 7h 57min 18s). Updates for this repository will not be applied., E:Release file for https://packages.microsoft.com/ubuntu/20.04/prod/dists/focal/InRelease is not valid yet (invalid for another 4d 7h 57min 18s). Updates for this repository will not be applied., E:Release file for http://security.ubuntu.com/ubuntu/dists/focal-security/InRelease is not valid yet (invalid for another 5d 9h 26min 26s). Updates for this repository will not be applied., E:Release file for http://ppa.launchpad.net/deadsnakes/ppa/ubuntu/dists/focal/InRelease is not valid yet (invalid for another 3d 8h 49min 43s). Updates for this repository will not be applied., E:Release file for http://archive.ubuntu.com/ubuntu/dists/focal-updates/InRelease is not valid yet (invalid for another 5d 9h 27min 39s). Updates for this repository will not be applied., E:Release file for http://archive.ubuntu.com/ubuntu/dists/focal-backports/InRelease is not valid yet (invalid for another 5d 9h 29min 11s). Updates for this repository will not be applied."}
```

Probably need to reset your clock: `sudo hwclock -s`


### Unauthorized to blob storage: 

```
    Error: Failed to get existing workspaces: containers.Client#ListBlobs: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthenticationFailed" Message="Server failed to authenticate the request. Make sure the value of Authorization header is formed correctly including the signature.\nRequestId:662d6d2f-b01e-0026-2d7c-2c923c000000\nTime:2023-01-20T03:07:04.0516568Z"
```

Probably need to update your clock...

`sudo hwclock -s`

Or go get another connection string to your state directory and add it to your environment from the portal. 

### "Already a resource with that name created"

Might need to update the name of the resource and the moduleId, the previous deployment was borked because someone changed the state of infrastructure without using terraform. But it's no big deal. Just redeploy the module. and update the resource name or wait for it to be deleted and either way update the module id. 

```
    Error: Backend configuration changed
  
    A change in the backend configuration has been detected, which may require
    migrating existing state.
  
    If you wish to attempt automatic migration of the state, use "terraform init
    -migrate-state".
    If you wish to store the current configuration with no changes to the state,
    use "terraform init -reconfigure".
```

### "Unable to connect to windows machine after deployment"

Need to update the port rules if you turned on Just in time access

```
Max retries exceeded with url: /wsman (Caused by ConnectTimeoutError
```

Add inbound port rule

Your ip address. to 5986 you can find your ip address with ifconfig from powershell, use your JIT ip address in the azure portal, but change the port. Or visit a 'what is my ip' website

### 
