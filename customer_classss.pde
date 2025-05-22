class Customer {
  String name;
  float x, y;
  float targetX;
  String state;
  int stateTimer;

  boolean waiting = false;
  boolean leaving = false;
  boolean thoughtBubbleVisible = false;
  color orderColor;

  Customer(String name, float startY) {
    this.name = name;
    this.x = -50;
    this.y = startY;
    this.targetX = width / 2 - 25;
    this.state = "arriving";
    this.stateTimer = 0;
    randomizeOrder();
  }

  void randomizeOrder() {
    color[] possibleColors = {
      color(255, 0, 0),   // red
      color(0, 100, 255), // blue
      color(139, 69, 19), // brown
      color(255, 165, 0)  // orange
    };
    orderColor = possibleColors[int(random(possibleColors.length))];
  }

void stateTransitions() {
  stateTimer++;

  if (state.equals("arriving") && abs(x - targetX) < 2) {
    state = "waiting";
    waiting = true;
    thoughtBubbleVisible = true;
    stateTimer = 0;
  }
  else if (state.equals("eating") && stateTimer > 180) {
    state = "exiting";
    leaving = true;
  }
}
void update() {
  stateTransitions();
  // Move smoothly to targetX
  if (!state.equals("exiting")) {
    x += (targetX - x) * 0.1;
  } else {
    x += 3;
  }
}
  
  boolean receiveFood(color givenColor) {
    if (state.equals("waiting") && colorsMatch(givenColor, orderColor)) {
      thoughtBubbleVisible = false;
      waiting = false;
      state = "eating";  // State changes to eating
      stateTimer = 0;    // Reset timer for eating state
      return true;       // Food was correctly received
    }
    return false;        // Incorrect food or not in the correct state
  }

  void display() {
    fill(150, 200, 250);
    rect(x, y, 50, 50, 10);

    fill(0);
    textAlign(CENTER);
    text(name.charAt(0), x + 25, y + 30);

    fill(0);
    textAlign(LEFT);
    text(state, x + 60, y + 15);

    if (thoughtBubbleVisible) {
      drawThoughtBubble();
    }
  }

  void drawThoughtBubble() {
    float bubbleX = x + 25;
    float bubbleY = y - 100;

    fill(255);
    stroke(0);
    strokeWeight(2);
    beginShape();
    vertex(bubbleX - 60, bubbleY);
    bezierVertex(bubbleX - 90, bubbleY - 40, bubbleX + 90, bubbleY - 40, bubbleX + 60, bubbleY);
    bezierVertex(bubbleX + 90, bubbleY + 40, bubbleX - 90, bubbleY + 40, bubbleX - 60, bubbleY);
    endShape(CLOSE);

    ellipse(bubbleX - 20, bubbleY + 50, 20, 20);
    ellipse(bubbleX - 35, bubbleY + 65, 12, 12);

    fill(orderColor);
    noStroke();
    rect(bubbleX - 15, bubbleY - 15, 30, 30, 5);
  }

  boolean isPlaceholderHovered(float fx, float fy) {
    float bubbleX = x + 25;
    float bubbleY = y - 100;
    return fx > bubbleX - 15 && fx < bubbleX + 15 && fy > bubbleY - 15 && fy < bubbleY + 15;
  }

  boolean colorsMatch(color c1, color c2) {
    return abs(red(c1) - red(c2)) < 5 &&
           abs(green(c1) - green(c2)) < 5 &&
           abs(blue(c1) - blue(c2)) < 5;
  }
}

// --- Global Setup ---
ArrayList<FoodCircle> circles = new ArrayList<FoodCircle>();
FoodCircle draggingCircle = null;

float displayX = 100, displayY = 350;
float displaySize = 220;
float circleRadius = 45;

PVector[] circleSpots;
color[] colors = {
  color(0, 100, 255),  // blue
  color(139, 69, 19),  // brown
  color(255, 0, 0),    // red
  color(255, 165, 0)   // orange
};
