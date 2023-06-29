class Element {
  PVector locationOffset;
  PVector offsetVelocity;
  float size;
  int sizeSteps;
  int currentSizeStep;
  float sizeVelocity;
  int steps;
  int currentStep = 0;
  PImage[] components = new PImage[1];

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

  // TODO: the signature is AWFUL!!!!!
  Element(PImage img, int offsetVelocityMin, int offsetVelocityMax, int offsetVelocityStepsMin, int offsetVelocityStepsMax,
    int xmin, int xmax, int ymin, int ymax,
    float sizeMin, float sizeMax, float svMin, float svMax, int sizeStepsMin, int sizeStepsMax) {
    setOffsetVelocity(offsetVelocityMin, offsetVelocityMax, offsetVelocityStepsMin, offsetVelocityStepsMax);
    setLocationOffset(xmin, xmax, ymin, ymax);
    setSizeVelocity(sizeMin, sizeMax, svMin, svMax, sizeStepsMin, sizeStepsMax);
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
    size = random(min, max);
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

  Element updateSize() {
    size += sizeVelocity;
    currentSizeStep++;
    if (currentSizeStep >= sizeSteps) {
      resetSizeVelocity(); // oooh, we have to save the original parameters!!!
    }
    return this;
  }

  PVector updateLocation() {
    locationOffset.add(offsetVelocity);
    println(locationOffset.x, locationOffset.y, currentStep, steps);
    currentStep++;
    println(locationOffset.x, locationOffset.y, currentStep, steps);
    if (currentStep >= steps) {
      resetOffsetVelocity();
    }
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
