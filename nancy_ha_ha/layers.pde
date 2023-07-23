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
    velocity.min = -10;
    velocity.max = 10;
    velocity.stepsMin = 5;
    velocity.stepsMax = 100;

    SizeConfig size = new SizeConfig();
    size.min = 1.1;
    size.max = 2;
    size.velocityMin = 0.001;
    size.velocityMax = 0.01;
    size.sizeStepsMin = 5;
    size.sizeStepsMax = 20;

    LocationConfig location = new LocationConfig();
    location.xmin = -100; 
    location.xmax = 100; 
    location.ymin = -250;
    location.ymax = 250;

    CoverageElement backgroundBoundedElement = new CoverageElement(bkgnd, velocity, location, size, pg, backgrounds);
    CoverageElement background2 = new CoverageElement(b2, velocity, location, size, pg, backgrounds);

    backgroundFader = new Fader(backgroundBoundedElement, background2, 20, backgrounds);

    dirty = true;
  }

  BoundedElement setRandomFloater() {
    PImage floater = loadImage(getRandomFile(freeComponents));

    LocationVelocityConfig velocity = new LocationVelocityConfig();
    velocity.min = -20;
    velocity.max = 20;
    velocity.stepsMin = 5;
    velocity.stepsMax = 10;

    LocationConfig location = new LocationConfig();
    location.xmin = -1000;
    location.xmax = 100;
    location.ymin = -1000;
    location.ymax = 1000;

    SizeConfig size = new SizeConfig();
    size.min = 0.5;
    size.max = 2;
    size.velocityMin = -0.02;
    size.velocityMax = 0.02; // added to size, not multiplied
    size.sizeStepsMin = 1;
    size.sizeStepsMax = 1;

    freeFloater = new BoundedElement(floater, velocity, location, size, freeComponents);
    dirty = true;
    return freeFloater;
  }

  BoundedElement setRandomNancy() {
    PImage nancy = loadImage(getRandomFile(nancys));

    LocationVelocityConfig velocity = new LocationVelocityConfig();
    velocity.min = -20;
    velocity.max = 20;
    velocity.stepsMin = 5;
    velocity.stepsMax = 10;

    LocationConfig location = new LocationConfig();
    location.xmin = -750;
    location.xmax = 750;
    location.ymin = -250;
    location.ymax = 750;

    SizeConfig size = new SizeConfig();
    size.min = 1;
    size.max = 1;
    size.velocityMin = 0;
    size.velocityMax = 0;
    size.sizeStepsMin = 1;
    size.sizeStepsMax = 1;

    nancyBoundedElement = new BoundedElement(nancy, velocity, location, size, nancys);
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
    velocity.min = -1;
    velocity.max = 1;
    velocity.stepsMin = 5;
    velocity.stepsMax = 20;

    LocationConfig location = new LocationConfig();
    location.xmin = -10;
    location.xmax = 10;
    location.ymin = -10;
    location.ymax = 10;

    SizeConfig size = new SizeConfig();
    size.min = 1.0;
    size.max = 1.02;
    size.velocityMin = 0;
    size.velocityMax = 0;
    size.sizeStepsMin = 1;
    size.sizeStepsMax = 1;

    borderBoundedElement = new CoverageElement(borderOverlay, velocity, location, size, pg, overlays);

    dirty = true;
    return borderOverlay;
  }

  void moveNancy() {
    nancyBoundedElement.update();
    dirty = true;
  }

  void update() {
    freeFloater.update();
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
