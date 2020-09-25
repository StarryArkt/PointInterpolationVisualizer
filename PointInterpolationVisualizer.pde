import java.util.*;
import org.apache.commons.lang3.ArrayUtils;

int grabMode = 3;
float[] grabDists = {5, 16, 40, 60, 100};

int mode;
String[] modeNames = {"Constrained Spline", "Cubic Spline", "Linear", "Constrained + Linear", "Points"};

ArrayList<Point> points = new ArrayList<Point>();
double[] holderX = new double[] {50, 200, 500, 800, 950};
double[] holderY = new double[] {100, 150, 400, 150, 100};

PolynomialSplineFunction splines;

boolean dragging;
boolean clicking;

Comparator<Point> compareX;

void setup() {
  size(1000, 1000);
  frameRate(60);
  
  textSize(28);
  stroke(255);
  noFill();
  
  compareX = new Comparator<Point>() {
    public int compare(Point p0, Point p1) {
      return (int) (p0.getX() - p1.getX());
    }
  };
  
  for (int i = 0; i < holderX.length; i++) {
    points.add(new Point(holderX[i], holderY[i]));
  }
}

void draw() {
  background(0);
  textAlign(LEFT, CENTER);
  
  loadPoints();
  checkForNonuniquePoints();
  loadPoints();
  
  Arrays.sort(holderX);

  if (verticalLineTest()) {
    if (mode == 0 || mode == 3) {
      ConstrainedSplineInterpolator interpolator = new ConstrainedSplineInterpolator();
      splines = interpolator.interpolate(holderX, holderY);
    }
    else if (mode == 1) {
      SplineInterpolator interpolator = new SplineInterpolator();
      splines = interpolator.interpolate(holderX, holderY);
    }
    
    if (mode == 0 || mode == 1 || mode == 3) {
      beginShape();
      for (int i = (int) holderX[0]; i <= holderX[holderX.length - 1]; i++) {
        vertex(i, height - (float) splines.value(i));
      }
      endShape();
    }
    
    if (mode == 2 || mode == 3) {
      beginShape();
      for (int i = 0; i < holderX.length; i++) {
        vertex((float) holderX[i], height - (float) holderY[i]);
      }
      endShape();
    }
  }

  for (int i = 0; i < holderX.length; i++) {
    ellipse((float) holderX[i], height - (float) holderY[i], 10, 10);
  }
  
  text("Points: " + points.size(), 12, 20);
  textAlign(RIGHT, CENTER);
  text("Press \"M\" to switch draw modes", width - 12, 20);
  text("Mode: " + modeNames[mode], width - 12, 60);
  text("Press \"G\" to change grab range", width - 12, 120);
  text("Grab Range: " + (int) grabDists[grabMode], width - 12, 160);
  
  dragPoint();
  createPoint();
  dragging = false;
  clicking = false;
}

void loadPoints() {
  // Load points from the arraylist to the individual double arrays
  Collections.sort(points, compareX);
  
  holderX = new double[points.size()];
  holderY = new double[points.size()];
  for (int i = 0; i < points.size(); i++) {
    holderX[i] = points.get(i).getX();
    holderY[i] = points.get(i).getY();
  }
}

void checkForNonuniquePoints() {
  // Make a hashset to only include unique points
  HashSet<Point> holderPoints = new HashSet(points);
  points = new ArrayList(holderPoints);
}

void dragPoint() {
  for (int i = 0; i < holderX.length; i++) {
    if (dist((float) holderX[i], (float) holderY[i], mouseX, height - mouseY) < grabDists[grabMode]) {

      if (dragging) {
        points.get(i).setX(mouseX);
        points.get(i).setY(height - mouseY);
      }

      ellipse((float) holderX[i], height - (float) holderY[i], grabDists[grabMode] * 2, grabDists[grabMode] * 2);
    }
  }
}

void createPoint() {
  boolean tooClose = false;

  for (int i = 0; i < holderX.length; i++) {
    if (dist((float) holderX[i], (float) holderY[i], mouseX, height - mouseY) < grabDists[grabMode]) {
      tooClose = true;
      break;
    }
  }

  if (!tooClose && !dragging && clicking) {
    points.add(new Point(mouseX, height - mouseY));
  }
}

boolean verticalLineTest() {
  if (points.size() < 3) {
    text("TOO FEW POINTS!", 12, 60);
    return false;
  }
  
  boolean result = true;
  ArrayList<Double> usedNums = new ArrayList<Double>();

  for (double n : holderX) {
    if (usedNums.contains(n)) {
      text("NOT A FUNCTION!", 12, 60);
      result = false;
      break;
    }
    usedNums.add(n);
  }

  return result;
}

void mousePressed() {
  clicking = true;
}

void mouseDragged() {
  dragging = true;
}

void keyPressed() {
  if (keyCode == 71) {
    grabMode++;
    if (grabMode >= grabDists.length) {
      grabMode = 0;
    }
  }
  if (keyCode == 77) {
    mode++;
    if (mode >= modeNames.length) {
      mode = 0;
    }
  }
}
