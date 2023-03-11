PImage img;
int canvasWidth = 1080;
int canvasHeight = canvasWidth;
int offset = 20;
int count = 10;
Cell[] grid;
int cols = count;
int rows = count;

int imgSize = ((canvasWidth - offset) / count)- (1 * offset);

void setup() {
  size(1024, 1024);
  img = loadImage("mona.square.00.png");
  grid = new Cell[rows * cols];
  for (int i = 0; i < rows * cols; i++) {
    int row = i % count;
    int col = i / count;
    int offsetX = (row + 1) * offset + (row * imgSize);
    int offsetY = (col + 1) * offset + (col * imgSize);
    grid[i] = new Cell(img, offsetX, offsetY, imgSize, imgSize);
  }

  //noLoop();
}
int skip = 0;

void draw() {
  background(255);
  println(skip);
  for (int j = 0; j < rows * cols; j++) {
    if (j != skip) {
      grid[j].display();
    }
  }
  saveFrame("movie/monas.missing.####.png");
  skip++;
  if (skip > rows * cols) {
    noLoop();
  }

  //for (Cell c : grid) {
  //  c.display();
  //}
  //save(String.format("mona.grid.%02d.png", count));
}

// let's have a cell class - https://processing.org/tutorials/2darray
// if each cell knows where it goes
// we can display them in arbitrary order
// OR NOT
// and save out frames/video

// A Cell object
class Cell {
  // A cell object knows about its location in the grid
  // as well as its size with the variables x,y,w,h
  float x, y;   // x,y location
  float w, h;   // width and height
  PImage img;

  // Cell Constructor
  Cell(PImage i, float tempX, float tempY, float tempW, float tempH) {
    img = i;
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
  }

  void display() {
    image(img, x, y, w, h);
  }
}
