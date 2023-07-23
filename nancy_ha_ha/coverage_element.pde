
// >this< this not the "bounded" element - it's the COVERAGE element
// if covers the entire window
// the OTHER class should stay w/in the bounds
class CoverageElement extends BoundedElement {

  PGraphics pg; // overkill - just need size
  Dimension d;
  float ratio;
  
  float getScale(Dimension imageSize, Dimension boundary) {

    double widthRatio = boundary.getWidth() / imageSize.getWidth();
    double heightRatio = boundary.getHeight() / imageSize.getHeight();
    double r = Math.max(widthRatio, heightRatio);

    double mod = Math.min((r * random(1, 5)), this.sizeMax * r);
    return (float)mod;
  }

  CoverageElement(PImage i, LocationVelocityConfig velocity, LocationConfig location, SizeConfig size, PGraphics pg, String[] imagePaths) {
    super(i, velocity, location, size, imagePaths, pg);
    this.pg = pg;
    this.ratio = getScale(new Dimension(i.width, i.height), this.boundary);
  }

  @Override
    CoverageElement updateLocation() {
    // location is a vector
    // it should prolly be an object that only exposes the location
    // but auto-constrains itself
    location.add(locationVelocity);
    currentStep++;
    if (currentStep >= steps) {
      resetOffsetVelocity();
    }

    // use the boundary instead
    float offsetX = constrain(location.x, 0, img.width * ratio - pg.width);
    float offsetY = constrain(location.y, 0, img.height * ratio - pg.height);

    location.x = offsetX;
    location.y = offsetY;

    return this;
  }

  @Override
    CoverageElement update() {
    this.updateSize();
    this.updateLocation();
    return this;
  }

  @Override
    CoverageElement setImage(PImage i) {
    this.img = i;
    this.ratio = getScale(new Dimension(i.width, i.height), new Dimension(pg.width, pg.height));
    return this;
  }

  @Override
    PGraphics render() {
    temp.beginDraw();
    temp.clear();
    temp.background(255);
    temp.image(this.img, 0 - location.x, 0 - location.y,
      ratio * img.width, ratio * img.height);
    temp.endDraw();
    return temp;
  }
}
