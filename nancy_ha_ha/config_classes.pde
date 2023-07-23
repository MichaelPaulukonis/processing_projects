class LocationVelocityConfig {
  int min;
  int max;
  int stepsMin;
  int stepsMax;
}

// xmin should never be less than pg.width/2
class LocationConfig {
  int xmin;
  int xmax;
  int ymin;
  int ymax;
}

class SizeConfig {
  float min;
  float max;
  float velocityMin;
  float velocityMax;
  int sizeStepsMin;
  int sizeStepsMax;
}