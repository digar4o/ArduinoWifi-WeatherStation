#include "DHT.h"

#define DHTPIN 4   
#include <SFE_BMP180.h>
#include <Wire.h>

#define DHTTYPE DHT22   
#define ALTITUDE 23
DHT dht(DHTPIN, DHTTYPE);
int x;
SFE_BMP180 pressure;
int temp;
int pres;
int sense0 = 2;
int counter0 = 0;
long lastDebounce0 = 0;
static int wind;
long debounceDelay = 15;  
double calculated = 0;
double calculated1 = 0;
int humi;
int t;
String request = "";
void setup(){
  pinMode(sense0, INPUT);
  digitalWrite(sense0, HIGH);
  attachInterrupt(0, trigger0, FALLING);  
  char status;
  double T,P,p0,a;
  
 
  delay(10000);
  calculated = (counter0 /2) * 6;
  calculated1 = -2.199e-08 * pow(calculated,3) + 5.088e-05 * pow(calculated, 2) + 0.02575 * calculated +  0.00868;
  counter0 = 0;
  wind = (int) calculated1;
  noInterrupts(); 
   
  Serial.begin(9600);   

  int h = dht.readHumidity();

   t = dht.readTemperature();
  float f = dht.readTemperature(true);
  
  // Check if any reads failed and exit early (to try again).
  if (isnan(h) || isnan(t) || isnan(f)) {

    return;
  }

  // Compute heat index
  // Must send in temp in Fahrenheit!
  float hi = dht.computeHeatIndex(f, h);
  
  pressure.begin();


// Print out the measurement:
  status = pressure.startTemperature();
 delay(status);
 status = pressure.getTemperature(T);

       status = pressure.startPressure(3);
       
       delay(status);
     status = pressure.getPressure(P,T);
     
          // Print out the measurement:
    

          // The pressure sensor returns abolute pressure, which varies with altitude.
          // To remove the effects of altitude, use the sealevel function and your current altitude.
          // This number is commonly used in weather reports.
          // Parameters: P = absolute pressure in mb, ALTITUDE = current altitude in m.
          // Result: p0 = sea-level compensated pressure in mb

          p0 = pressure.sealevel(P,ALTITUDE); // we're at 1655 meters (Boulder, CO)
          
      
        temp = T + 0.5;
        pres = p0 + 0.5;
        humi = h + 0.5;
  


}


void loop() 
{
  
  
    if(Serial.available() > 0)
    {
        request = Serial.readStringUntil('\n');
      
            if (request== "pres") {
              
             Serial.print(pres); 
            }
             else if (request== "temp") {
              
             Serial.print(temp); 
            }
             else if (request== "humi") {
              
             Serial.print(humi); 
            }
             else if (request== "wind") {
              
             Serial.print(wind); 
            }
    }
request = "";    
Serial.flush();

}

void trigger0() {
  if( (millis() - lastDebounce0) > debounceDelay){
    counter0++;
    lastDebounce0 = millis();
  }}
