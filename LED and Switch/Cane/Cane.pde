#include <ClickButton.h>
#include <RGBHueCycle.h>
#include <Stripes.h>

// constants won't change. They're used here to 
// set pin numbers:
const int buttonPin = 2;     // the number of the pushbutton pin
const int LeftRedPin = 9;
const int RightRedPin = 3;
const int UVPin = 7;
ClickButton button(buttonPin);
RGBHueCycle rgbHueCycle(5, 150, 5);
Stripes stripes(500); // Defaul stripe length

// Button
//ClickButton button(buttonPin, LOW);
int buttonState = 0;         // current command state
int lastButtonState = 0;     // checked against for changes in command state
const int BTN_CLICKED = 1;
const int BTN_DOUBLE_CLICK = 2;
const int BTN_HOLD = 3;
const int BTN_LONG_HOLD = 4;

// LEDs
int ledState = 0; // off
int maxLedState = 4;
long* rgb;
int UVState = LOW;


void setup() {
  // initialize the LED pins as outputs:
  pinMode(LeftRedPin+0, OUTPUT);
  pinMode(LeftRedPin+1, OUTPUT);
  pinMode(LeftRedPin+2, OUTPUT);
  
  pinMode(RightRedPin+0, OUTPUT);
  pinMode(RightRedPin+1, OUTPUT);
  pinMode(RightRedPin+2, OUTPUT);
  
  pinMode(UVPin, OUTPUT);
  
  // initialize the pushbutton pin as an input:
  pinMode(buttonPin, INPUT);
  Serial.begin(9600); 
}

void loop(){
  // read the state of the pushbutton value:
  int buttonState = button.check();
  
  //Serial.println(buttonState);
  //delay(10);
  
  if(buttonState == BTN_CLICKED)
  {
    ledState = ledState+1;
    if(ledState > maxLedState) {
      ledState = 0;
    }
    
    stripes.resetState();
    rgbHueCycle.resetState();
    
    Serial.println(ledState);
  }
  
  if(buttonState == BTN_DOUBLE_CLICK)
  {
    toggleUV();
  }
  
  switch(ledState)
  {
    case 0:
      allLedsOff();
      break;
    case 1:
      if(buttonState == BTN_CLICKED) stripes.setRGBStrobe();
      if(buttonState == BTN_HOLD ) stripes.setTOMStrobe();
      if(buttonState == BTN_LONG_HOLD ) stripes.setWhiteStrobe();
      
      rgb = stripes.getRGB();
      writeBothRGB(rgb);

      break;
    case 2:
      if(buttonState == BTN_HOLD)   rgbHueCycle.toggleStripes();
      if(buttonState == BTN_LONG_HOLD && lastButtonState != BTN_LONG_HOLD) rgbHueCycle.restartColorPicker();
      if(buttonState == BTN_LONG_HOLD) rgbHueCycle.updateRGB();
      
      writeBothRGB(rgbHueCycle.interrupt());

      break;
    case 3:
      if(buttonState == BTN_CLICKED) stripes.setWhite();
      if(buttonState == BTN_HOLD ) stripes.setCandyCane();
      if(buttonState == BTN_LONG_HOLD ) stripes.setAltCandyCane();

      writeBothRGB(stripes.getRGB());
      break;
    case 4:
      if(buttonState == BTN_CLICKED) stripes.setGreen();
      if(buttonState == BTN_HOLD ) stripes.setTurqGreenStripe();
      if(buttonState == BTN_LONG_HOLD ) stripes.setTurq();

      writeBothRGB(stripes.getRGB());
      break;
  }
  
  lastButtonState = buttonState;
}

void allLedsOff(){
  long off[3] = {0,0,0};
  writeBothRGB(off);
}

void writeRGB(long* rgb, int startingPin){
  int pin = startingPin;
  for (int k=0; k<3; k++) { // for all three RGB values
    if(pin == 4) pin++; // 4 is not a PWM pin. skip to 5 and 6.
    analogWrite(pin, rgb[k]);
    pin++;
  }
}

void writeBothRGB(long* rgb)
{
  writeRGB(rgb, LeftRedPin);
  writeRGB(rgb, RightRedPin);
}

void toggleUV()
{
  UVState = !UVState;
  digitalWrite(UVPin, UVState);
}
