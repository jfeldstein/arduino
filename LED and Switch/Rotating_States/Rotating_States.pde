// constants won't change. They're used here to 
// set pin numbers:
const int buttonPin = 2;     // the number of the pushbutton pin
const int ledPin =  10;      // the number of the LED pin

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
int maxLedState = 1;

void setup() {
  // initialize the LED pin as an output:
  pinMode(ledPin, OUTPUT);      
  // initialize the pushbutton pin as an input:
  pinMode(buttonPin, INPUT);    
  Serial.begin(9600); 
  Serial.println(ledState);
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
      digitalWrite(ledPin, HIGH);
      break;
  }
  
  lastReading = reading;
}

void allLedsOff(){
  digitalWrite(ledPin, LOW);
}
