interface ICell {
  ICell clone();
  ICell reset();
  ICell replaceImage(PImage image);
  ICell update();
  ICell draw();
  ICell startEffect();
}
