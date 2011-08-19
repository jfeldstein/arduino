#include <RGBHueCycle.h>
#include <RGBStrober.h>

// constants won't change. They're used here to 
// set pin numbers:
const int buttonPin = 2;     // the number of the pushbutton pin
const int REDPin = 9;
const int GREENPin = 10;
const int BLUEPin = 11;
RGBStrober rgbStrober(REDPin, BLUEPin, GREENPin, 10);
RGBHueCycle rgbHueCycle(REDPin, 5);

// Button
int buttonState = 0;         // current command state
int lastButtonState = 0;     // checked against for changes in command state

// Debounce
// the following variables are long's because the time, measured in miliseconds,
// will quickly become a bigger number than can be stored in an int.
long lastDebounceTime = 0;  // the last time the output pin was toggled
long debounceDelay = 50;    // the debounce time; increase if the output flickers
int lastReading = 0;

// LEDs
int ledState = 0; // off
int maxLedState = 5;

void setup() {
  // initialize the LED pins as outputs:
  pinMode(REDPin, OUTPUT);
  pinMode(BLUEPin, OUTPUT);
  pinMode(GREENPin, OUTPUT);
  
  // initialize the pushbutton pin as an input:
  pinMode(buttonPin, INPUT);    
  Serial.begin(9600); 
}

void loop(){
  // read the state of the pushbutton value:
  int reading = digitalRead(buttonPin);

  // If button has changed this loop, reset counter
  if(reading != lastReading)
  {
    lastDebounceTime = millis();
  }  
  
  // Button has stayed the same for long enough for us to say 
  //  that the button is either pushed or released, not bouncing
  if((millis() - lastDebounceTime) > debounceDelay) {
    buttonState = reading;
  }
  
  if(buttonState != lastButtonState)
  {
    lastButtonState = buttonState;
    
    if(buttonState == HIGH)
    {
      ledState = ledState+1;
      if(ledState > maxLedState) {
        ledState = 0;
      }
      Serial.println(ledState);
    }
  }
  
  switch(ledState)
  {
    case 0:
      allLedsOff();
      break;
    case 1:
      rgbStrober.interrupt();
      break;
    case 2:
      rgbHueCycle.interrupt();
      break;
    case 3:
      turquoise();
      break;
    case 4:
      orange();
      break;
    case 5:
      magenta();
      break;
  }
  
  lastReading = reading;
}

void allLedsOff(){
  digitalWrite(REDPin, LOW);
  digitalWrite(BLUEPin, LOW);
  digitalWrite(GREENPin, LOW);
}

void turquoise() {
  int rgb[3] = {0,206, 209};
  writeRGB(rgb);
}

void orange() {
  int rgb[3] = {215, 250, 0};//{255, 165, 0};
  writeRGB(rgb);
}

void magenta() {
  int rgb[3] = {200, 0, 255};//{139, 0, 139};
  writeRGB(rgb);
}

void writeRGB(int* rgb){
    for (int k=0; k<3; k++) { // for all three RGB values
    analogWrite(REDPin + k, rgb[k]);
  }
}
