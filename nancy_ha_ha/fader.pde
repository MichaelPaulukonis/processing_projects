class Fader {

  ElementBounded top;
  ElementBounded bottom;
  int fadeSteps;
  int currentStep = 0;
  PGraphics renderer;

  int bMode = BLEND;

  int[] modes = { BLEND, BLEND, BLEND, ADD, SUBTRACT, DARKEST, LIGHTEST, DIFFERENCE, EXCLUSION, MULTIPLY, SCREEN, REPLACE };

  // TODO: randomize the fade steps a bit - wobble around passed-in number
  // each time reset, wobble it again (from the original)
  // +/- 50% difference?
  Fader (ElementBounded t, ElementBounded b, int fadeSteps) {
    this.top = t;
    this.bottom = b;
    this.fadeSteps = fadeSteps;
    this.renderer = createGraphics(2000, 2000);
    randomBlendMode();
  }

  Fader randomBlendMode() {
    int index = (int)random(modes.length);
    bMode = modes[index];
    return this;
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
      // only change mode n% of the time .... 1/3 times?
      // maybe disconnect from fade? but that will be a more abrupt change
      // which isn't a bad thing
      randomBlendMode();
    }
    return this;
  }

  float getFade() {
    float fadeAmount = map(this.currentStep, 0, this.fadeSteps, 255, 0);
    println("fade step: ", this.currentStep, " fade amonunt: ", fadeAmount);
    return fadeAmount;
  }

  PGraphics render() {
    renderer.beginDraw();
    renderer.imageMode(CORNER);
    renderer.blendMode(BLEND);
    renderer.clear();
    renderer.image(bottom.render(), 0, 0);
    renderer.tint(255, getFade());
    renderer.blendMode(bMode);
    renderer.image(top.render(), 0, 0);
    renderer.endDraw();
    return renderer;
  }
}
