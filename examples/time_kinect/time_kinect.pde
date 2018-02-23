////////////////////////////////////////////////////////////////////////////////////
/////////////////////////simpleOpenNI integration - begin declaring variables//////////////
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
/////////////////////////simpleOpenNI integration - end declaring variables/////////
////////////////////////////////////////////////////////////////////////////////////


import processing.video.*;

Movie mov; //declare move object
float tempPos = width/2; //stores mouse position from the previous frame
float tempSpeed = 1;

void setup() {
////////////////////////////////////////////////////////////////////////////////////
/////////////////////////simpleOpenNI integration - begin initializing variables////
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
/////////////////////////simpleOpenNI integration - end initializing variables//////
//////////////////////////////////////////////////////////////////////////////////// 
  size(640, 360);
  mov = new Movie(this, "tickingclock.mp4"); //initialize move object
  mov.play(); //play movie once
  mov.loop(); //loop video when finished
}

void draw() {
////////////////////////////////////////////////////////////////////////////////////
/////////////////////////simpleOpenNI integration - begin reading user data/////////
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
/////////////////////////simpleOpenNI integration - end reading user data///////////
////////////////////////////////////////////////////////////////////////////////////
    mov.read(); //start reading frames of movie according to its default sequence
    mov.speed(tempSpeed);
    image(mov, 0, 0); //draw movie at location 0, 0
    
//  interaction prototyping with mouse: control clock using mouseX position    
//  if (mouseX>width/2) {
//    mov.pause();
//  } else {
//    mov.play();
//  }


//interaction design 1: 
//as people walk passed by the clock, their relative position rewinds the clock arm.
if(nearestH.z<2000){
  println("nearestH.x"+nearestH.x);
  float tempX = map(nearestH.x, 0, 6000, 0, width);
  if(abs((tempX - tempPos))>0){
      // Ratio of mouse X over width
  float ratio = tempX / (float) width;

 // The jump() function allows you to jump immediately to a point of time within the video. 
  // duration() returns the total length of the movie in seconds.  
  mov.jump(ratio * mov.duration()); 
  }
  tempPos = mouseX;
}


//   //ineraction design 2: 
//   //when people move in front of screen, make time go faster. when people slow down, clock arm goes back to normal speed.
//    if(abs((mouseX - tempPos))>0){
//      if(tempSpeed<10){
//        tempSpeed+=0.8;
//      }
//    }else{
//      if(tempSpeed>1){
//        tempSpeed-=0.8;
//      }
//    }
//    tempPos=mouseX;
}

////////////////////////////////////////////////////////////////////////////////////
/////////////////////////simpleOpenNI integration - begin data retrieving function//
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
    nearestH = jointH;
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
/////////////////////////simpleOpenNI integration - end data retriveing function////
////////////////////////////////////////////////////////////////////////////////////

