import processing.sound.*;

PImage bg;
PImage browser1;
float xpos;
float ypos;
float xdir;
float ydir;
int scale;

AudioIn input;
Amplitude rms;

void settings() {
  bg = loadImage("windowsDesktop.jpg");
  browser1 = loadImage("browser1.png");
  size(bg.width, bg.height);
  xdir=1;
  ydir=1;
}

void setup() {
  background(bg);

  //Create an Audio input and grab the 1st channel
  input = new AudioIn(this, 0);

  // start the Audio Input
  input.start();

  // create a new Amplitude analyzer
  rms = new Amplitude(this);

  // Patch the input to an volume analyzer
  rms.input(input);
}

void draw() {
  scale=int(map(rms.analyze(), 0, 0.3, 1, 100));
  image(browser1, xpos, ypos);
  xpos += xdir*scale;
  ypos += ydir*scale;

  if (xpos>width-browser1.width| xpos<0) {
    xdir *= -1;
  } 
  
  if (ypos>height-browser1.height| ypos<0) {
    ydir *= -1;
  }
 
}