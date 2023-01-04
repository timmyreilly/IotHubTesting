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

