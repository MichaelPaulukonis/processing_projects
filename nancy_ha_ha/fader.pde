class Fader {

  ElementBounded top;
  ElementBounded bottom;
  int fadeSteps;
  int currentStep = 0;
  PGraphics renderer;
  PGraphics localPg;

  Fader (ElementBounded t, ElementBounded b, int fadeSteps) {
    this.top = t;
    this.bottom = b;
    this.fadeSteps = fadeSteps;

    // new mode (not working)
    this.renderer = createGraphics(2000, 2000);

    // earlier mode (static, no movement)
    this.localPg = createGraphics(2000, 2000);

    println("new fader!");
  }

  Fader update() {
    this.top.update();
    this.bottom.update();
    this.currentStep++;

    if (this.currentStep >= fadeSteps) {
      PImage bkgnd = loadImage(getRandomFile(backgrounds));
      this.top.setImage(bkgnd);
      ElementBounded temp = this.bottom;
      this.bottom = this.top;
      this.top = temp;
      this.currentStep = 0;
    }
    return this;
  }

  float getFade() {
    println("fade step: ", this.currentStep);
    return map(this.currentStep, 0, this.fadeSteps, 255, 0);
  }

  PGraphics image() {
    localPg.beginDraw();
    localPg.imageMode(CORNER);
    localPg.blendMode(BLEND);
    localPg.clear();
    localPg.image(bottom.image(), 0, 0);
    localPg.tint(255, getFade());
    localPg.image(top.image(), 0, 0);
    localPg.endDraw();
    return localPg;
  }

  PGraphics render() {
    renderer.beginDraw();
    renderer.imageMode(CORNER);
    renderer.blendMode(BLEND);
    renderer.clear();
    renderer.image(bottom.render(), 0, 0);
    renderer.tint(255, getFade());
    renderer.image(top.render(), 0, 0);
    renderer.endDraw();
    return renderer;
  }
}
