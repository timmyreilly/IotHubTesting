
```
$ ansible-playbook src/modules/windows_worker/build_infrastructure.yml -vv 
--extra-vars 
    '{
      "resource_group_name":"tim-rg-le", 
      "vnet_name":"vnet-le", 
      "subnet_name":"tim-rg-le-subnet-0", 
      "location":"westus", 
      "username":"braveheart", 
      "password":"P@ssword1234!", 
      "machine_name":"devWinTim",
      "machine_size":"Standard_DS4_v2", 
      "module_id":"" 
    }'
```

Probably want to create a network first... 
```
ansible-playbook src/modules/network/build_infrastructure.yml -vv --extra-vars '{"resource_group_name":"tim-rg-d", "vnet_name":"vnet-d", "subnet_address_spaces":"[\"10.191.1.0/24\",\"10.191.2.0/24\"]", "location":"westus", "module_id":"22", "vnet_address_space":"[\"10.191.0.0/16\"]" }'
```

or single line
```
ansible-playbook src/modules/windows_worker/build_infrastructure.yml -vv --extra-vars '{"resource_group_name":"tim-rg-d","vnet_name":"vnet-d", "subnet_name":"tim-rg-d-subnet-1", "location":"westus", "username":"braveheart","password":"P@ssword1234!", "machine_name":"devWinTima", "machine_size":"Standard_D8s_v3", "module_id":"34" }' -vv
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
    "RESOURCE_GROUP_NAME": "tim-rg-le",
    "VNET_NAME": "vnet-le",
    "SUBNET_NAME": "tim-rg-le-subnet-0",
    "MACHINE_USERNAME": "braveheart",
    "MACHINE_PASSWORD": "P@ssword1234!",
    "MACHINE_NAME": "AutoUbuTwo",
    "MACHINE_SIZE": "Standard_DS4_v2",
    "TAG_ENVIRONMENT": "dev"
    "MODULE_ID": "421" # REMOVE MODULE_ID IF DEPLOYING NET NEW MODULE AND AN ID WILL BE ASSIGNED, OR PASS A THREE DIGIT INTEGER AS A STRING TO SPECIFY AN ID OR TARGET AN EXISTING DEPLOYMENT
  },
  "variables": {}
}
``` 

Approximate Endpoint minus BUILD_NUMBER_ID 

https://{{coreServer}}/{{organization}}/{{project}}/_apis/pipelines/BUILD_NUMBER_ID/runs?api-version={{api-version-preview}}


# TODO 

Figure out how to get this into edit. Need to get the cluster connected to ARC and then we can get the credentials for the Cluster and then do the CRD edit. 

 kubectl --namespace kubevirt edit kubevirt kubevirt

spec:
  certificateRotateStrategy: {}
  configuration:
    developerConfiguration:
      useEmulation: true
