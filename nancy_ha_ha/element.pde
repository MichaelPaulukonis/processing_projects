class OffsetVelocity {
  int min;
  int max;
  int stepsMin;
  int stepsMax;
}

// xmin should never be less than pg.width/2
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
  PImage img;

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

  Element(PImage i) {
    setLocationOffset();
    setOffsetVelocity();
    setSizeVelocity();
    img = i;
  }

  Element(PImage i, OffsetVelocity velocity, OffsetLocation location, OffsetSize size) {
    setOffsetVelocity(velocity.min, velocity.max, velocity.stepsMin, velocity.stepsMax);
    setLocationOffset(location.xmin, location.xmax, location.ymin, location.ymax);
    setSizeVelocity(size.min, size.max, size.velocityMin, size.velocityMax, size.sizeStepsMin, size.sizeStepsMax);
    img = i;
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
    offsetVelocity = new PVector(random(this.offsetVelocityMin, this.offsetVelocityMax), random(this.offsetVelocityMin, this.offsetVelocityMax));
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
    size = constrain(size, this.sizeMin, this.sizeMax);
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

  Element setImage(PImage i) {
    img = i;
    return this;
  }

  PImage image() {
    return img;
  }
}

class ElementBounded extends Element {

  PGraphics pg; // overkill - just need size
  Dimension d;
  float ratio;

  float getScale(Dimension imageSize, Dimension boundary) {

    double widthRatio = boundary.getWidth() / imageSize.getWidth();
    double heightRatio = boundary.getHeight() / imageSize.getHeight();
    double r = Math.max(widthRatio, heightRatio);

    // sizeMin/sizeMax are based on original image size
    // rather, they should be based on the RATIO (or should they?)
    float mod = Math.min((float)(r * random(1, 5)), this.sizeMax);
    println("ratio: ", r, "mod: ", mod);
    return mod;
  }

  ElementBounded(PImage i, OffsetVelocity velocity, OffsetLocation location, OffsetSize size, PGraphics pg) {
    super(i, velocity, location, size);
    this.pg = pg;
    this.ratio = getScale(new Dimension(i.width, i.height), new Dimension(pg.width, pg.height));
    println(this.ratio);
  }


  //// xmin should never be less than pg.width/2
  // this is an options collection to simplify signatures
  //class OffsetLocation {
  //  int xmin;
  //  int xmax;
  //  int ymin;
  //  int ymax;
  //}

  @Override
    PVector updateLocation() {
    // locationOffset is a vector
    // it should prolly be an object that only exposes the location
    // but auto-constrains itself
    locationOffset.add(offsetVelocity);
    currentStep++;
    if (currentStep >= steps) {
      resetOffsetVelocity();
    }

    float offsetX = constrain(locationOffset.x, 0, img.width * ratio - pg.width);
    float offsetY = constrain(locationOffset.y, 0, img.height * ratio - pg.height);

    locationOffset.x = offsetX;
    locationOffset.y = offsetY;

    return locationOffset;
  }
}
