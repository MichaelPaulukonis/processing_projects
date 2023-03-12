import java.io.File;
import java.io.IOException;
import java.nio.file.*;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

PImage img;
int canvasWidth = 1080;
int canvasHeight = canvasWidth;
int offset = 20;
int count = 3;
Cell[] grid;
int cols = count;
int rows = count;
int fadeSteps = 3;
PImage bkgImg;
String[] images;

int imgSize = ((canvasWidth - offset) / count)- (1 * offset);


// TODO: read-in images
// we will use one at random for each cell
public Set<String> listFilesUsingFilesList(String dir) throws IOException {
    try (Stream<Path> stream = Files.list(Paths.get(dir))) {
        return stream
          .filter(file -> !Files.isDirectory(file))
          .map(Path::getFileName)
          .map(Path::toString)
          .collect(Collectors.toSet());
    }
}


void setup() {
  size(1024, 1024);
  bkgImg = loadImage("input/mona.square.00.png");
  img = loadImage("input/mona.square.00.png");
  grid = new Cell[rows * cols];
  for (int i = 0; i < rows * cols; i++) {
    int row = i % count;
    int col = i / count;
    int offsetX = (row + 1) * offset + (row * imgSize);
    int offsetY = (col + 1) * offset + (col * imgSize);
    grid[i] = new Cell(img, offsetX, offsetY, imgSize, imgSize, fadeSteps);
  }
}
int skip = 0;

void draw() {
  image(bkgImg, 0, 0, canvasWidth, canvasHeight);
  for (int j = 0; j < rows * cols; j++) {
    Cell cell = grid[j];
    if (j == skip) {
      cell.startEffect();
    }
    cell.update().draw();
  }
  saveFrame("output/movie/monas.missing.####.png");
  skip++;
  if (skip > rows * cols) { // this doesn't take into account frames need to finish effects
    noLoop();
  }
}
