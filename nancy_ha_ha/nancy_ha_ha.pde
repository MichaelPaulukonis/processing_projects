import java.io.File;
import java.io.FilenameFilter;
import java.util.Arrays;
import java.awt.Dimension;

int canvasWidth = 2000;
int canvasHeight = canvasWidth;
Layers layers;
boolean shiftIsPressed = false;
boolean alwaysSave = false;

String root = "/Users/michaelpaulukonis//projects/processing_projects_orig/nancy_ha_ha/";
String componentPath = "input/components";
String nancyComponentPath = "input/components.nancy";
String overlayPath = "input/overlays"; // border overlays
String backgroundPath = "input/backgrounds";


public static String[] getFiles(String folderpath) {
  ArrayList<String> paths = new ArrayList<String>();
  File[] files = new File(folderpath).listFiles((dir, name) -> name.toLowerCase().endsWith(".jpg") || name.toLowerCase().endsWith(".jpeg") || name.toLowerCase().endsWith(".png"));
  for (File file : files) {
    if (file.isFile()) {
      paths.add(file.getAbsolutePath());
    }
  }
  return paths.toArray(new String[0]);
}

String[] backgrounds = getFiles(root + backgroundPath);
String[] nancys = getFiles(root + nancyComponentPath);
String[] overlays = getFiles(root + overlayPath);
String[] freeComponents = getFiles(root + componentPath);

String getRandomFile(String[] files) {
  int index = int(random(files.length));
  return files[index];
}

String timestamp() {
  return year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
}

void setup() {
  imageMode(CENTER);
  size(800, 800); // allows it to fit on screen so I can see it
  layers = new Layers();
}

void draw() {
  layers.update();
  image(layers.rendered(), width/2, height/2, width, height);
  if (alwaysSave) saveFrame();
}

void saveFrame() {
  String fname = "output/nancy." + timestamp() + "." + frameCount + ".tga";
  layers.rendered().save(fname);
  println("Saved as: " + fname);
}

void keyPressed() {
  if (key==CODED) {
    if (keyCode == SHIFT) shiftIsPressed = true;
    else  if (keyCode == 39 || keyCode == 37) {
      int x = 10 * ((keyCode == 37) ? -1 : 1) * (shiftIsPressed ? 10 : 1);
      //layers.updateNancyOffset(new Dimension(x, 0));
    }
    if (keyCode == 38 || keyCode == 40) {
      int y = 10 * ((keyCode == 38) ? -1 : 1) * (shiftIsPressed ? 10 : 1);
      //layers.updateNancyOffset(new Dimension(0, y));
    }
  } else if (key == 'm') {
    println("let's move it!");
    layers.moveNancy();
  } else if (key == 'd' || key == 'D') {
    layers.randomize();
  } else if (key == 'b' || key == 'B') {
    layers.setRandomBackground();
  } else if (key == 'n') {
    layers.newNancyImage();
  } else if (key == 'N') {
    layers.setRandomNancy();
  } else if (key == 'o' || key == 'O') {
    layers.setRandomBorder();
  } else if (key == 's') {
    saveFrame();
  } else if (key == 'S') {
    alwaysSave = !alwaysSave;
    if (alwaysSave) saveFrame();
  }
}

void keyReleased() {
  if (key==CODED) {
    if (keyCode == SHIFT) shiftIsPressed = false;
  }
}

/**

TODO: 
 - images change automaticlly
 - movement "bounces" off edges (and... corners?)
 - keys to pick/next/random components
 - 

**/
