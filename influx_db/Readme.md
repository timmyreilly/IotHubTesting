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

