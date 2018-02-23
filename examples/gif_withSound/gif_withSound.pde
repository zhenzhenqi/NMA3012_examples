import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;


//animation related variables
Animation animation1, animation2;

float xpos = 0;
float ypos = 0;
float drag = 30.0;

//music related variables
Minim minim;
AudioPlayer kick;
AudioPlayer bee;

char letter;

void setup() {
  size(1000, 800);
  background(100, 100, 100);
  frameRate(24);
  minim = new Minim(this);
  //change prefix and number of individual images belonging to each specific gif
  //for example, ZZ gif contains 50 files with prefix ZZ
  animation1 = new Animation("ZZ_", 50);
  animation2 = new Animation("ZZ2_", 49);


  //load music samples
  kick = minim.loadFile("rhy.mp3", 2048);
  bee = minim.loadFile("drum.wav", 2048);

  letter = 'n';
}  

void draw() { 
  float dx = mouseX - xpos;
  xpos = xpos + dx/drag;

  float dy = mouseY - ypos;
  ypos = ypos + dy/drag;


  switch(letter) {
  case 'k':
    println("PLAYING ANIMATION1");
    background(255, 255, 255);
    animation1.display(xpos-animation1.getWidth()/2, ypos-animation1.getHeight()/2);
    //if kick is not yet playing, play and loop at the end
    if (!kick.isPlaying()) {
      kick.loop();
    }
    //if bee is playing, temporarily pause
    if (bee.isPlaying()) {
      bee.pause();
    }
    break;
  case 'j': 
    println("PLAYING ANIMATION2");
    background(0, 0, 0);
    animation2.display(xpos-animation1.getWidth()/2, ypos-animation2.getHeight()/2);
    //if bee is not yet playing, play and loop at the end
    if (!bee.isPlaying()) {
      bee.loop();
    }
    //if kick is playing, temporarily pause
    if (kick.isPlaying()) {
      kick.pause();
    }
    break;
  default:             // Default executes if the case labels
    println("None");   // don't match the switch parameter
    break;
  }
}

void keyPressed() {
  if (key == 'k') {
    letter = 'k';
  } 
  if (key == 'j') {
    letter = 'j';
  }
}



