void setup(){
  size(500, 500);
};

void draw(){};

void mousePressed(){
  ellipse( mouseX, mouseY, 2, 2 );
  println( "x: " + mouseX + " y: " + mouseY, mouseX + 2, mouseY );
}