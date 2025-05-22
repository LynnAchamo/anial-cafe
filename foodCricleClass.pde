class FoodCircle {
  float x, y, r;
  color c;
  boolean beingDragged = false;

  FoodCircle(float x, float y, float r, color c) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.c = c;
  }

  void update() {
    if (beingDragged) {
      x = mouseX;
      y = mouseY;
    }
  }

  void display() {
    fill(c);
    noStroke();
    ellipse(x, y, r * 2, r * 2);
  }

  boolean isMouseOver() {
    return dist(mouseX, mouseY, x, y) < r;
  }

  boolean isInCenter() {
    return dist(x, y, width / 2, height / 2) < 50;
  }
}
