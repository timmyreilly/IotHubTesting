import paho.mqtt.client as mqtt
import sys


# The callback for when a PUBLISH message is received from the server.
def on_message(client, userdata, msg):
    print(msg.topic+" "+str(msg.payload))

print("creating new client instance")
client = mqtt.Client()
client.on_message = on_message

print("connecting to broker")
if client.connect("localhost", 11883, 60) != 0:
    print("failed to connect to broker")
    sys.exit(1)


client.subscribe("test/status")



# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.
print("starting loop")
try: 
    print("press ctrl+c to exit")
    client.loop_forever()
except KeyboardInterrupt:
    print("exiting")

client.disconnect()




