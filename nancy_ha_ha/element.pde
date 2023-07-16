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
  PGraphics temp;

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

  Element(PImage i, OffsetVelocity velocity, OffsetLocation location, OffsetSize size, String[] images) {
    setOffsetVelocity(velocity.min, velocity.max, velocity.stepsMin, velocity.stepsMax);
    setLocationOffset(location.xmin, location.xmax, location.ymin, location.ymax);
    setSizeVelocity(size.min, size.max, size.velocityMin, size.velocityMax, size.sizeStepsMin, size.sizeStepsMax);
    this.imagePaths = images;
    img = i;
    temp = createGraphics(2000, 2000);
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

  Element resetSizeVelocity() {
    setSizeVelocity(this.svMin, this.svMax);
    setSizeSteps(this.sizeStepsMin, this.sizeStepsMax);
    currentSizeStep = 0;
    return this;
  }

  Element setRandomSize(float min, float max) {
    this.size = random(min, max);
    return this;
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

  Element updateLocation() {
    locationOffset.add(offsetVelocity);
    currentStep++;
    if (currentStep >= steps) {
      resetOffsetVelocity();
    }
    return this;
  }

  Element update() {
    updateSize();
    updateLocation();
    // TODO: better control of this
    if (random(0, 1) < 0.1) {
      this.randomImage();
    }
    return this;
  }

  PVector locationOffset() {
    return locationOffset;
  }

  float size() {
    return size;
  }

  Element randomImage() {
    this.img = loadImage(getRandomFile(this.imagePaths));
    return this;
  }

  Element setImage(PImage i) {
    this.img = i;
    return this;
  }

  PImage image() {
    return img;
  }

  PGraphics render() {
    temp.beginDraw();
    temp.clear();
    temp.image(img, locationOffset.x, locationOffset.y,
      2000 * size(), 2000 * size());
    return temp;
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

    double mod = Math.min((r * random(1, 5)), this.sizeMax * r);
    //println("ratio: ", r, "mod: ", mod);
    return (float)mod;
  }

  ElementBounded(PImage i, OffsetVelocity velocity, OffsetLocation location, OffsetSize size, PGraphics pg, String[] imagePaths) {
    super(i, velocity, location, size, imagePaths);
    this.pg = pg;
    this.ratio = getScale(new Dimension(i.width, i.height), new Dimension(pg.width, pg.height));
  }

  @Override
    ElementBounded updateLocation() {
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

    return this;
  }

  @Override
    ElementBounded update() {
    this.updateSize();
    this.updateLocation();
    return this;
  }

  @Override
    ElementBounded setImage(PImage i) {
    this.img = i;
    this.ratio = getScale(new Dimension(i.width, i.height), new Dimension(pg.width, pg.height));
    return this;
  }

  @Override
    PGraphics render() {
    temp.beginDraw();
    temp.clear();
    temp.background(255);
    temp.image(this.img, 0 - locationOffset.x, 0 - locationOffset.y,
      ratio * img.width, ratio * img.height);
    temp.endDraw();
    return temp;
  }
}
