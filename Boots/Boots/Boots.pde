
void setup() {
  // initialize the LED pins as outputs:
  pinMode(RedPin+0, OUTPUT);
  pinMode(RedPin+1, OUTPUT);
  pinMode(RedPin+2, OUTPUT);
  
  pinMode(FlexPin, INPUT);
  
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
