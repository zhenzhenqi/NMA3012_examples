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
      String filename = imagePrefix + i + ".jpg";
      images[i] = loadImage(filename);
    }
  }

  void display(float xpos, float ypos) {
    if(frame<imageCount-1){
      frame = frame+1;
      image(images[frame], xpos, ypos);
    }else{
    }
  }

  int getWidth() {
    return images[0].width;
  }

  int getHeight() {
    return images[0].height;
  }
}

