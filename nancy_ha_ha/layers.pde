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
  Element borderElement;
  Element freeFloater;

  int bMode = BLEND;

  int[] modes = { ADD, SUBTRACT, DARKEST, LIGHTEST, DIFFERENCE, EXCLUSION, MULTIPLY, SCREEN, REPLACE };

  Layers() {
    pg = createGraphics(2000, 2000);

    setRandomBackground();
    setRandomNancy();
    setRandomBorder();
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
    size.min = 1.5;
    size.max = 3;
    size.velocityMin = 0.001;
    size.velocityMax = 0.01;
    size.sizeStepsMin = 5;
    size.sizeStepsMax = 20;

    // this should be a function of image-dimensions and size and background dimensions (bd,b2d)
    // if offset + size means part of screen is uncovered, things have to change
    OffsetLocation location = new OffsetLocation();  // from center of canvas (pg)
    location.xmin = -750; // (pg.width / 2) - ((bd.width * size) / 2) - xmin <= 0
    location.xmax = 750;  // (pg.width / 2) - ((bd.width * size) / 2) + xmax >= pg.width
    location.ymin = -250; // (pg.height / 2) - ((bd.height * size) / 2) - ymin <= 0
    location.ymax = 750; // (pg.height / 2) - ((bd.height * 2) / 1) + ymax >= pg.height

    // xmin >= (pg.width / 2) - ((bd.width * size) / 2)
    // xmax <= pg.width - (pg.width / 2) + ((bd.width * size) / 2)
    // (pg.height / 2) - ((bd.height * size) / 2) - ymin <= 0
    // (pg.height / 2) - ((bd.height * 2) / 1) + ymax >= pg.height

    backgroundElement = new ElementBounded(bkgnd, velocity, location, size, pg, bd);
    background2 = new ElementBounded(b2, velocity, location, size, pg, b2d);

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
    size.min = 1.01;
    size.max = 1.02;
    size.velocityMin = 0;
    size.velocityMax = 0;
    size.sizeStepsMin = 1;
    size.sizeStepsMax = 1;

    borderElement = new Element(borderOverlay, velocity, location, size);

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
    double ratio = Math.max(widthRatio, heightRatio);

    return new Dimension((int) (imageSize.width  * ratio),
      (int) (imageSize.height * ratio));
  }

  void drawElement(Element elem) {
    pg.image(elem.image(), pg.width/2 + elem.locationOffset().x, pg.height/2 + elem.locationOffset().y,
      pg.width * elem.size(), pg.height * elem.size());
  }

  // the 
  void drawElement(Element elem, Dimension d) {
    pg.image(elem.image(), pg.width/2 + elem.locationOffset().x, pg.height/2 + elem.locationOffset().y,
      d.width * elem.size(), d.height * elem.size());
  }
  
  void drawElement(ElementBounded elem) {
    pg.image(elem.image(), pg.width/2 + elem.locationOffset().x, pg.height/2 + elem.locationOffset().y,
      elem.d.width * elem.size(), elem.d.height * elem.size());
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
    drawElement(freeFloater);
    drawElement(nancyElement);
    drawElement(borderElement);
    pg.endDraw();
    dirty = false;
    return this;
  }
}
