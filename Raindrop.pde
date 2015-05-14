
class Raindrop {
  float x,y;   // Variables for location of raindrop
  float speed; // Speed of raindrop
  color c;
  float r;     // Radius of raindrop

  Raindrop() {
    r = 8;                 // All raindrops are the same size
    x = random(width);     // Start with a random x location
    y = -r*4;              // Start a little above the window
    speed = random(1,5);   // Pick a speed from weather
    c = color(50,100,150); // Color
  }

  // Move the raindrop down
  void move() {
    // Increment by speed
    y += speed; 
  }

  // Check if it hits the bottom
  boolean reachedBottom() {
    // If we go beyond the bottom
    if (y > height + r*4) { 
      return true;
    } else {
      return false;
    }
  }

  // Display the raindrop
  void display() {
    // Display the drop
    fill(c);
    noStroke();
    for (int i = 2; i < r; i++ ) {
      ellipse(x,y + i*4,i*2,i*2);
    }
  }

}
