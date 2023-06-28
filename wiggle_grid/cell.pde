class Cell implements ICell {
  //  ICell addEffect(IEffect ef);
  //  ICell removeEffect(); // hah! how?
  //  ICell clearEffects(); // well, that _would_ remove everything....
  //}

  class Cell implements ICell {
    // A cell object knows about its location in the grid
    // as well as its size with the variables x,y,w,h
    float x, y;   // x,y location
    float w, h;   // width and height
    PImage img;
    ArrayList<IEffect> fxList;

    Cell(PImage i, float tempX, float tempY, float tempW, float tempH) {
      img = i;
      x = tempX;
      y = tempY;
      w = tempW;
      h = tempH;
      fxList = new ArrayList<IEffect>();
    }

    ArrayList<IEffect> Effects() {
      ArrayList<IEffect> clones = new ArrayList<IEffect>(fxList.size());
      for (IEffect item : fxList) clones.add(item.clone());
      return clones;
    }

    ICell addEffect(IEffect ef) {
      fxList.add(ef);
      return this;
    }

    ICell removeEffect(Effect ef) {
      system.out.println("NOT IMPLEMENTED!");
      return this;
    }

    ICell clearEffects() {
      fxList = new ArrayList<IEffect>();
      return this;
    }

    ICell clone() {
      // TODO: deep-clone the FX list
      // but not high priority 'cuz who knows if we will clone
      return new Cell(img, x, y, w, h);
    }

    ICell reset() {
      currentStep = 0;
      direction = -1;
      currentLoop = 0;
      transparency = 255;
      runningEffect = false;
      return this;
    }

    ICell replaceImage(PImage image) {
      img = image;
      return this;
    }

    ICell update() {
      if (runningEffect) {
        transparency = transparency + (direction * reduceBy);
        currentStep++; // oops!!!!! need to modulo by numSteps

        if (currentStep > fadeSteps || currentStep < 0) {
          runningEffect = false;
        }
      }
      return this;
    }

    //Cell startEffect() {
    //  runningEffect = true;
    //  return this;
    //}

    ICell draw() {
      tint(255, transparency);
      image(img, x, y, w, h);
      tint(255, 255);
      return this;
    }


    String toString() {
      return "I am a cell of some kind!";
    }
  }
