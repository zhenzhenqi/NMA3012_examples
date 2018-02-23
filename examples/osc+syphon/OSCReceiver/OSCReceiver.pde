//receive osc data from face expression debug
import oscP5.*;
import netP5.*;

//declare an oscp5 object
OscP5 oscP5;

float smileValue;

void setup() {
  size(300, 300);
  //This is a port address from which sender application is sending out data
  oscP5 = new OscP5(this, 12345);
}

void draw() {
  background(0);
  text(smileValue, 10, 10);
}

void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  smileValue = theOscMessage.get(0).floatValue();
}


