import paho.mqtt.client as mqtt
import matplotlib.pyplot as plt
import numpy as np
import sqlite3

# MQTT Connection Information
MQTT_BROKER = "127.0.0.1"
MQTT_PORT = 11883
MQTT_TOPIC = "waveform_data"

# SQL Connection Information
SQL_DB = "waveform_data.db"
SQL_TABLE_RAW = "raw_data"
SQL_TABLE_BAD = "bad_form"

def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))
    client.subscribe(MQTT_TOPIC)

def on_message(client, userdata, msg):
    print("data received: " + str(msg.payload))
    data = np.fromstring(msg.payload, dtype=float, sep=',')

    # Write to SQL
    conn = sqlite3.connect(SQL_DB)
    cur = conn.cursor()
    cur.execute("INSERT INTO raw_data (waveform) VALUES (?)", (data.tobytes(),))
    conn.commit()
    conn.close()

    # Plot data
    plt.plot(data)
    plt.show()

    # Evaluate against anti-patterns
    evaluate_waveform(data)

def evaluate_waveform(data):
    conn = sqlite3.connect(SQL_DB)
    cur = conn.cursor()
    cur.execute("SELECT waveform FROM bad_form")
    bad_waveforms = cur.fetchall()
    conn.close()

    for bad_waveform in bad_waveforms:
        bad_waveform = np.frombuffer(bad_waveform[0], dtype=float)
        if np.array_equal(data, bad_waveform):
            print("Matching anti-pattern found.")
            return
    print("No matching anti-patterns found.")

print("Starting MQTT reader...")
client = mqtt.Client("waveform_data")
client.on_connect = on_connect
client.on_message = on_message

client.connect(MQTT_BROKER, MQTT_PORT, 60)

# Ensure SQL tables exist
conn = sqlite3.connect(SQL_DB)
cur = conn.cursor()
cur.execute(f"CREATE TABLE IF NOT EXISTS {SQL_TABLE_RAW} (timestamp DATETIME DEFAULT CURRENT_TIMESTAMP, waveform BLOB)")
cur.execute(f"CREATE TABLE IF NOT EXISTS {SQL_TABLE_BAD} (waveform BLOB)")
conn.commit()
conn.close()

print("Starting MQTT loop...")

client.loop_forever()