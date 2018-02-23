import processing.serial.*;
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
Minim minim;
AudioOutput out;
float thickness;
PVector lightLoc;
float ambient_light_b;
float timing;
ArrayList mydata;
Serial serialPort;

void setup() {
  thickness = 50;
  lightLoc = new PVector(width/2, 50, -400);
  size(800, 600, OPENGL);
  ambient_light_b = 0.6;
  minim = new Minim(this);
  out  = minim.getLineOut();
  mydata = new ArrayList();
  // List all the available serial ports
  printArray(Serial.list());
  serialPort = new Serial(this, Serial.list()[9], 9600);
}

void draw() {

  background(30);

  //rotate scenes
  supereye();
  getSensorData();

  //ambient lights & INDICATOR
  //  strokeWeight(5);
  //  stroke(255,213,0);
  //point(lightLoc.x, lightLoc.y, lightLoc.z);
  float shit = timing;
  timing = millis() / 1000;
  if (timing != shit) {
    ambient_light_b = map((Float)mydata.get(mydata.size()-1), 0, 100, 0.8, 1);
  }
  //ambient_light_b = 0.3;
  ambientLight(255*ambient_light_b, 255*ambient_light_b, 240*ambient_light_b, lightLoc.x, lightLoc.y, lightLoc.z);
  spotLight(255*ambient_light_b, 255*ambient_light_b, 255*ambient_light_b, lightLoc.x, lightLoc.y, lightLoc.z, width/2, height/2-200, -380, PI/4, 0.4);
  ambient_light_b  =  ambient_light_b -0.01;

  drawLines();
  //TEST SPOTLIGHT INDICATOR
  //  stroke(255, 0, 0);
  //  point(lightLoc.x, lightLoc.y, lightLoc.z);
  //  stroke(255);
  //  strokeWeight(10);
  //  line(lightLoc.x, lightLoc.y, lightLoc.z, width/2, height/2-200, -400);



  //for walls
  fill(255);
  noStroke();



  //left wall
  pushMatrix();
  translate(-80, 160, -400);
  box(thickness, 800, 800);
  popMatrix();

  //back wall
  pushMatrix();
  translate(width/2, 160, -800);
  box(1000, 800, thickness);
  popMatrix();

  //right wall
  pushMatrix();
  translate(900, 160, -400);
  box(thickness, 800, 800);
  popMatrix();

  //floor "wall"
  pushMatrix();
  translate(width/2, height-30, -400);
  box(940, thickness, 1100);
  popMatrix();

  //ceiling
  pushMatrix();
  translate(width/2, -180, -400);
  box(940, thickness, 1100);
  popMatrix();
}


void supereye () {
  //  rotate scene by mouse movement
  if (mousePressed) {
    translate(width/2, height/2, -600);
    rotateX(map(mouseX, 0, width, 0, 1) * PI * 3);
    rotateY(map(mouseY, 0, width, 0, 1) * PI * 3);
  }
}


void getSensorData() {
  if ( serialPort.available() > 0) {
    float temp = serialPort.read();
//    println(temp);
    mydata.add(temp);
    if (mydata.size() >= 2) {

      float a = 0;
      float b = 0;

      a = (Float)mydata.get(mydata.size()-1);
      b = (Float)mydata.get(mydata.size()-2);

      if (a < b) {
        out.playNote("A");
        //        println("less");
      }
      else if ( a == b ) {
        out.playNote("4");
        //        println("equal");
      }
      else {
        out.playNote("6");
        //        println("bigger");
      }
    }
    if (mydata.size() > 100)mydata.remove(0);
//    println(temp);
  }
}



void drawLines() {
  pushMatrix();
  translate(-50, -350, -500);
  if (mydata.size() >= 3) {
//    println(mydata);
    int counter = 1;
    for (int i=0;i<(mydata.size()-1)*10 ;i += 10) {

      strokeWeight(1);
      stroke(0);
      //      pushMatrix();
      //      translate(i, height-(Float)mydata.get(counter), 0);
      //      noFill();
      //      stroke(255);
      //      sphere(10);
      //    //  point(i, height-(Float)mydata.get(counter), 0);
      //      popMatrix();
      float data1 = (Float)mydata.get(counter-1);
      float data2 = (Float)mydata.get(counter);
      strokeWeight(5);
      stroke(255,0,0);
      point(0,(Float)mydata.get(0),0);
      stroke(0);
      strokeWeight(0.8);
     
      line(i, height-data1, i+10, height-data2); 
//      println("i= " + i + "/ counter= " + counter );
      strokeWeight(3);
      stroke(255);
      counter++;
      // draw point
      // point(i, (Float)(mydata.get(i)));
    }
  }
  popMatrix();
}

void keyPressed(){
  println(mydata.size());
  for(int i=0; i<mydata.size()-1;i++){
//    println(mydata.get(i));
  }
}
