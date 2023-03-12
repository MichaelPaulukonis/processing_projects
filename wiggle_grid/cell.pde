
// A Cell object
class Cell {
  // A cell object knows about its location in the grid
  // as well as its size with the variables x,y,w,h
  float x, y;   // x,y location
  float w, h;   // width and height
  int fadeSteps;
  int currentStep = 0;
  int transparency = 255; // start out full
  int reduceBy;
  int direction = -1;
  int loops = 1;
  int currentLoop = 0;
  PImage img;
  Boolean runningEffect = false;

  // Cell Constructor
  Cell(PImage i, float tempX, float tempY, float tempW, float tempH, int steps) {
    img = i;
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    fadeSteps = steps;
    reduceBy = transparency / fadeSteps;
  }

  Cell clone() {
    // TODO: need to clone the img, or when original changes this changes
    // or that's okay?
   return new Cell(img, x, y, w, h, fadeSteps); 
  }

  Cell replaceImage(PImage image) {
     img = image;
     return this;
  }

  Cell update() {
    if (runningEffect) {
      transparency = transparency + (currentStep * direction * reduceBy);
      currentStep++; // oops!!!!! need ot modulo by numSteps

      if (currentStep > fadeSteps || currentStep < 0) {
        direction = -direction;
        currentLoop++;
      }
      if (currentLoop > loops) {
        runningEffect = false;
      }
    }
    return this;
  }

  Cell startEffect() {
    runningEffect = true;
    return this;
  }

  Cell draw() {
    tint(255, transparency);
    image(img, x, y, w, h);
    tint(255, 255);
    return this;
  }
}
