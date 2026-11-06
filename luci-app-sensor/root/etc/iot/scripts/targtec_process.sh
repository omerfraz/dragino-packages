#!/bin/sh
# IoT Server = TARGTEC: publish every local channel to the TARGTEC MQTT broker.
# It is the stock mqtt_process.sh run with the "targtec" server preset (/etc/config/mqtt, section servers.targtec):
#   broker track.targtec.com:1883, topic CLIENTID/CHANNEL/data, data DATA.
# User Name / Password / Client ID still come from Sensor > MQTT (an account from the server's MQTT Settings page;
# Client ID = this gateway's name). Each channel's Remote ID is the IoT device access token on the server.
uci -q set mqtt.general.server_type=targtec
uci -q commit mqtt
exec /etc/iot/scripts/mqtt_process.sh
