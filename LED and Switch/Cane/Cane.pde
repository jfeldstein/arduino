#include <ClickButton.h>
#include <RGBHueCycle.h>
#include <Stripes.h>

// constants won't change. They're used here to 
// set pin numbers:
const int buttonPin = 2;     // the number of the pushbutton pin
const int LeftRedPin = 9;
const int RightRedPin = 3;
const int UVPin = 7;
RGBHueCycle rgbHueCycle(5, 150);
Stripes stripes(500); // Defaul stripe length

// Button
ClickButton button(buttonPin);
int buttonState = 0;         // current command state
int lastButtonState = 0;     // checked against for changes in command state


// LEDs
int ledState = 0; // off
int maxLedState = 4;
long* rgb;

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
  int buttonState = button.Update();
  
  if(buttonState == CLICK_SINGLECLICKED)
  {
    ledState = ledState+1;
    if(ledState > maxLedState) {
      ledState = 0;
    }
    Serial.println(ledState);
  }
  
  switch(ledState)
  {
    case 0:
      allLedsOff();
      break;
    case 1:
      if(buttonState == CLICK_SINGLECLICKED) stripes.setRGBStrobe();
      if(buttonState == CLICK_SINGLEHOLD ) stripes.setTOMStrobe();
      if(buttonState == CLICK_DOUBLEHOLD ) stripes.setWhiteStrobe();
      
      rgb = stripes.getRGB();
      writeBothRGB(rgb);

      break;
    case 2:
      if(buttonState != CLICK_SINGLECLICKED) rgbHueCycle.reset();
      if(buttonState == CLICK_SINGLEHOLD)   rgbHueCycle.toggleStripes();
      if(buttonState == CLICK_DOUBLEHOLD && lastButtonState != CLICK_DOUBLEHOLD) rgbHueCycle.restartColorPicker();
      if(buttonState == CLICK_DOUBLEHOLD) rgbHueCycle.updateRGB();
      
      writeBothRGB(rgbHueCycle.interrupt());

      break;
    case 3:
      if(buttonState == CLICK_SINGLECLICKED) stripes.setWhite();
      if(buttonState == CLICK_SINGLEHOLD ) stripes.setCandyCane();
      if(buttonState == CLICK_DOUBLEHOLD ) stripes.setAltCandyCane();

      writeBothRGB(stripes.getRGB());
      break;
    case 4:
      if(buttonState == CLICK_SINGLECLICKED) stripes.setGreen();
      if(buttonState == CLICK_SINGLEHOLD ) stripes.setTurqGreenStripe();
      if(buttonState == CLICK_DOUBLEHOLD ) stripes.setTurq();

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
