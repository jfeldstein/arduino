int REDPin = 3;    // RED pin of the LED to PWM pin 4 
int GREENPin = 5;  // GREEN pin of the LED to PWM pin 5
int BLUEPin = 6;   // BLUE pin of the LED to PWM pin 6
int REDPin2 = 9;
int GREENPin2 = 10;
int BLUEPin2 = 11;
int brightness = 255; // LED brightness
int increment = 5;  // brightness increment
int rgb[3];
double time = 0;
double saturation = 0.5;
double luminance = 0.3;
float H,S,L,Rval,Gval,Bval;
 
void HSL(float H, float S, float L, float& Rval, float& Gval, float& Bval);
float Hue_2_RGB( float v1, float v2, float vH );


void setup()
{
  pinMode(REDPin, OUTPUT); 
  pinMode(GREENPin, OUTPUT); 
  pinMode(BLUEPin, OUTPUT); 
  
  pinMode(REDPin2, OUTPUT); 
  pinMode(GREENPin2, OUTPUT); 
  pinMode(BLUEPin2, OUTPUT); 
  Serial.begin(9600);
}

void loop()
{
  time += .01; 
  if(time >= 1) time = 0;
    S=1;
  L=.25;
  HSL(time,S,L,Rval,Gval,Bval);
  analogWrite(REDPin, Rval);
  analogWrite(GREENPin, Gval);
  analogWrite(BLUEPin, Bval);
  
  
  HSL(time,S,L,Rval,Gval,Bval);
  analogWrite(REDPin2, Rval);
  analogWrite(GREENPin2, Gval);
  analogWrite(BLUEPin2, Bval);

  delay(20);  // wait for 20 milliseconds to see the dimming effect
}
