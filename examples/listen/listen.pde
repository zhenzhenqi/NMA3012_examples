////////////////////////////////////////////////////////////////////////////////////
/////////////////////////simpleOpenNI integration - don't touch/////////////////////
////////////////////////////////////////////////////////////////////////////////////

import SimpleOpenNI.*;
SimpleOpenNI context; //declare a new SimpleOpenNI object called context
float        zoomF =0.5f;
float        rotX = radians(180);  // by default rotate the hole scene 180deg around the x-axis, 
// the data from openni comes upside down
float        rotY = radians(0);
boolean      autoCalib=true;

PVector      bodyCenter = new PVector();
PVector      bodyDir = new PVector();
PVector      com = new PVector();                                   
PVector      com2d = new PVector();                                    

int distance = 3000;
PVector nearestH = new PVector(0,0, distance);  //head position that's closest to the camera
////////////////////////////////////////////////////////////////////////////////////
/////////////////////////simpleOpenNI integration - don't touch/////////////////////
////////////////////////////////////////////////////////////////////////////////////

// Two source images
PImage tunnel;      // Source image 1
PImage person;      // Source image 2

// A percentage (10% one image, 90% the other, etc.  starts at 0%);
float p = 0;

void setup() {
////////////////////////////////////////////////////////////////////////////////////
/////////////////////////simpleOpenNI integration - don't touch/////////////////////
////////////////////////////////////////////////////////////////////////////////////
  context = new SimpleOpenNI(this); 
  if (context.isInit() == false)
  {
    println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
    exit();
    return;
  }
  
  context.setMirror(false);  // disable mirror
  context.enableDepth();  // enable depthMap generation 
  context.enableUser();   // enable skeleton generation for all joints
////////////////////////////////////////////////////////////////////////////////////
/////////////////////////simpleOpenNI integration - don't touch/////////////////////
////////////////////////////////////////////////////////////////////////////////////           
  size(576, 384);
  tunnel = loadImage("tunnel_cropped.jpg");
  person = loadImage("person_cropped.jpg");
}

void draw() {
////////////////////////////////////////////////////////////////////////////////////
/////////////////////////simpleOpenNI integration - don't touch/////////////////////
////////////////////////////////////////////////////////////////////////////////////
  context.update(); 
  
    // draw the skeleton if it's available
  int[] userList = context.getUsers();
  for (int i=0; i<userList.length; i++)
  {
    if (context.isTrackingSkeleton(userList[i]))
      getBodyDirection(userList[i]);
  } 
////////////////////////////////////////////////////////////////////////////////////
/////////////////////////simpleOpenNI integration - don't touch/////////////////////
////////////////////////////////////////////////////////////////////////////////////

  // Percentage goes from 0 to 1 then back to 0
  if(nearestH.z<1500){
    if(p<1){
      p+=0.05;
    }
  }else{
    if(p>0){
      p-=0.05;
    }
  }
  
  nearestH.z = distance;

  loadPixels();
  // We are going to look at both image's pixels
  tunnel.loadPixels();
  person.loadPixels();

  for (int x = 0; x < tunnel.width; x++ ) {
    for (int y = 0; y < tunnel.height; y++ ) {
      int loc = x*tunnel.height + y;
      // Two colors
      color c0 = tunnel.pixels[loc];
      color c1 = person.pixels[loc];

      // Separate out r,g,b components
      float r0 = red(c0); 
      float g0 = green(c0); 
      float b0 = blue(c0);
      float r1 = red(c1); 
      float g1 = green(c1); 
      float b1 = blue(c1);

      // Combine each image's color
      float r = p*r1+(1.0-p)*r0;
      float g = p*g1+(1.0-p)*g0;
      float b = p*b1+(1.0-p)*b0;

      // Set the new color
      pixels[loc] = color(r, g, b);
    }
  }

  updatePixels();   
}


////////////////////////////////////////////////////////////////////////////////////
/////////////////////////simpleOpenNI integration - don't touch/////////////////////
////////////////////////////////////////////////////////////////////////////////////
void getBodyDirection(int userId)
{  
  PVector jointL = new PVector();
  PVector jointH = new PVector();
  PVector jointR = new PVector();
  float  confidence;

  // draw the joint position
  confidence = context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, jointL);
  confidence = context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD, jointH);
  confidence = context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, jointR);

  if(jointH.z < nearestH.z){
    nearestH.z = jointH.z;
  }
  
  //  // take the neck as the center point
  //  confidence = context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_NECK, centerPoint);
  //
  //  /*  // manually calc the centerPoint
  //   PVector shoulderDist = PVector.sub(jointL,jointR);
  //   centerPoint.set(PVector.mult(shoulderDist,.5));
  //   centerPoint.add(jointR);
  //   */
  //
  //  PVector up = PVector.sub(jointH, centerPoint);

  //  PVector left = PVector.sub(jointR, centerPoint);
  //
  //  dir.set(up.cross(left));
  //  dir.normalize();
}


void onNewUser(SimpleOpenNI curContext,int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  
  context.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext,int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext,int userId)
{
  //println("onVisibleUser - userId: " + userId);
}
////////////////////////////////////////////////////////////////////////////////////
/////////////////////////simpleOpenNI integration - don't touch/////////////////////
////////////////////////////////////////////////////////////////////////////////////

