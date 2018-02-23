float[] positionXs = new float[200];
float[] positionYs = new float[200];
float[] positionZs = new float[200];

float angle = 0;

void setup () {
  size(1000, 1000, P3D);
  //noLoop();
  for (int i=0; i < 200; i++) {
    positionXs[i] = random(-width/2, width/2);
    positionYs[i] = random(-height/2, height/2);
    positionZs[i] = random(-400/2, 400/2);
  }
  fill(255);
  stroke(0);
}

void draw() {
  //background(0);
  directionalLight(220, 220, 220, 0, -0.2, -1);
  noStroke();
  fill(255, 255, 255, 100);
  sphere(5000);
  fill(255);
  stroke(0);

  translate(width/2, height/2);
  rotateY(angle);
  for (int i = 0; i < 200; i = i+1) {
    pushMatrix();
    translate(positionXs[i], positionYs[i], positionZs[i]);
    rotateX(angle);
    rotateY(angle);
    rotateZ(angle);
    box(30);
    popMatrix();
  }
  angle = angle + 0.001;
}