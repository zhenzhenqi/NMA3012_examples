import processing.video.*;

Capture video; //declare a capture object called video

void setup() {
  size(640, 480);
  println(Capture.list());

  // initialize video object, use the default camera at 320x240 resolution
  video = new Capture(this, 640, 480);
  video.start();
}

// An event for when a new frame is available, similar to mousePressed
void captureEvent(Capture video) {
  // Step 4. Read the image from the camera.
  video.read();
}

void draw() {
  // Step 5. Display the video image.
  image(video, 0, 0);
}
