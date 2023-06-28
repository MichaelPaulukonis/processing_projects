class Element {
  PVector location;
  PVector velocity;
  float size;
  int sizeSteps;
  int currentSizeStep;
  float sizeVelocity;
  int steps;
  int currentStep = 0;
  PImage[] components = new PImage[1];

  Element(PImage img) {
    randomLocation();
    setVelocity();
    setSize();
    components[0] = img;
  }

  // values in here are pretty much for the nany element
  void randomLocation() {
    int x = (int)random(-1500, 1500);
    int y =(int)random(-500, 1500);
    location = new PVector(x, y);
  }

  void setVelocity() {
    setVelocity(-20, 20, (int)random(5, 10));
  }

  void setVelocity(int min, int max, int _steps) {
    velocity = new PVector(random(min, max), random(min, max));
    steps = _steps;
    currentStep = 0;
  }

  void setSizeVelocity() {
    sizeVelocity = random(-0.02, 0.02);
    sizeSteps = (int)random(5, 10);
    currentSizeStep = 0;
  }

  void setSize() {
    size = random(0.75, 3);
    setSizeVelocity();
  }

  Element updateSize() {
    size += sizeVelocity;
    currentSizeStep++;
    if (currentSizeStep >= sizeSteps) {
      setSizeVelocity();
    }
    return this;
  }

  PVector updateLocation() {
    location.add(velocity);
    println(location.x, location.y);
    currentStep++;
    if (currentStep >= steps) {
      setVelocity();
    }
    return location;
  }

  Element update() {
    updateSize();
    updateLocation();
    return this;
  }

  PVector location() {
    return location;
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
