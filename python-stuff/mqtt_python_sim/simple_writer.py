
import paho.mqtt.client as mqtt 
from random import randrange, uniform
import time

mqttBroker ="127.0.0.1" 

client = mqtt.Client()
client.connect(mqttBroker, 11883) 

while True:
    randNumber = uniform(20.0, 21.0)
    client.publish("test/status", randNumber)
    print("Just published " + str(randNumber) + " to topic waveform_data")
    time.sleep(1)