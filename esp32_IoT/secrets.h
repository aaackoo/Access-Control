#ifndef SECRETS_H
#define SECRETS_H

// WiFi Credentials
const char* WIFI_SSID = "fiat_500";
const char* WIFI_PASS = "3824flat6";

// Azure Credentials
const char* MQTT_SERVER = "iot-hub-access-control-supej.azure-devices.net";
const char* DEVICE_ID = "05a6449b-3e82-423b-bfc4-c4716e97dab4";

// Valid for 1 year
const char* SAS_TOKEN = "SharedAccessSignature sr=iot-hub-access-control-supej.azure-devices.net%2Fdevices%2F05a6449b-3e82-423b-bfc4-c4716e97dab4&sig=VPrBlDe1vMrKIci%2BspQTBG7XnavEcN%2B2eBw1ikWaEd8%3D&se=1797013969";

#endif