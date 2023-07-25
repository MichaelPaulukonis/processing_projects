class Layers {
  PImage borderOverlay;
  PImage[] components;
  PGraphics pg;
  Boolean dirty = true;
  BoundedElement nancyBoundedElement;
  CoverageElement borderBoundedElement;
  BoundedElement freeFloater;
  Fader backgroundFader;

  Layers() {
    pg = createGraphics(2000, 2000);  // variable-ize

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

    LocationVelocityConfig velocity = new LocationVelocityConfig(); // straight-up added to offsetLocation
    velocity.min = -40;
    velocity.max = 50;
    velocity.stepsMin = 5;
    velocity.stepsMax = 10;

    SizeConfig size = new SizeConfig();
    size.min = 0.9;
    size.max = 2;
    size.velocityMin = 0.001;
    size.velocityMax = 0.01;
    size.sizeStepsMin = 5;
    size.sizeStepsMax = 40;

    // hunh not sure if right values
    LocationConfig location = new LocationConfig();
    location.xmin = -500; 
    location.xmax = 500; 
    location.ymin = -750;
    location.ymax = 750;

    CoverageElement backgroundBoundedElement = new CoverageElement(bkgnd, velocity, location, size, pg, backgrounds);
    CoverageElement background2 = new CoverageElement(b2, velocity, location, size, pg, backgrounds);

    backgroundFader = new Fader(backgroundBoundedElement, background2, 20, backgrounds);

    dirty = true;
  }

  BoundedElement setRandomFloater() {
    PImage floater = loadImage(getRandomFile(freeComponents));

    LocationVelocityConfig velocity = new LocationVelocityConfig();
    velocity.min = -40;
    velocity.max = 40;
    velocity.stepsMin = 10;
    velocity.stepsMax = 100;

    LocationConfig location = new LocationConfig();
    location.xmin = -1000;
    location.xmax = 1000;
    location.ymin = -1000;
    location.ymax = 1000;

    SizeConfig size = new SizeConfig();
    size.min = 0.5;
    size.max = 2;
    size.velocityMin = -0.02;
    size.velocityMax = 0.02; // added to size, not multiplied
    size.sizeStepsMin = 1;
    size.sizeStepsMax = 1;

    freeFloater = new BoundedElement(floater, velocity, location, size, freeComponents, pg);
    dirty = true;
    return freeFloater;
  }

  BoundedElement setRandomNancy() {
    PImage nancy = loadImage(getRandomFile(nancys));

    LocationVelocityConfig velocity = new LocationVelocityConfig();
    velocity.min = -40;
    velocity.max = 40;
    velocity.stepsMin = 5;
    velocity.stepsMax = 100;

    LocationConfig location = new LocationConfig();
    location.xmin = -250;
    location.xmax = 250;
    location.ymin = -250;
    location.ymax = 250;

    SizeConfig size = new SizeConfig();
    size.min = 1;
    size.max = 1;
    size.velocityMin = -1;
    size.velocityMax = 1;
    size.sizeStepsMin = 10;
    size.sizeStepsMax = 100;

    nancyBoundedElement = new BoundedElement(nancy, velocity, location, size, nancys, pg);
    dirty = true;
    return nancyBoundedElement;
  }

  BoundedElement newNancyImage() {
    PImage nancy = loadImage(getRandomFile(nancys));
    nancyBoundedElement.setImage(nancy);
    dirty = true;
    return nancyBoundedElement;
  }

  PImage setRandomBorder() {
    borderOverlay = loadImage(getRandomFile(overlays));

    LocationVelocityConfig velocity = new LocationVelocityConfig();
    velocity.min = -2;
    velocity.max = 2;
    velocity.stepsMin = 20;
    velocity.stepsMax = 100;

    LocationConfig location = new LocationConfig();
    location.xmin = -20;
    location.xmax = 20;
    location.ymin = -20;
    location.ymax = 20;

    SizeConfig size = new SizeConfig();
    size.min = 0.95;
    size.max = 1.02;
    size.velocityMin = 0.01;
    size.velocityMax = 0.02;
    size.sizeStepsMin = 10;
    size.sizeStepsMax = 100;

    borderBoundedElement = new CoverageElement(borderOverlay, velocity, location, size, pg, overlays);

    dirty = true;
    return borderOverlay;
  }

  void moveNancy() {
    nancyBoundedElement.update();
    dirty = true;
  }

  void update() {
    // freeFloater.update();
    nancyBoundedElement.update();
    borderBoundedElement.update();
    backgroundFader.update();
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

  Dimension getScaledDimension(Dimension imageSize, Dimension boundary) {

    double widthRatio = boundary.getWidth() / imageSize.getWidth();
    double heightRatio = boundary.getHeight() / imageSize.getHeight();
    double rt = Math.max(widthRatio, heightRatio);

    return new Dimension((int) (imageSize.width  * rt),
      (int) (imageSize.height * rt));
  }

  void drawBoundedElement(BoundedElement elem) {
    pg.image(elem.image(), elem.location().x, elem.location().y,
      pg.width * elem.size(), pg.height * elem.size());
  }

  // make this part of the fader
  // heck, it might be part of each element, come to think of it
  // in which case.....
  void drawBoundedElement2(CoverageElement elem) {
    pg.image(elem.image(), 0 - elem.location().x, 0 - elem.location().y,
      elem.ratio * elem.image().width, elem.ratio * elem.image().height);
  }

  Layers draw() {
    // we store the rendered layers into a large PGraphics object
    // the sketch then paints that on the visible screen
    pg.beginDraw();
    pg.clear();
    pg.background(255);
    pg.imageMode(CORNER);
    pg.image(backgroundFader.render(), 0, 0);
    pg.blendMode(BLEND);
    drawBoundedElement(freeFloater);
    drawBoundedElement(nancyBoundedElement);
    drawBoundedElement2(borderBoundedElement);
    pg.endDraw();
    dirty = false;
    return this;
  }
}
