
```
$ ansible-playbook src/modules/ubuntu_worker/build_infrastructure.yml -vv 
--extra-vars 
    '{
        "resource_group_name":"tim-rg-eight", 
        "vnet_name":"vnet-eight", 
        "subnet_name":"tim-rg-eight-subnet-0", 
        "location":"westus", 
        "username":"braveheart", 
        "password":"P@ssword1234!", 
        "machine_name":"devUbuntu", 
        "machine_size":"Standard_DS4_v2", 
        "module_id": ""
    }'
```

or single line
```
ansible-playbook src/modules/ubuntu_worker/build_infrastructure.yml -vv --extra-vars '{"resource_group_name":"tim-rg-d", "vnet_name":"vnet-eight", "subnet_name":"tim-rg-d-subnet-0", "location":"westus", "username":"braveheart", "password":"P@ssword1234!", "machine_name":"devUbuntu3", "machine_size":"Standard_B2s", "module_id", "111" }' -vv

```

From Devops API (after pipeline creation):
```
{
  "resources": {
    "repositories": {
      "self": {
        "refName": "refs/heads/feature/basic-ubuntu-module"
      }
    }
  },
  "templateParameters": { 
    "REGION": "westus",
    "RESOURCE_GROUP_NAME": "tim-rg-eight",
    "VNET_NAME": "vnet-eight",
    "SUBNET_NAME": "tim-rg-eight-subnet-0",
    "MACHINE_USERNAME": "braveheart",
    "MACHINE_PASSWORD": "P@ssword1234!",
    "MACHINE_NAME": "AutoUbuntuTwo",
    "MACHINE_SIZE": "Standard_DS4_v2",
    "TAG_ENVIRONMENT": "dev"
    "MODULE_ID": "" # REMOVE MODULE_ID IF DEPLOYING NET NEW MODULE AND AN ID WILL BE ASSIGNED, OR PASS A THREE DIGIT INTEGER AS A STRING TO SPECIFY AN ID OR TARGET AN EXISTING DEPLOYMENT
  },
  "variables": {}
}
``` 

Approximate Endpoint minus BUILD_NUMBER_ID 

https://{{coreServer}}/{{organization}}/{{project}}/_apis/pipelines/BUILD_NUMBER_ID/runs?api-version={{api-version-preview}}