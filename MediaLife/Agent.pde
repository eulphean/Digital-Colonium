class Agent {
  PVector position; 
  PVector velocity;
  PVector acceleration;
  
  float maxForce;
  float maxVisionRadius; 
  float wanderTheta; 
  
  // DNA of the agent. 
  DNA dna; 
  float radius; 
  float maxSpeed;
  
  // Life timer
  float health; 
  
  // Modify the constructor to pass DNA. 
  Agent(PVector pos, DNA _dna) {
    // Initialize the agent
    acceleration = new PVector(0, 0); 
    velocity = new PVector(0, 0);
    maxForce = 0.2;
    wanderTheta = 0; 
    health = 200; 
    
    position = pos;
    
    // Pass in the dna. 
    dna = _dna; 
    maxSpeed = map(dna.genes[0], 0, 1, 8, 1); 
    radius = map(dna.genes[0], 0, 1, 5, 10); // Smaller the radius, more the speed. 
  }
  
  void run(Food f) {
    // Update any GUI values
    maxVisionRadius = agentVisionRadius; 
    
    // Look for the closest food. 
    PVector target = seekFood(f);
    if (target != null) {
      seek(target, true); 
    } else {
      // Wander around to look for food. 
      wander();
    }
    update(); 
    eat(f); // Eat the food. 
    wraparound();
    display();
  }
  
  void wander() {
    float wanderR = 25;         // Radius for our "wander circle"
    float wanderD = 100;         // Distance for our "wander circle"
    float change = 5.0;
    wanderTheta += random(-change,change);     // Randomly change wander theta

    // Now we have to calculate the new position to steer towards on the wander circle
    PVector circlepos = velocity.copy();    // Start with velocity
    circlepos.normalize();            // Normalize to get heading
    circlepos.mult(wanderD);          // Multiply by distance
    circlepos.add(position);          // Make it relative to boid's position

    float h = velocity.heading();        // We need to know the heading to offset wandertheta

    PVector circleOffSet = new PVector(wanderR*cos(wanderTheta+h),wanderR*sin(wanderTheta+h));
    PVector target = PVector.add(circlepos,circleOffSet);
    seek(target);
  }
  
  // A method that calculates a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  void seek(PVector target) {
     seek(target, false); 
  }
  
  void seek(PVector target, boolean arrive) {
    PVector desired = PVector.sub(target,position);  // A vector pointing from the position to the target
    
    // Slow down when coming towards the target
    if (arrive) {
       float d = desired.mag(); 
       if (d < 50) {
          float m = map(d, 0, 100, 0, maxSpeed);
          desired.setMag(m);
       } else {
          desired.setMag(maxSpeed); 
       }
    } else {
      // Normalize desired and scale to maximum speed
      desired.normalize();
      desired.mult(maxSpeed);
    }
    
    // Steering = Desired minus Velocity
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
    health -= 0.5;
  }
  
  void wraparound() {
    if (position.x < -radius) position.x = width+radius;
    if (position.y < -radius) position.y = height+radius;
    if (position.x > width+radius) position.x = -radius;
    if (position.y > height+radius) position.y = -radius;
  }

  // At any moment there is a teeny, tiny chance a bloop will reproduce
  Agent reproduce() {
    // asexual reproduction
    if (random(1) < 0.001) {
      // Child is exact copy of this single parent. 
      DNA childDNA = dna.copy();
      // Child DNA can mutate
      childDNA.mutate(0.01);
      // Child is exact copy of single parent
      return new Agent(new PVector(random(width), random(height)), childDNA);
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
  
  PVector seekFood(Food f) {
    // Finds the nearest food particle around it within a 
    // certain range and calculates a new velocity to go towards it.
    float minD = 5000000; // An extremely large number
    PVector target = null;
    
    //// Find the closes food particle.
    //for (PVector p : f.food) {
    //   // Calculate the minimum distance to food
    //   float d = PVector.dist(position, p); 
    //   if (d < maxVisionRadius) {
    //     if (d < minD) {
    //       minD = d;   
    //       target = p; 
    //     }
    //   }
    //}
    
    return target; 
  }
  
    // Agent prying on food. 
  void eat(Food f) {
    //ArrayList<PVector> food = f.getFood();
    //// Are we touching any food objects?
    //for (int i = food.size()-1; i >= 0; i--) {
    //  PVector foodCenter = new PVector(food.get(i).x, food.get(i).y);
      
    //  // Get the center of the food block. 
    //  foodCenter.x += f.foodWidth/2;
    //  foodCenter.y += f.foodHeight/2; 
    //  // Distance between circle and food block's center
    //  float d = PVector.dist(position, foodCenter);
    //  // If we are, juice up our strength!
    //  if (d < radius + f.foodWidth/2) {
    //    health += 100; 
    //    food.remove(i);
    //    //f.grow();
        
    //    if (random(1) <= 0.5) {
    //      //f.grow(); 
    //    }
    //  }
    //}
  }
  
  void display() {
    pushStyle();
    
    float theta = velocity.heading() + radians(90);
    fill(127);
    stroke(0);
    pushMatrix();
    translate(position.x,position.y);
    rotate(theta);
    
    color c = color(255, 255, 255, health);
    fill(c);
    stroke(0, health);
    beginShape(TRIANGLES);
    vertex(0, -radius*2);
    vertex(-radius, radius*2);
    vertex(radius, radius*2);
    endShape();
    popMatrix();
    
    if (turnOnVision) {
      c = color(255, 255, 255, 100); 
      fill (c); 
      ellipse(position.x, position.y, maxVisionRadius, maxVisionRadius);
    }
    popStyle();
  }
};
