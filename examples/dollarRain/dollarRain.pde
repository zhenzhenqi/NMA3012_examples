import oscP5.*;
import netP5.*;

OscP5 oscP5;

float smileValue;
PImage myImage;

Animation dollarRain;

//float glitchVariable = 1;

void setup() {
  size(500, 367, P3D);
  background(0);
  myImage = loadImage("alg-donald-trump-jpg.jpg");
  oscP5 = new OscP5(this, 12345);
  dollarRain = new Animation("dollarRain", 15);
  frameRate(10);
}

void draw() {
  if (smileValue <= 0.001) {
    dollarRain.display(0, 0);
    background(loadImage("alg-donald-trump-jpg.jpg"));
  } else {
    background(loadImage("alg-donald-trump-jpg.jpg"));
  }
}

void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  smileValue = theOscMessage.get(0).floatValue();
}
// Class for animating a sequence of GIFs

class Animation {
  PImage[] images;
  int imageCount;
  int frame;

  Animation(String imagePrefix, int count) {
    imageCount = count;
    images = new PImage[imageCount];

    for (int i = 0; i < imageCount; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = imagePrefix + i + ".png";
      images[i] = loadImage(filename);
    }
  }

  void display(float xpos, float ypos) {
    frame = (frame+1) % imageCount;
    image(images[frame], xpos, ypos, width, height);
    blend(images[frame], 0, 0, 33, 100, 67, 0, 33, 100, SUBTRACT);
  }

  int getWidth() {
    return images[0].width;
  }

  int getHeight() {
    return images[0].height;
  }
}