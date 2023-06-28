import java.io.File;
import java.io.IOException;
import java.nio.file.*;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import java.util.Random;
import java.util.ArrayList;
import java.util.Collections;

int canvasWidth = 800;
int canvasHeight = canvasWidth;
int offset = 20;
int count = 4;
ICell[] grid;
int cols = count;
int rows = count;
int fadeSteps = 3;
int skip = 0;
Boolean mainLoopDone = false;

PImage bkgImg;
ArrayList<String> imageFilenames;
String imageFolder = "/Users/michaelpaulukonis/Documents/processing_projects/wiggle_grid/input/";
ArrayList<PImage> loadedImages;
ArrayList<PImage> loadedImagesOriginal;

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

PImage getRandomImage() {
  if (loadedImages.size() == 0) {
    loadedImages = new ArrayList<PImage>(loadedImagesOriginal);
    Collections.shuffle(loadedImages);
  }
  return loadedImages.remove(0);
}

ArrayList<PImage> preLoadImages(int numImages) {
  println("numImages to load: ", numImages);
  ArrayList<String> shuffledNames = new ArrayList<String>();
  ArrayList<PImage> images = new ArrayList<PImage>();
  for (int i = 0; i < numImages; i++) {
    if (shuffledNames.size() == 0) {
      shuffledNames = new ArrayList<String>(imageFilenames);
      Collections.shuffle(shuffledNames);
    }
    PImage img = loadImage(imageFolder + shuffledNames.remove(0));
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
    imageFilenames = listFiles(imageFolder);
  }
  catch(IOException error) {
    println(error);
  }
  loadedImages = preLoadImages((rows * cols) + 5);
  loadedImagesOriginal = new ArrayList<PImage>(loadedImages);

  bkgImg = loadImage("input/mona.square.00.png");
  grid = new FadeCell[rows * cols];
  for (int i = 0; i < rows * cols; i++) {
    int row = i % count;
    int col = i / count;
    int offsetX = (row + 1) * offset + (row * imgSize);
    int offsetY = (col + 1) * offset + (col * imgSize);
    int randomFadeSteps = getRandomNumber(3, 10);
    grid[i] = new FadeCell(getRandomImage(), offsetX, offsetY, imgSize, imgSize, randomFadeSteps);
  }
}

// TODO: get this to work with wiggles
// then figure out how to do both
// doh! a cell should not be of an effect type
// a cell should _contain_ effect types!
// so multiples, and all that.
void draw() {
  Boolean allVisible = false;
  image(bkgImg, 0, 0, canvasWidth, canvasHeight);
  if (!mainLoopDone) {
    for (int j = 0; j < rows * cols; j++) {
      FadeCell cell = (FadeCell)grid[j];
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
      FadeCell cell = (FadeCell)grid[j];
      // TODO: needs to be something common to the interface?
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

void drawFadeCells() {
  Boolean allVisible = false;
  image(bkgImg, 0, 0, canvasWidth, canvasHeight);
  if (!mainLoopDone) {
    for (int j = 0; j < rows * cols; j++) {
      FadeCell cell = (FadeCell)grid[j];
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
      FadeCell cell = (FadeCell)grid[j];
      // TODO: needs to be something common to the interface?
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
