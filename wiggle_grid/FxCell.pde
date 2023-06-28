
// A FxCell object
class FxCell implements ICell {
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

  // FxCell Constructor
  FxCell(PImage i, float tempX, float tempY, float tempW, float tempH, int steps) {
    img = i;
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    fadeSteps = steps;
    reduceBy = transparency / fadeSteps;
  }

  FxCell clone() {
    return new FxCell(img, x, y, w, h, fadeSteps);
  }

  Boolean vanished() {
    return (transparency <= 0);
  }

  Boolean visible() {
    return (transparency == 255);
  }

  FxCell reset() {
    currentStep = 0;
    direction = -1;
    currentLoop = 0;
    transparency = 255;
    runningEffect = false;
    return this;
  }

  FxCell replaceImage(PImage image) {
    img = image;
    return this;
  }

  FxCell update() {
    if (runningEffect) {
      transparency = transparency + (direction * reduceBy);
      currentStep++; // oops!!!!! need to modulo by numSteps

      if (currentStep > fadeSteps || currentStep < 0) {
        runningEffect = false;
      }
    }
    return this;
  }

  FxCell startEffect() {
    runningEffect = true;
    return this;
  }

  FxCell draw() {
    tint(255, transparency);
    image(img, x, y, w, h);
    tint(255, 255);
    return this;
  }
}
