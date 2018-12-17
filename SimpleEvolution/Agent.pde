class Agent {
  PVector position; 
  PVector velocity;
  PVector acceleration;
  float radius;  
  float maxSpeed;
  float maxForce;
  float maxVisionRadius; 
  
  // Life timer
  float health; 
  
  Agent(PVector pos) {
    // Initialize the agent
    acceleration = new PVector(0, 0); 
    velocity = new PVector(0, 0);
    radius = 8; 
    maxSpeed = 2; 
    maxForce = 0.1;
    health = 200; 
    
    position = pos;
  }
  
  void run(Food f) {
    // Update any GUI values
    maxVisionRadius = agentVisionRadius; 
    
    // Look for the closest food. 
    PVector target = seekFood(f);
    if (target != null) {
      arrive(target); 
    }
    update(); 
    eat(f); // Eat the food. 
    wraparound();
    display();
  }
  
  // A method that calculates a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  void arrive(PVector target) {
    PVector desired = PVector.sub(target,position);  // A vector pointing from the position to the target
    float d = desired.mag();
    // Scale with arbitrary damping within 100 pixels
    if (d < 100) {
      float m = map(d,0,100,0,maxSpeed);
      desired.setMag(m);
    } else {
      desired.setMag(maxSpeed); // Maximum speed of this bot.
    }

    // Steering Force = Desired minus Velocity
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxForce);  // Limit to maximum steering force
    applyForce(steer);
  }
  
  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }
  
  // Update position
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxSpeed);
    position.add(velocity);
    // Reset accelerationelertion to 0 each cycle
    acceleration.mult(0);
    
    // Death always looming
    health -= 0.2;
  }
  
  PVector seekFood(Food f) {
    // Finds the nearest food particle around it within a 
    // certain range and calculates a new velocity to go towards it.
    float minD = 5000000; // An extremely large number
    PVector target = null;
    
    // Find the closes food particle.
    for (PVector p : f.food) {
       // Calculate the minimum distance to food
       float d = PVector.dist(position, p); 
       if (d < maxVisionRadius) {
         if (d < minD) {
           minD = d;   
           target = p; 
         }
       }
    }
    
    return target; 
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
    
    c = color(0, 0, 255, 50); 
    fill (c); 
    ellipse(position.x, position.y, maxVisionRadius, maxVisionRadius);
    popStyle();
  }
};
