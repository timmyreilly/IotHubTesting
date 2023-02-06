# From Dev Machine: 

Create New Basic Network 
```
$ ansible-playbook src/modules/network/build_infrastructure.yml -vv --extra-vars '{"resource_group_name":"tim-rg-d", "vnet_name":"vnet-d", "subnet_address_spaces":"[\"10.191.1.0/24\",\"10.191.2.0/24\"]", "location":"westus", "module_id":"", "vnet_address_space":"[\"10.191.0.0/16\"]" }'
```

Upgrade Existing Network

```
$ ansible-playbook src/modules/network/build_infrastructure.yml -vv --extra-vars '{"resource_group_name":"tim-rg-d", "vnet_name":"vnet-d", "subnet_address_spaces":"[\"10.191.1.0/24\",\"10.191.2.0/24\"]", "location":"westus", "module_id":""EXISTING_MODULE_ID"", "vnet_address_space":"[\"10.191.0.0/16\"]" }'
```

# From Devops API (after pipeline creation):
```
{
  "resources": {
    "repositories": {
      "self": {
        "refName": "refs/heads/master"
      }
    }
  },
  "templateParameters": { 
    "REGION": "westus",
    "RESOURCE_GROUP_NAME": "tim-rg-dev",
    "VNET_NAME": "vnet-dev",
    "NETWORK_VNET_ADDRESS_SPACE": "[\\\"10.194.0.0/16\\\"]",
    "NETWORK_SUBNETS": "[\\\"10.194.1.0/24\\\",\\\"10.194.2.0/24\\\"]",
    "TAG_ENVIRONMENT": "dev",
    "MODULE_ID": "" # REMOVE MODULE_ID IF DEPLOYING NET NEW MODULE AND AN ID WILL BE ASSIGNED, OR PASS A THREE DIGIT INTEGER AS A STRING TO SPECIFY AN ID OR TARGET AN EXISTING DEPLOYMENT
  },
  "variables": {}
}
``` 

Approximate Endpoint minus BUILD_NUMBER_ID 

https://{{coreServer}}/{{organization}}/{{project}}/_apis/pipelines/BUILD_NUMBER_ID/runs?api-version={{api-version-preview}}