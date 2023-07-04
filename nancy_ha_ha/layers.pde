class Layers {
  PImage borderOverlay;
  PImage[] components;
  PGraphics pg;
  Dimension bd;
  Dimension b2d;
  Boolean dirty = true;
  Element nancyElement;
  Element backgroundElement;
  Element background2;
  Element borderElement;
  Element freeFloater;

  int bMode = BLEND;

  int[] modes = { ADD, SUBTRACT, DARKEST, LIGHTEST, DIFFERENCE, EXCLUSION, MULTIPLY, SCREEN, REPLACE };

  Layers() {
    pg = createGraphics(2000, 2000);

    setRandomBackground();
    setRandomNancy();
    setRandomBorder();
  }

  Layers clone() {
    // TODO: implement
    //throw new Exception("not implemented");
    return this;
  }


  // returns an image AND sets it. ugh. void? side-effects?
  void setRandomBackground() {
    PImage bkgnd = loadImage(getRandomFile(backgrounds));
    PImage b2 = loadImage(getRandomFile(backgrounds));
    bd = getScaledDimension(new Dimension(bkgnd.width, bkgnd.height), new Dimension(pg.width, pg.height));
    b2d = getScaledDimension(new Dimension(b2.width, b2.height), new Dimension(pg.width, pg.height));

    int index = (int)random(modes.length);
    bMode = modes[index];

    OffsetVelocity velocity = new OffsetVelocity();
    velocity.min = -20;
    velocity.max = 20;
    velocity.stepsMin = 5;
    velocity.stepsMax = 100;

    OffsetLocation location = new OffsetLocation();
    location.xmin = -750;
    location.xmax = 750;
    location.ymin = -250;
    location.ymax = 750;

    OffsetSize size = new OffsetSize();
    size.min = 1;
    size.max = 1.1;
    size.velocityMin = 0.01;
    size.velocityMax = 0.5;
    size.sizeStepsMin = 1;
    size.sizeStepsMax = 5;

    backgroundElement = new Element(bkgnd, velocity, location, size);
    background2 = new Element(b2, velocity, location, size);

    dirty = true;
  }

  Element setRandomNancy() {
    PImage nancy = loadImage(getRandomFile(nancys));
    if (nancyElement == null) {

      OffsetVelocity velocity = new OffsetVelocity();
      velocity.min = -20;
      velocity.max = 20;
      velocity.stepsMin = 5;
      velocity.stepsMax = 10;

      OffsetLocation location = new OffsetLocation();
      location.xmin = -750;
      location.xmax = 750;
      location.ymin = -250;
      location.ymax = 750;

      OffsetSize size = new OffsetSize();
      size.min = 1;
      size.min = 1;
      size.velocityMin = 0;
      size.velocityMax = 0;
      size.sizeStepsMin = 1;
      size.sizeStepsMax = 1;

      nancyElement = new Element(nancy, velocity, location, size);
    } else {
      nancyElement.setImage(nancy);
    }
    dirty = true;
    return nancyElement;
  }

  void moveNancy() {
    nancyElement.update();
    dirty = true;
  }

  void update() {
    nancyElement.update();
    borderElement.update();
    //println("pre-update", backgroundElement.locationOffset.x, backgroundElement.locationOffset.y, backgroundElement.currentStep, backgroundElement.steps);
    backgroundElement.update();
    //println("post-update", backgroundElement.locationOffset.x, backgroundElement.locationOffset.y, backgroundElement.currentStep, backgroundElement.steps);
    background2.update();
    dirty = true;
  }

  PImage setRandomBorder() {
    borderOverlay = loadImage(getRandomFile(overlays));

    OffsetVelocity velocity = new OffsetVelocity();
    velocity.min = -1;
    velocity.max = 1;
    velocity.stepsMin = 5;
    velocity.stepsMax = 20;

    OffsetLocation location = new OffsetLocation();
    location.xmin = -10;
    location.xmax = 10;
    location.ymin = -10;
    location.ymax = 10;

    OffsetSize size = new OffsetSize();
    size.min = 1.01;
    size.min = 1.02;
    size.velocityMin = 0;
    size.velocityMax = 0;
    size.sizeStepsMin = 1;
    size.sizeStepsMax = 1;

    borderElement = new Element(borderOverlay, velocity, location, size);

    dirty = true;
    return borderOverlay;
  }

  Layers randomize() {
    setRandomBackground();
    setRandomNancy();
    setRandomBorder();
    dirty = true;
    return this;
  }

  PGraphics rendered() {
    if (dirty) this.draw();
    return pg;
  }

  // background needs this, but something that doesn't change size does not
  Dimension getScaledDimension(Dimension imageSize, Dimension boundary) {

    double widthRatio = boundary.getWidth() / imageSize.getWidth();
    double heightRatio = boundary.getHeight() / imageSize.getHeight();
    double ratio = Math.max(widthRatio, heightRatio);

    return new Dimension((int) (imageSize.width  * ratio),
      (int) (imageSize.height * ratio));
  }

  void drawElement(Element elem) {
    pg.image(elem.image(), pg.width/2 + elem.locationOffset().x, pg.height/2 + elem.locationOffset().y, pg.width * elem.size(), pg.height * elem.size());
  }

  Layers draw() {
    // we store the rendered layers into a large PGraphics object
    // the sketch then paints that on the visible screen
    pg.beginDraw();
    pg.imageMode(CENTER);
    drawElement(backgroundElement);
    pg.blendMode(bMode);
    drawElement(background2);
    pg.blendMode(BLEND);
    drawElement(nancyElement);
    drawElement(borderElement);
    pg.endDraw();
    dirty = false;
    return this;
  }
}
