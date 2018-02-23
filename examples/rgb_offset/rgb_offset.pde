import processing.video.*;
Capture cam;
float offset = 0;
boolean normal = true;

void setup() {
  size(1280, 720);
  cam = new Capture(this, width, height);
  cam.start();
}
void draw() {
  background(255);
  if (cam.available()) {
    cam.read();
  }
  PImage r = createImage(width, height, RGB);
  PImage g = createImage(width, height, RGB);
  PImage b = createImage(width, height, RGB);
  if (normal) {
    blendMode(BLEND);//default
    image(cam, 0, 0);
  } else {
    cam.loadPixels();
    r.loadPixels();
    g.loadPixels();
    b.loadPixels();
    for (int i = 0; i < cam.pixels.length; i++) {
      r.pixels[i] = color(red(cam.pixels[i]), 0, 0);
      g.pixels[i] = color(0, green(cam.pixels[i]), 0);
      b.pixels[i] = color(0, 0, blue(cam.pixels[i]));
    }
    r.updatePixels();
    g.updatePixels();
    b.updatePixels();
    blendMode(SUBTRACT);
    image(r, offset, offset);
    image(g, 0, 0);
    image(b, -offset, -offset);
  }
}

void mouseDragged() {
  offset = random(30, 100);
  normal = false;
}
void mouseReleased() {
  offset = 0;
  normal = true;
}