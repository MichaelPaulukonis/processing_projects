class Layers {
  PImage bkgnd;
  PImage borderOverlay;
  PImage[] components;
  PGraphics pg;
  Dimension bd;
  Boolean dirty = true;
  Element nancyElement;

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
      nancyElement = new Element(nancy, -20, 20, 5, 10, -750, 750, -250, 750, 1, 1, 0, 0, 1, 1);
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

  PImage setRandomBorder() {
    borderOverlay = loadImage(getRandomFile(overlays));
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

  Layers draw() {
    // we store the rendered layers into a large PGraphics object
    // the sketch then paints that on the visible screen
    pg.beginDraw();
    pg.imageMode(CENTER);
    pg.image(bkgnd, pg.width/2, pg.height/2, (float)bd.width, (float)bd.height); // needs to be proportional to original
    pg.image(nancyElement.image(), pg.width/2 + nancyElement.locationOffset().x, pg.height/2 + nancyElement.locationOffset().y, pg.width * nancyElement.size(), pg.height * nancyElement.size());

    pg.image(borderOverlay, pg.width/2, pg.height/2, pg.width, pg.height);
    pg.endDraw();
    dirty = false;
    return this;
  }
}
