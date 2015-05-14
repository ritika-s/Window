class Snowflake {
  PVector location;
  PVector acceleration;
  PVector velocity;
  PVector wind;
  PVector gravity;
 
  float snowHeight, snowWidth;
  float mass;
 
  boolean death = false;
 
  Snowflake() {
    snowHeight = 15;
    snowWidth  = snowHeight;
 
    //location   = new PVector(random(z), -1000, random(-z, z)); //Only for 3D
    location = new PVector(random(width), -snowHeight);
    velocity   = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    wind = new PVector(random(-0.004, 0.004), 0);
 
    mass = 100/snowWidth;
    gravity = new PVector(0, 0.05);
  }
 
  void display() {
    drawSnow();
    moveSnow();
    applyForce(gravity);
    applyForce(wind);
  }
 
  void drawSnow() {
    noStroke();
    fill(255, 200);
    ellipse(location.x, location.y, snowWidth, snowHeight);
    
  }
 
  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }
 
  void moveSnow() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
    //if (location.y > 1000+snowHeight) { //Only for 3D
    if (location.y > height+snowHeight) {
      death = true;
    }
  }
}

