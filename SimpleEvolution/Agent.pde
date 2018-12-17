class Agent {
  PVector position; 
  int radius = 8;  
  float xoff; float yoff; // For perlin noise
  float maxSpeed = 1; 
  
  // Ecosystem traits. 
  float health;  // Life timer
  
  Agent(PVector pos) {
    position = pos;
    xoff = random(1000);
    yoff = random(1000);
    health = 200; 
  }
  
  void run() {
    update(); 
    wraparound();
    display();
  }
  
  void update() {
    // Simple movement based on perlin noise
    // TODO: Make this more deterministic so the 
    // agents are actually moving towards food. 
    float vx = map(noise(xoff),0,1,-maxSpeed,maxSpeed);
    float vy = map(noise(yoff),0,1,-maxSpeed,maxSpeed);
    PVector velocity = new PVector(vx,vy);
    xoff += 0.01;
    yoff += 0.01;

    position.add(velocity);
    // Death always looming
    health -= 0.2;
  }
  
  void wraparound() {
    if (position.x < -radius) position.x = width+radius;
    if (position.y < -radius) position.y = height+radius;
    if (position.x > width+radius) position.x = -radius;
    if (position.y > height+radius) position.y = -radius;
  }
  
  // Agent prying on food. 
  void eat(Food f) {
    ArrayList<PVector> food = f.getFood();
    // Are we touching any food objects?
    for (int i = food.size()-1; i >= 0; i--) {
      PVector foodCenter = new PVector(food.get(i).x, food.get(i).y);
      
      // Get the center of the food block. 
      foodCenter.x += f.foodWidth/2;
      foodCenter.y += f.foodHeight/2; 
      // Distance between circle and food block's center
      float d = PVector.dist(position, foodCenter);
      // If we are, juice up our strength!
      if (d < radius + f.foodWidth/2) {
        health += 100; 
        food.remove(i);
        
        if (random(1) < 0.005) {
          f.grow(); 
        }
      }
    }
  }

  // At any moment there is a teeny, tiny chance a bloop will reproduce
  Agent reproduce() {
    // asexual reproduction
    if (random(1) < 0.0001) {
      // Child is exact copy of single parent
      return new Agent(new PVector(random(width), random(height)));
    } 
    else {
      return null;
    }
  }
  
  // Check for death
  boolean dead() {
    if (health < 0.0) {
      return true;
    } 
    else {
      return false;
    }
  }
  
  void display() {
    pushStyle();
    // See the deteriorating health
    color c  = color(255, 0, 0, health);
    fill(c); 
    stroke(0, health);
    ellipse(position.x, position.y, radius, radius); 
    popStyle();
  }
};