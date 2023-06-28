interface ICell {
  ArrayList<IEffect> Effects();
  ICell addEffect(IEffect ef);
  ICell removeEffect(); // hah! how?
  ICell clearEffects(); // well, that _would_ remove everything....
  ICell clone();
  ICell reset();
  ICell replaceImage(PImage image);
  ICell update();
  ICell draw();
  String toString();
}
