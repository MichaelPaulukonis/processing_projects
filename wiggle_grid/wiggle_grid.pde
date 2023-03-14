import java.io.File;
import java.io.IOException;
import java.nio.file.*;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import java.util.Random;

int canvasWidth = 1080;
int canvasHeight = canvasWidth;
int offset = 20;
int count = 3;
Cell[] grid;
int cols = count;
int rows = count;
int fadeSteps = 3;
int skip = 0;
Boolean mainLoopDone = false;

PImage bkgImg;
ArrayList<String> images;
String imageFolder = "/Users/michaelpaulukonis/Documents/processing_projects/wiggle_grid/input/";
ArrayList<PImage> loadedImages;

int imgSize = ((canvasWidth - offset) / count)- (1 * offset);

public int getRandomNumber(int min, int max) {
  return (int) ((Math.random() * (max - min)) + min);
}

public ArrayList<String> listFiles(String dir) throws IOException {
  try (Stream<Path> stream = Files.list(Paths.get(dir))) {
    Set<String> ss = stream
      .filter(file -> !Files.isDirectory(file))
      .map(Path::getFileName)
      .map(Path::toString)
      .collect(Collectors.toSet());
    return new ArrayList<>(ss);
  }
}

public static String randomFile(ArrayList<String> list) {
  int size = list.size();
  int randIdx = new Random().nextInt(size);

  String randomElem = list.get(randIdx);
  return randomElem;
}

PImage loadRandomImage() {
  return loadImage(imageFolder + randomFile(images));
}

PImage getRandomImage() {
  int size = loadedImages.size();
  int randIdx = new Random().nextInt(size);

  PImage randomElem = loadedImages.get(randIdx);
  return randomElem;
}

// doh! we can repeat images, so.... aaaargh!
// need to do a hash or something, do not pick again until exhausted
// then reset
ArrayList<PImage> preLoadImages(int numImages) {
  println("numImages to load: ", numImages);
  ArrayList<PImage> images = new ArrayList<PImage>();
  for (int i = 0; i < numImages; i++) {
    PImage img = loadRandomImage();
    img.resize(imgSize, imgSize);
    images.add(img);
  }
  return images;
}

void settings() {
  size(canvasWidth, canvasWidth);
}

void setup() {
  try {
    images = listFiles(imageFolder);
  }
  catch(IOException error) {
    println(error);
  }
  loadedImages = preLoadImages((rows * cols) + 5);

  bkgImg = loadImage("input/mona.square.00.png");
  grid = new Cell[rows * cols];
  for (int i = 0; i < rows * cols; i++) {
    int row = i % count;
    int col = i / count;
    int offsetX = (row + 1) * offset + (row * imgSize);
    int offsetY = (col + 1) * offset + (col * imgSize);
    int randomFadeSteps = getRandomNumber(3, 10);
    grid[i] = new Cell(getRandomImage(), offsetX, offsetY, imgSize, imgSize, randomFadeSteps);
  }
}

void draw() {
  Boolean allVisible = false;
  image(bkgImg, 0, 0, canvasWidth, canvasHeight);
  if (!mainLoopDone) {
    for (int j = 0; j < rows * cols; j++) {
      Cell cell = grid[j];
      if (j == skip) {
        cell.startEffect();
      }
      cell.update().draw();
      if (cell.vanished()) {
        cell.replaceImage(getRandomImage()).reset().startEffect();
      }
    }
    skip++;
  } else {
    allVisible = true;
    for (int j = 0; j < rows * cols; j++) {
      Cell cell = grid[j];
      if (cell.vanished()) {
        cell.replaceImage(getRandomImage()).reset();
      }
      cell.update().draw();
      allVisible = allVisible && cell.visible();
    }
  }

  if (skip > rows * cols) {
    mainLoopDone = true;
  }

  if (allVisible) {
    noLoop();
  }
  saveFrame("output/movie/monas.missing.####.png");
}
