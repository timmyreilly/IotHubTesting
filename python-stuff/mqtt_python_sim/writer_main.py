import paho.mqtt.client as mqtt
import time
import paho.mqtt.publish as publish

# publish.single("waveform_data", payload=str(1.0), qos=0, retain=False, hostname="localhost",
#     port=1232, client_id="", keepalive=60, will=None, auth={'username': 'client1', 'password': 'password'}, tls=None,
#     protocol=mqtt.MQTTv311, transport="tcp")

def on_connect(client, userdata, flags, rc):
    print("Connected with result code " + str(rc))

def on_publish(client, userdata, mid):
    print("Data published")

client = mqtt.Client()
client.on_connect = on_connect
client.on_publish = on_publish

client.connect("127.0.0.1")

# client.connect("127.0.0.1", port=1232, 60)
# client.connect("localhost", port=1883)
client.connect("127.0.0.1", port=11883)
client.loop_start()

waveform_data = [1.0, 2.0, 3.0, 4.0, 5.0]

for data in waveform_data:
    print("one more")
    client.publish("waveform_data", str(data))
    time.sleep(1)

client.loop_stop()
