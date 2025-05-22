PImage background_image;
int foodCost = 3;
int money = 5;
int spawnTimer = 0;
String[] names = {"Alice", "Bob", "Coco", "Daisy", "Eddie"};
ArrayList<Customer> customers = new ArrayList<Customer>();

void setup(){
  load_background_image();
  size(1000, 800);
  
  customers.add(new Customer(randomName(), height / 2));
  
  float padding = circleRadius + 10; // ensures full fit inside square


  circleSpots = new PVector[] {
    new PVector(displayX + padding, displayY + padding),                                        
    new PVector(displayX + displaySize - padding, displayY + padding),                          
    new PVector(displayX + padding, displayY + displaySize - padding),                          
    new PVector(displayX + displaySize - padding, displayY + displaySize - padding)
  };
  
  for (int i = 0; i < 4; i++) {
    circles.add(new FoodCircle(circleSpots[i].x, circleSpots[i].y, circleRadius, colors[i]));
  }
  textSize(16);
  textAlign(CENTER, CENTER);

  circleSpots = new PVector[] {
    new PVector(displayX + padding, displayY + padding),
    new PVector(displayX + displaySize - padding, displayY + padding),
    new PVector(displayX + padding, displayY + displaySize - padding),
    new PVector(displayX + displaySize - padding, displayY + displaySize - padding)
  };

  for (int i = 0; i < 4; i++) {
    circles.add(new FoodCircle(circleSpots[i].x, circleSpots[i].y, circleRadius, colors[i]));
  }

}


void draw(){
  image(background_image, 0,0);

  fill(224, 214, 175);
  rect(0,0,350,75);
  fill(0);
  textSize(30);
  text("money: $" + money, 30, 30);
  text("drag food to animal(+$" + foodCost +")", 20, 60);

//Draw food display box
  stroke(0);
  fill(200);
  rect(displayX, displayY, displaySize, displaySize, 10);

  for (FoodCircle fc : circles) {
    fc.update();
    fc.display();
  }

  for (int i = circles.size() - 1; i >= 0; i--) {
    FoodCircle fc = circles.get(i);
    if (fc.beingDragged && fc.isInCenter()) {
      circles.remove(i);
    }
  }

  // --- CUSTOMER STATE MANAGEMENT ---
  int orderingIndex = -1;
  for (int i = 0; i < customers.size(); i++) {
    if (customers.get(i).state.equals("ordering")) {
      orderingIndex = i;
      break;
    }
  }

  // Arrange waiting line positions
  int waitCount = 0;
  for (Customer c : customers) {
    if (c.state.equals("waiting")) {
      c.targetX = 100 + waitCount * 60; // Left line
      waitCount++;
    } else if (c.state.equals("ordering")) {
      c.targetX = width / 2 - 25; // Center
    } else if (c.state.equals("eating")) {
      c.targetX = width - 200; // Eating area (right)
    }
  }

  // Only one customer can be "ordering"
  if (orderingIndex == -1) {
    // Find first eligible waiting customer
    for (Customer c : customers) {
      if (c.state.equals("waiting") && c.stateTimer > 120) {
        c.state = "ordering";
        c.stateTimer = 0;
        break;
      }
    }
  }

  // Update and draw customers
  for (Customer c : customers) {
    c.update();        // Handles movement (move towards targetX)
    c.display();
    c.stateTimer++;
  }
  
  // Check for correct drop
  if (draggingCircle != null) {
    for (Customer c : customers) {
      if (c.state.equals("waiting") && c.isPlaceholderHovered(draggingCircle.x, draggingCircle.y)) {
        if (c.receiveFood(draggingCircle.c)) {
          money += foodCost; // Reward for correct food
          circles.remove(draggingCircle); // Remove food after delivery
          draggingCircle = null;
          break; // Exit loop once food is successfully given
        }
      }
    }
  }

  boolean someoneIsWaiting = customers.stream().anyMatch(c -> c.state.equals("waiting"));

  spawnTimer++;
  if (spawnTimer > 120 && !someoneIsWaiting) {
    customers.add(new Customer(randomName(), height / 2));
    spawnTimer = 0;
  }
}

void mousePressed() {
  for (int i = circles.size() - 1; i >= 0; i--) {
    FoodCircle fc = circles.get(i);
    if (fc.isMouseOver()) {
      fc.beingDragged = true;
      draggingCircle = fc;

      for (int j = 0; j < 4; j++) {
        if (dist(fc.x, fc.y, circleSpots[j].x, circleSpots[j].y) < 5) {
          circles.add(new FoodCircle(circleSpots[j].x, circleSpots[j].y, circleRadius, colors[j]));
          break;
        }
      }

      break;
    }
  }
}


void mouseReleased() {
  if (draggingCircle != null) {
    draggingCircle.beingDragged = false;
    draggingCircle = null;
  }
  sellCoffee();
} 



void sellCoffee(){
  money += foodCost;//adds 3 everytime s it pressed
}
void load_background_image(){
  background_image = loadImage("background for animal cafe.png");
  //inserts background image
  
  background_image.resize(1000,800);
    //resizes background image
    
    image(background_image, 0,0);
}


String randomName() {
  return names[int(random(names.length))];
}
