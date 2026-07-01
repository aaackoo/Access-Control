#include <Wire.h>
#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <PubSubClient.h>
#include <Adafruit_NeoPixel.h>
#include "SparkFun_ST25DV64KC_Arduino_Library.h"

// API KEYs etc...
#include "secrets.h" 

// CONFIG FOR RGB LED
#define RGB_PIN 2 // Built-in WS2812
#define NUM_PIXELS 1
Adafruit_NeoPixel pixels(NUM_PIXELS, RGB_PIN, NEO_GRB + NEO_KHZ800);

// OBJECTS
SFE_ST25DV64KC_NDEF nfcTag;
WiFiClientSecure espClient;
PubSubClient client(espClient);

const char* topic_methods_sub = "$iothub/methods/POST/#";

void setLedColor(int r, int g, int b) {
  pixels.setPixelColor(0, pixels.Color(r, g, b));
  pixels.show();
}

void azureCallback(char* topic, byte* payload, unsigned int length) {
  String topicStr = String(topic);
  Serial.print("\nMessage received: "); Serial.println(topicStr);

  if (topicStr.startsWith("$iothub/methods/POST/")) {
    String rid = topicStr.substring(topicStr.indexOf("rid=") + 4);
    String methodName = topicStr.substring(21, topicStr.indexOf("/?"));

    if (methodName == "unlock") {
        Serial.println("ACCESS GRANTED");
        
        // GREEN FOR 3 SECONDS
        setLedColor(0, 255, 0); // Green
        delay(3000);
        setLedColor(0, 0, 0); // Off
        
        String responseTopic = String("$iothub/methods/res/200/?$rid=") + rid;
        client.publish(responseTopic.c_str(), "{\"success\":true}");
        
    } else if (methodName == "deny") {
        Serial.println("ACCESS DENIED");

        // FLASH RED 3 TIMES
        for(int i=0; i<3; i++) {
          setLedColor(255, 0, 0); // Red
          delay(200);
          setLedColor(0, 0, 0); // Off
          delay(200);
        }
        
        String responseTopic = String("$iothub/methods/res/200/?$rid=") + rid;
        client.publish(responseTopic.c_str(), "{\"success\":true, \"status\":\"denied\"}");
    } else {
        String responseTopic = String("$iothub/methods/res/404/?$rid=") + rid;
        client.publish(responseTopic.c_str(), "{}");
    }
  }
}

void setupNFC() {
  Wire.begin();
  if (nfcTag.begin()) {
    nfcTag.writeCCFile8Byte();
    uint16_t address = 8;
    nfcTag.writeNDEFText(DEVICE_ID, &address); 
  }
}

void reconnectMQTT() {
  while (!client.connected()) {
    Serial.print("Connecting to Azure...");
    String username = String(MQTT_SERVER) + "/" + String(DEVICE_ID) + "/?api-version=2018-06-30";

    if (client.connect(DEVICE_ID, username.c_str(), SAS_TOKEN)) {
      Serial.println(" Connected!");
      client.subscribe(topic_methods_sub);
    } else {
      Serial.print(" Failed (rc="); Serial.print(client.state()); Serial.println(") - Retrying...");
      delay(5000);
    }
  }
}

void setup() {
  Serial.begin(115200);
  
  // INIT RGB LED
  pixels.begin();
  pixels.setBrightness(50); // 0-255 (Keep it low, they are bright)
  setLedColor(0, 0, 255); // Blue = Booting up

  setupNFC();

  Serial.print("Connecting to "); Serial.println(WIFI_SSID);
  WiFi.begin(WIFI_SSID, WIFI_PASS);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nWiFi Connected");

  espClient.setInsecure();
  client.setBufferSize(2048);
  client.setServer(MQTT_SERVER, 8883);
  client.setCallback(azureCallback);

  setLedColor(0, 0, 0); // Turn off Blue when ready
}

void loop() {
  if (!client.connected()) {
    setLedColor(255, 165, 0); // Orange = Lost Connection
    reconnectMQTT();
    setLedColor(0, 0, 0); // Off = Connected & Idle
  }
  client.loop();
}