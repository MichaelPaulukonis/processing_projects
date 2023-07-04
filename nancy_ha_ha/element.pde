class OffsetVelocity {
  int min;
  int max;
  int stepsMin;
  int stepsMax;
}

class OffsetLocation {
  int xmin;
  int xmax;
  int ymin;
  int ymax;
}

class OffsetSize {
  float min;
  float max;
  float velocityMin;
  float velocityMax;
  int sizeStepsMin;
  int sizeStepsMax;
}

class Element {
  PVector locationOffset;
  PVector offsetVelocity;
  float size;
  int sizeSteps;
  int currentSizeStep;
  float sizeVelocity;
  int steps;
  int currentStep = 0;
  PImage[] components = new PImage[1]; // TODO: this is wrong, they need to be separate elements so they can move independently

  int offsetVelocityMin;
  int offsetVelocityMax;
  int offsetVelocityStepsMin;
  int offsetVelocityStepsMax;
  int xmin;
  int xmax;
  int ymin;
  int ymax;
  float sizeMin;
  float sizeMax;
  float svMin;
  float svMax;
  int sizeStepsMin;
  int sizeStepsMax;

  Element(PImage img) {
    setLocationOffset();
    setOffsetVelocity();
    setSizeVelocity();
    components[0] = img;
  }

  Element(PImage img, OffsetVelocity velocity, OffsetLocation location, OffsetSize size) {
    setOffsetVelocity(velocity.min, velocity.max, velocity.stepsMin, velocity.stepsMax);
    setLocationOffset(location.xmin, location.xmax, location.ymin, location.ymax);
    setSizeVelocity(size.min, size.max, size.velocityMin, size.velocityMax, size.sizeStepsMin, size.sizeStepsMax);
    components[0] = img;
  }

  // values in here are pretty much for the nancy element
  void setLocationOffset() {
    setLocationOffset(-750, 750, -250, 750);
  }

  void setLocationOffset(int xmin, int xmax, int ymin, int ymax) {
    int x = (int)random(xmin, xmax);
    int y =(int)random(ymin, ymax);
    locationOffset = new PVector(x, y);
  }

  void setOffsetVelocity() {
    setOffsetVelocity(-20, 20, 5, 10);
  }

  void setOffsetVelocity(int min, int max, int stepsMin, int stepsMax) {
    this.offsetVelocityMin = min;
    this.offsetVelocityMax = max;
    this.offsetVelocityStepsMin = stepsMin;
    this.offsetVelocityStepsMax = stepsMax;
    resetOffsetVelocity();
  }

  void resetOffsetVelocity() {
    println("resetOffsetVelocity");
    offsetVelocity = new PVector(random(this.offsetVelocityMin, this.offsetVelocityMax), random(this.offsetVelocityMin, this.offsetVelocityMax));
    steps = (int)random(this.offsetVelocityStepsMin, this.offsetVelocityStepsMax);
    currentStep = 0;
  }

  void setSizeVelocity(float svMin, float svMax) {
    sizeVelocity = random(svMin, svMax);
  }

  void setSizeSteps(int stepsMin, int stepsMax) {
    sizeSteps = (int)random(stepsMin, stepsMax);
  }

  void setSizeVelocity() {
    setSizeVelocity(0.75, 3, -0.02, 0.02, 5, 10);
  }

  void setSizeVelocity(float min, float max, float svMin, float svMax, int stepsMin, int stepsMax) {
    // TODO: we don't always reset the size,
    // normally just the velocity, and steps
    this.sizeMin = min;
    this.sizeMax = max;
    setRandomSize(min, max);
    this.svMin = svMin;
    this.svMax = svMax;
    this.sizeStepsMin = stepsMin;
    this.sizeStepsMax = stepsMax;
    resetSizeVelocity();
  }

  void resetSizeVelocity() {
    setSizeVelocity(this.svMin, this.svMax);
    setSizeSteps(this.sizeStepsMin, this.sizeStepsMax);
    currentSizeStep = 0;
  }

  void setRandomSize(float min, float max) {
    this.size = random(min, max);
  }

  Element updateSize() {
    size += sizeVelocity;
    if (size >= this.sizeMax || size <= this.sizeMin ) {
      sizeVelocity = -sizeVelocity;
    }
    size = max(min(size, this.sizeMax), this.sizeMin);
    currentSizeStep++;
    if (currentSizeStep >= sizeSteps) {
      resetSizeVelocity();
    }
    return this;
  }

  PVector updateLocation() {
    //println("pre-update", locationOffset.x, locationOffset.y, currentStep, steps);
    locationOffset.add(offsetVelocity);
    currentStep++;
    if (currentStep >= steps) {
      resetOffsetVelocity();
    }
    //println("post-update", locationOffset.x, locationOffset.y, currentStep, steps);
    return locationOffset;
  }

  Element update() {
    updateSize();
    updateLocation();
    return this;
  }

  PVector locationOffset() {
    return locationOffset;
  }

  float size() {
    return size;
  }

  Element setImage(PImage img) {
    components[0] = img;
    return this;
  }

  PImage image() {
    return components[0];
  }
}
