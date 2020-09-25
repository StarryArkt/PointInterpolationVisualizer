class Point {
  double x;
  double y;
  
  Point(double _x, double _y) {
    x = _x;
    y = _y;
  }
  
  double getX() {
    return x;
  }
  
  double getY() {
    return y;
  }
  
  void setX(double _x) {
    x = _x;
  }
  
  void setY(double _y) {
    y = _y;
  }
  
  @Override
  public boolean equals(Object obj) {
    if (obj instanceof Point) {
      return ((Point) obj).getX() == getX() && ((Point) obj).getY() == getY();
    }
    return false;
  }
  
  @Override
  public int hashCode() {
    return (int) this.getX();
  }
}
