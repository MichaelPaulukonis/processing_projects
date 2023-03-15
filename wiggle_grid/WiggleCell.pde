
class WiggleCell implements ICell {
  float x, y;   // x,y location
  float w, h;   // width and height
  int reduceBy;
  int dx = randomDirection();
  int dy = randomDirection();
  float ox, oy;
  int maxDistance;
  PImage img;
  Boolean runningEffect = false;

  int getRandomNumber(int min, int max) {
    return (int) ((Math.random() * (max - min)) + min);
  }
  
  int randomDirection() {
     return getRandomNumber(-1, 1); 
  }

  WiggleCell(PImage i, float tempX, float tempY, float tempW, float tempH, int md) {
    img = i;
    x = tempX;
    ox = tempX;
    y = tempY;
    oy = tempY;
    w = tempW;
    h = tempH;
    maxDistance = md;
  }

  WiggleCell clone() {
    return new WiggleCell(img, x, y, w, h, fadeSteps);
  }

  WiggleCell reset() {
    dx = randomDirection();
    dy = randomDirection();
    x = ox;
    y = oy;
    runningEffect = false;
    return this;
  }

  WiggleCell replaceImage(PImage image) {
    img = image;
    return this;
  }

  WiggleCell update() {
    if (runningEffect) {
      x = (x + dx) <= ox + maxDistance ? x + dx : x;
      y = (y + dy) <= oy + maxDistance ? x + dy : y;
      dx = randomDirection();
      dy = randomDirection();
    }
    return this;
  }

  WiggleCell startEffect() {
    runningEffect = true;
    return this;
  }

  WiggleCell draw() {
    image(img, x, y, w, h);
    return this;
  }
}
