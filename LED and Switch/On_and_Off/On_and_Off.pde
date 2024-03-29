// constants won't change. They're used here to 
// set pin numbers:
const int buttonPin = 2;     // the number of the pushbutton pin
const int ledPin =  10;      // the number of the LED pin

// variables will change:
int buttonState = 0;         // variable for reading the pushbutton status
int ledState = 0; // off
int lastButtonState = 0; // Not press

void setup() {
  // initialize the LED pin as an output:
  pinMode(ledPin, OUTPUT);      
  // initialize the pushbutton pin as an input:
  pinMode(buttonPin, INPUT);     
}

void loop(){
  // read the state of the pushbutton value:
  buttonState = digitalRead(buttonPin);

  if(buttonState != lastButtonState && buttonState == HIGH
}
