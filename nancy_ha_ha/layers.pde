class Layers {
  PImage bkgnd;
  PImage borderOverlay;
  PImage[] components;
  PGraphics pg;
  Dimension bd;
  Boolean dirty = true;
  Element nancyElement;
  Element backgroundElement;
  Element borderElement;

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
  PImage setRandomBackground() {
    bkgnd = loadImage(getRandomFile(backgrounds));
    bd = getScaledDimension(new Dimension(bkgnd.width, bkgnd.height), new Dimension(pg.width, pg.height));

    //Element(PImage img, int offsetVelocityMin, int offsetVelocityMax, int offsetVelocitySteps,
    //int xmin, int xmax, int ymin, int ymax,
    //float sizeMin, float sizeMax, float svMin, float svMax, int sizeStepsMin, int sizeStepsMax)
    //nancyElement = new Element(nancy, -20, 20, 5, 10, -750, 750, -250, 750, 0.75, 3, -0.02, 0.02, 5, 10);
    // aw crap, there's no scaling in the Element. HAH HAH HAH
    //background = new Element(bkgnd, -20, 20, 5, 10, -750, 750, -250, 750, 1, 1, 0, 0, 1, 1);


    dirty = true;
    return bkgnd;
  }

  Element setRandomNancy() {
    PImage nancy = loadImage(getRandomFile(nancys));
    if (nancyElement == null) {
      //nancyElement = new Element(nancy);
      //Element(PImage img, int offsetVelocityMin, int offsetVelocityMax, int offsetVelocitySteps,
      //int xmin, int xmax, int ymin, int ymax,
      //float sizeMin, float sizeMax, float svMin, float svMax, int sizeStepsMin, int sizeStepsMax)
      //nancyElement = new Element(nancy, -20, 20, 5, 10, -750, 750, -250, 750, 0.75, 3, -0.02, 0.02, 5, 10);
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
    dirty = true;
  }

  PImage setRandomBorder() {
    borderOverlay = loadImage(getRandomFile(overlays));

    //Element(PImage img, int offsetVelocityMin, int offsetVelocityMax, int offsetVelocitySteps,
    //int xmin, int xmax, int ymin, int ymax,
    //float sizeMin, float sizeMax, float svMin, float svMax, int sizeStepsMin, int sizeStepsMax)
    //nancyElement = new Element(nancy, -20, 20, 5, 10, -750, 750, -250, 750, 0.75, 3, -0.02, 0.02, 5, 10);
    //borderElement = new Element(borderOverlay, -1, 1, 5, 20, -10, 10, -10, 10, 1.01, 1.02, 0, 0, 1, 1);
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

  Layers draw() {
    // we store the rendered layers into a large PGraphics object
    // the sketch then paints that on the visible screen
    pg.beginDraw();
    pg.imageMode(CENTER);
    pg.image(bkgnd, pg.width/2, pg.height/2, (float)bd.width, (float)bd.height); // needs to be proportional to original
    pg.image(nancyElement.image(), pg.width/2 + nancyElement.locationOffset().x, pg.height/2 + nancyElement.locationOffset().y, pg.width * nancyElement.size(), pg.height * nancyElement.size());

    //pg.image(borderOverlay, pg.width/2, pg.height/2, pg.width, pg.height);
    pg.image(borderElement.image(), pg.width/2 + borderElement.locationOffset().x, pg.height/2 + borderElement.locationOffset().y, pg.width * borderElement.size(), pg.height * borderElement.size());


    pg.endDraw();
    dirty = false;
    return this;
  }
}
