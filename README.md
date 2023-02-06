# Testing breaking points so far

Sorting out validation errors looks no fun...
```json
{
  "validationErrors":[
    {
      "description":"{'HostConfig': {'PortBindings': {'5671/tcp': [{'HostPort': '5671'}], '8883/tcp': [{'HostPort': '8883'}], '443/tcp': [{'HostPort': '443'}]}}} is not of type 'string'",
      "contentPath":"modulesContent.$edgeAgent.properties.desired.systemModules.edgeHub.settings.createOptions",
      "schemaPath":"properties.modulesContent.properties.$edgeAgent.properties.properties.desired.properties.systemModules.properties.edgeHub.properties.settings.properties.createOptions.type"
    },
    {
      "description":"{} is not of type 'string'",
      "contentPath":"modulesContent.$edgeAgent.properties.desired.modules.tempSensor.settings.createOptions",
      "schemaPath":"properties.modulesContent.properties.$edgeAgent.properties.properties.desired.properties.modules.patternProperties.^[a-zA-Z0-9_-]+$.properties.settings.properties.createOptions.type"
    },
    {
      "description":"{} is not of type 'string'",
      "contentPath":"modulesContent.$edgeAgent.properties.desired.systemModules.edgeAgent.settings.createOptions",
      "schemaPath":"properties.modulesContent.properties.$edgeAgent.properties.properties.desired.properties.systemModules.properties.edgeAgent.properties.settings.properties.createOptions.type"
    }
  ]
}
```

# Notes

A bunch of missing pieces through these docs: 

This is the latest: 

https://learn.microsoft.com/en-us/azure/iot-edge/how-to-vs-code-develop-module?view=iotedge-1.4&branch=pr-en-us-203829&tabs=csharp&pivots=iotedge-dev-cli


Need this one: 

dotnet new aziotedgemodule --name SampleModule --repository acrlalala.azurecr.io/samplemodule


Build the docker image: 

`docker build --rm -f "./modules/filtermodule/Dockerfile.amd64.debug" -t acrlalala.azurecr.io/filtermodule:0.0.1-amd64 "./modules/filtermodule"`

 
Login 

`az acr login --name acrlalala --subscription "CSE Dev Crews Americas West"`

Build

`$ docker build --rm -f "./modules/SampleModule/Dockerfile.amd64.debug" -t acrlalala.azurecr.io/samplemodule:0.0.1-amd64 "./modules/SampleModule"`

And Push

`$ docker push acrlalala.azurecr.io/samplemodule:0.0.1-amd64`



And deploy 

```
az iot edge set-modules --hub-name iotHubDevOne --device-id edge-device-dev-1 --content ./deployment.debug.template.json --login "HostName=iotHubDevOne.azure-devices.net;SharedAccessKeyName=iothubowner;SharedAccessKey=<MYSECRET+pJfGY=>"
```




```


Port forward from our MQTT broker 

```
kubectl port-forward service/azedge-dmqtt-frontend 1883:30179
kubectl port-forward service/azedge-dmqtt-frontend :1883 --address 0.0.0.0
```

netstat -n -l -t -p

mosquitto_pub -h localhost -t "orders" -l -d -q 1 -i "publisher1" -u client1 -P password

docker run -it --name mosquitto -p 1883:1883 -v $(pwd)/mosquitto:/mosquitto/ eclipse-mosquitto 


sudo docker run -it -p 11883:1883 -p 9001:9001 -v $(pwd)/mosquitto:/mosquitto/ eclipse-mosquitto

/iot-hub-ecosystem/mqtt_python_sim$ sudo docker run -it -p 11883:1883 -p 9001:9001 -v $(pwd)/mosquitto:/mosquitto/ eclipse-mosquitto