class Fader {

  CoverageElement top;
  CoverageElement bottom;
  int fadeSteps;
  int sessionSteps;
  int currentStep = 0;
  PGraphics renderer;
  int bMode = BLEND;
  final int FADE = 1000;
  String[] imagePaths;

  int[] modes = { BLEND, BLEND, BLEND, ADD, SUBTRACT, DARKEST, LIGHTEST,
    DIFFERENCE, EXCLUSION, MULTIPLY, SCREEN, REPLACE, FADE };

  Fader (CoverageElement t, CoverageElement b, int fadeSteps, String[] images) {
    this.top = t;
    this.bottom = b;
    this.fadeSteps = fadeSteps;
    this.renderer = createGraphics(2000, 2000);
    randomBlendMode();
    this.sessionSteps = randomizedSteps();
    this.imagePaths = images;
  }

  Fader randomBlendMode() {
    int index = (int)random(modes.length);
    bMode = modes[index];
    return this;
  }

  int randomizedSteps() {
    int direction = random(1) > 0.5 ? 1 : -1;
    int offset = (int)random(this.fadeSteps / 2);
    return this.fadeSteps + (direction * offset);
  }

  Fader update() {
    this.top.update();
    this.bottom.update();
    this.currentStep++;

    if (this.currentStep >= this.sessionSteps) {
      PImage bkgnd = loadImage(getRandomFile(this.imagePaths));
      this.top.setImage(bkgnd);
      CoverageElement temp = this.bottom;
      this.bottom = this.top;
      this.top = temp;
      this.currentStep = 0;
      this.sessionSteps = randomizedSteps();
      if (random(3) > 2) {
        randomBlendMode();
      }
    }
    return this;
  }

  float getFade() {
    float fadeAmount = map(this.currentStep, 0, this.sessionSteps, 255, 0);
    return fadeAmount;
  }

  PGraphics setMode(PGraphics r) {
    if (bMode == FADE) {
      r.tint(255, getFade());
    } else {
      r.blendMode(bMode);
    }
    return r;
  }

  PGraphics render() {
    renderer.beginDraw();
    renderer.imageMode(CORNER);
    renderer.blendMode(BLEND);
    renderer.clear();
    renderer.image(bottom.render(), 0, 0);
    setMode(renderer)
      .image(top.render(), 0, 0);
    renderer.endDraw();
    return renderer;
  }
}
