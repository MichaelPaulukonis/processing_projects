class BoundedElement {
  PVector location; // it's not an offset, it's the atual location
  PVector locationVelocity;
  float size;
  int sizeSteps;
  int currentSizeStep;
  float sizeVelocity;
  int steps;
  int currentStep = 0;
  PImage img;
  PGraphics temp;
  Dimension boundary;

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
  String[] imagePaths;

  BoundedElement(PImage i, LocationVelocityConfig velocity, LocationConfig location, SizeConfig size, String[] images) {
    setVelocity(velocity.min, velocity.max, velocity.stepsMin, velocity.stepsMax);
    setLocation(location.xmin, location.xmax, location.ymin, location.ymax);
    setSizeVelocity(size.min, size.max, size.velocityMin, size.velocityMax, size.sizeStepsMin, size.sizeStepsMax);
    this.imagePaths = images;
    img = i;
    temp = createGraphics(2000, 2000);
  }

  // atm used only by sub-class CoverageElement
  BoundedElement(PImage i, LocationVelocityConfig velocity,
    LocationConfig location, SizeConfig size, String[] images, PGraphics pg) {
    this(i, velocity, location, size, images);
    this.boundary = new Dimension(pg.width, pg.height);
  }

  // values in here are pretty much for the nancy element
  void setLocation() {
    setLocation(-750, 750, -250, 750);
  }

  void setLocation(int xmin, int xmax, int ymin, int ymax) {
    int x = (int)random(xmin, xmax);
    int y =(int)random(ymin, ymax);
    location = new PVector(x, y);
  }

  void setVelocity() {
    setVelocity(-20, 20, 5, 10);
  }

  void setVelocity(int min, int max, int stepsMin, int stepsMax) {
    this.offsetVelocityMin = min;
    this.offsetVelocityMax = max;
    this.offsetVelocityStepsMin = stepsMin;
    this.offsetVelocityStepsMax = stepsMax;
    resetOffsetVelocity();
  }

  // TODO: need a bounce and bounded someway
  void resetOffsetVelocity() {
    locationVelocity = new PVector(random(this.offsetVelocityMin, this.offsetVelocityMax), random(this.offsetVelocityMin, this.offsetVelocityMax));
    steps = (int)random(this.offsetVelocityStepsMin, this.offsetVelocityStepsMax);
    currentStep = 0;
  }

  void setSizeVelocity(float svMin, float svMax) {
    sizeVelocity = random(svMin, svMax);
  }

  // hunh, do I even need this?
  // not if we're using min/max - it's just how long it takes
  // which will simplify things nice
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

  BoundedElement resetSizeVelocity() {
    setSizeVelocity(this.svMin, this.svMax);
    setSizeSteps(this.sizeStepsMin, this.sizeStepsMax);
    currentSizeStep = 0;
    return this;
  }

  BoundedElement setRandomSize(float min, float max) {
    this.size = random(min, max);
    return this;
  }


  BoundedElement updateSize() {
    size += sizeVelocity;
    if (size >= this.sizeMax || size <= this.sizeMin ) {
      sizeVelocity = -sizeVelocity;
    }
    size = constrain(size, this.sizeMin, this.sizeMax);
    currentSizeStep++;
    if (currentSizeStep >= sizeSteps) {
      resetSizeVelocity();
    }
    return this;
  }

  // TODO: uh.... bounce off edges?
  // but what about the larger-than-window images???
  //PVector locationVelocity;
  BoundedElement updateLocation() {
    location.add(locationVelocity);
    // now check, if outside bounds, multiple x pr y by -1
    currentStep++;
    if (currentStep >= steps) {
      resetOffsetVelocity();
    }
    return this;
  }

  BoundedElement update() {
    updateSize();
    updateLocation();
    // TODO: better control of this
    if (random(0, 1) < 0.1) {
      this.randomImage();
    }
    return this;
  }

  PVector location() {
    return location;
  }

  float size() {
    return size;
  }

  BoundedElement randomImage() {
    this.img = loadImage(getRandomFile(this.imagePaths));
    return this;
  }

  BoundedElement setImage(PImage i) {
    this.img = i;
    return this;
  }

  PImage image() {
    return img;
  }

  PGraphics render() {
    temp.beginDraw();
    temp.clear();
    temp.image(img, location.x, location.y,
      2000 * size(), 2000 * size());
    return temp;
  }
}