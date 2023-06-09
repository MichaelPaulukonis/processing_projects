PImage img;
int canvasWidth = 1080;
int canvasHeight = canvasWidth;
int offset = 20;
int count = 3;
Cell[] grid;
int cols = count;
int rows = count;
int fadeSteps = 3;

int imgSize = ((canvasWidth - offset) / count)- (1 * offset);

void setup() {
  size(1024, 1024);
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
  background(255);
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
