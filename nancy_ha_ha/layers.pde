class Layers {
  PImage borderOverlay;
  PImage[] components;
  PGraphics pg;
  Dimension bd;
  Dimension b2d;
  Boolean dirty = true;
  Element nancyElement;
  ElementBounded backgroundElement;
  ElementBounded background2;
  ElementBounded borderElement;
  Element freeFloater;

  int bMode = BLEND;

  int[] modes = { ADD, SUBTRACT, DARKEST, LIGHTEST, DIFFERENCE, EXCLUSION, MULTIPLY, SCREEN, REPLACE };

  Layers() {
    pg = createGraphics(2000, 2000);

    setRandomBackground();
    setRandomNancy();
    setRandomBorder(); // also called overlay (needs to be consolidated)
    setRandomFloater();
  }

  Layers clone() {
    // TODO: implement
    //throw new Exception("not implemented");
    return this;
  }


  void setRandomBackground() {
    PImage bkgnd = loadImage(getRandomFile(backgrounds));
    PImage b2 = loadImage(getRandomFile(backgrounds));
    bd = getScaledDimension(new Dimension(bkgnd.width, bkgnd.height), new Dimension(pg.width, pg.height));
    b2d = getScaledDimension(new Dimension(b2.width, b2.height), new Dimension(pg.width, pg.height));

    int index = (int)random(modes.length);
    bMode = modes[index];

    OffsetVelocity velocity = new OffsetVelocity(); // straight-up added to offsetLocation
    velocity.min = -10;
    velocity.max = 10;
    velocity.stepsMin = 5;
    velocity.stepsMax = 100;

    OffsetSize size = new OffsetSize();
    size.min = 1.1;
    size.max = 2;
    size.velocityMin = 0.001;
    size.velocityMax = 0.01;
    size.sizeStepsMin = 5;
    size.sizeStepsMax = 20;

    // this should be a function of image-dimensions and size and background dimensions (bd,b2d)
    // if offset + size means part of screen is uncovered, things have to change
    OffsetLocation location = new OffsetLocation();  // from center of canvas (pg)
    location.xmin = -100; 
    location.xmax = 100; 
    location.ymin = -250;
    location.ymax = 250;

    backgroundElement = new ElementBounded(bkgnd, velocity, location, size, pg);
    background2 = new ElementBounded(b2, velocity, location, size, pg);

    dirty = true;
  }

  Element setRandomFloater() {
    PImage floater = loadImage(getRandomFile(freeComponents));

    OffsetVelocity velocity = new OffsetVelocity();
    velocity.min = -20;
    velocity.max = 20;
    velocity.stepsMin = 5;
    velocity.stepsMax = 10;

    OffsetLocation location = new OffsetLocation();
    location.xmin = -1000;
    location.xmax = 100;
    location.ymin = -1000;
    location.ymax = 1000;

    OffsetSize size = new OffsetSize();
    size.min = 0.5;  // but this is multiplied by image original size
    size.max = 2;
    size.velocityMin = -0.02;
    size.velocityMax = 0.02; // added to size, not multiplied
    size.sizeStepsMin = 1;
    size.sizeStepsMax = 1;

    freeFloater = new Element(floater, velocity, location, size);
    dirty = true;
    return freeFloater;
  }

  Element setRandomNancy() {
    PImage nancy = loadImage(getRandomFile(nancys));

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
    size.max = 1;
    size.velocityMin = 0;
    size.velocityMax = 0;
    size.sizeStepsMin = 1;
    size.sizeStepsMax = 1;

    nancyElement = new Element(nancy, velocity, location, size);
    dirty = true;
    return nancyElement;
  }

  Element newNancyImage() {
    PImage nancy = loadImage(getRandomFile(nancys));
    nancyElement.setImage(nancy);
    dirty = true;
    return nancyElement;
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
    //size.min = 1.0; // this should be relative to the target size, not to the original
    //size.max = 1.02;
    size.min = 1.0;
    size.max = 1.02;
    size.velocityMin = 0;
    size.velocityMax = 0;
    size.sizeStepsMin = 1;
    size.sizeStepsMax = 1;

    borderElement = new ElementBounded(borderOverlay, velocity, location, size, pg);

    dirty = true;
    return borderOverlay;
  }

  void moveNancy() {
    nancyElement.update();
    dirty = true;
  }

  void update() {
    freeFloater.update();
    nancyElement.update();
    borderElement.update();
    backgroundElement.update();
    background2.update();
    dirty = true;
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
  // aaaaaaand, we're not taking into consideration image movement or resizing.....
  Dimension getScaledDimension(Dimension imageSize, Dimension boundary) {

    double widthRatio = boundary.getWidth() / imageSize.getWidth();
    double heightRatio = boundary.getHeight() / imageSize.getHeight();
    double rt = Math.max(widthRatio, heightRatio);

    return new Dimension((int) (imageSize.width  * rt),
      (int) (imageSize.height * rt));
  }

  void drawElement(Element elem) {
    pg.image(elem.image(), elem.locationOffset().x, elem.locationOffset().y,
      pg.width * elem.size(), pg.height * elem.size());
  }

  void drawElement(Element elem, Dimension d) {
    pg.image(elem.image(), elem.locationOffset().x, elem.locationOffset().y,
      d.width * elem.size(), d.height * elem.size());
  }

  void drawElement2(ElementBounded elem) {
    pg.image(elem.image(), 0 - elem.locationOffset().x, 0 - elem.locationOffset().y,
      elem.ratio * elem.image().width, elem.ratio * elem.image().height);
  }

  Layers draw() {
    // we store the rendered layers into a large PGraphics object
    // the sketch then paints that on the visible screen
    pg.beginDraw();
    pg.imageMode(CORNER);
    drawElement2(backgroundElement);
    pg.blendMode(bMode);
    drawElement2(background2);
    pg.blendMode(BLEND);
    drawElement(freeFloater);
    drawElement(nancyElement);
    println("border ratio: ", borderElement.ratio, borderElement.image().width, borderElement.locationOffset().x);
    drawElement2(borderElement);
    pg.endDraw();
    dirty = false;
    return this;
  }
}
