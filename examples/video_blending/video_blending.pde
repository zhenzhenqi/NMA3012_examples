
import processing.video.*;
Movie mov;
Capture cam;



void setup() {
  size(1920, 1080);
  background(0);
  mov = new Movie(this, "sample.mov");
  mov.play();
  cam = new Capture(this, width, height);
  cam.start();
}


void draw() {
  background(mov);
  if (cam.available()) {
    cam.read();
  }
  
  image(cam, 0, 0);
  blendMode(SCREEN);

}

void movieEvent(Movie m) {
  m.read();
}

void mouseDragged(){
 loadPixels();
 
 
 updatePixels();
}