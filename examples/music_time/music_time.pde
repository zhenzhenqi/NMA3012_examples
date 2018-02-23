import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioPlayer jingle;
FFT fft;

ArrayList<Float> prevLevels;

void setup() {
  size(800, 600);
  minim = new Minim(this);
  prevLevels = new ArrayList<Float>();
  jingle = minim.loadFile("sample.mp3", 1024);
  jingle.loop();
  fft = new FFT(jingle.bufferSize(), jingle.sampleRate());
}

void draw() {
  noStroke();
  rectMode(CORNER);
  fill(0, 10);
  rect(0, 0, width, height);
  fft.forward(jingle.mix);

  rectMode(CENTER);
  float level = fft.getBand(10);

  float spacing = 10;
  float w = width / (prevLevels.size() * spacing);

  float minHeight = 2;

  //add new level to end of array
  prevLevels.add(level);

  //remove first item in array;
  if (prevLevels.size()>60) {
    prevLevels.remove(0);
  }

  for (int i=0; i<prevLevels.size (); i++) {
    float x = map(i, prevLevels.size(), 0, width/2, width);
    float h = map(prevLevels.get(i), 0, 40, minHeight, height);

    float alphaValue = map(i, 0, prevLevels.size(), 1, 250);

    float hueValue = map ( h, minHeight, height, 200, 255);
    fill(hueValue, 255, 255, alphaValue);
    rect(x, height/2, w, h);
    rect(width-x, height/2, w, h);
  }
}

