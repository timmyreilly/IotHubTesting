Following this guide: 

https://sandervandevelde.wordpress.com/2021/02/10/using-influx-database-and-grafana-on-the-azure-iot-edge/

```json
{
    "HostConfig": {
        "Binds": [
            "/var/influxdb:/var/lib/influxdb"
        ],
        "PortBindings": {
            "8086/tcp": [
                {
                    "HostPort": "8086"
                }
            ]
        }
    }
}
```

Ssh into a vm: 

ssh conductor@20.125.140.165 


insert cpu,host=node1 value=10
insert cpu,host=node2 value=13
insert cpu,host=node3 value=15

show series

select * from cpu where host='node2'

select * from cpu where time >= now() - 3m


# Build Influx Module: 

Create blank one: 

dotnet new aziotedgemodule --name influx_module_v1 --repository acrrajohnson.azurecr.io/samplemodule

`docker build --rm -f "./modules/InfluxWriterModule/Dockerfile.amd64.debug" -t acrrajohnson.azurecr.io/influxwritermodule:0.0.1-amd64 "./modules/InfluxWriterModule"`

docker push
`docker push acrrajohnson.azurecr.io/influxwritermodule:0.0.1-amd64`


```C
   at InfluxDB.Collector.Configuration.AggregateEmitter.Emit(PointData[] points)
   at InfluxDB.Collector.Pipeline.Batch.IntervalBatcher.OnTick()
Received message with body: '{"machine":{"temperature":83.64527902363115,"pressure":8.136803939401016},"ambient":{"temperature":20.695606699770135,"humidity":25},"timeCreated":"2023-01-10T23:59:16.7318417Z"}'
entry saved.
Infux Error. Failed to emit metrics batch: System.AggregateException: One or more errors occurred. (Cannot assign requested address)
 ---> System.Net.Http.HttpRequestException: Cannot assign requested address
 ---> System.Net.Sockets.SocketException (99): Cannot assign requested address
   at System.Net.Http.ConnectHelper.ConnectAsync(String host, Int32 port, CancellationToken cancellationToken)
   --- End of inner exception stack trace ---
   at System.Net.Http.ConnectHelper.ConnectAsync(String host, Int32 port, CancellationToken cancellationToken)
```

