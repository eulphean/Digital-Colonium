enum State {
  Hungry,
  Media,
  Mating; 
};


class Agent {
  PVector position; 
  
  PVector velocity; PVector acceleration;
  
  // Possible Genotypes.  
  float maxFoodPerceptionRad; 
  float maxMediaPerceptionRad;
  float maxSpeed;
  float maxRadius;
  float maxForce;
  
  // Health units 
  // Average of these determine the looming death of the agent. 
  // These could honestly evolve as well. This could be a genotype. 
  float bodyHealth; 
  float mediaHealth;
  
  // Current agent radius. 
  State curState;
  
  // DNA of the agent. 
  DNA dna;  
  
  // Unused. 
  float wanderTheta; 
  
  // Init the agent. 
  Agent(PVector pos, DNA _dna) {
    position = pos;
    acceleration = new PVector(0, 0); 
    velocity = new PVector(1, 1);
    
    maxFoodPerceptionRad = agentVisionRadius; 
    maxMediaPerceptionRad = agentVisionRadius;
    maxSpeed = 5.0;
    maxRadius = 8.0; // Size for the boid.
    maxForce = 0.9;
    
    bodyHealth = 200.0; 
    mediaHealth = 200.0;
    
    curState = State.Hungry; 
    
    dna = _dna; 
    //maxSpeed = map(dna.genes[0], 0, 1, 8, 1); 
    //radius = map(dna.genes[0], 0, 1, 5, 10); // Smaller the radius, more the speed. 
    wanderTheta = 0;
  }
  
  void run(Food f) {
    // Update any GUI values
    maxFoodPerceptionRad = agentVisionRadius; 
    maxMediaPerceptionRad = agentVisionRadius; 
    
    PVector target;
    // Determine the next action.
    switch (curState) {
      case Hungry: 
        // Look for closest food. 
        target = findFood(f);
        if (target != null) {
          seek(target, true /*Arrive*/); 
        }
        break; 
      
      case Media:
        target = findMedia(f); 
        if (target != null) {
         // Do something. 
         seek(target, true /*Arrive*/);
        }
        break; 
      
      default: 
        break;
    }

    // Keep updating position until reaching the target.
    update(); 
    
    // Eat food.
    eat(f); 
    
    wraparound();
    display();
  }
  
  // A method that calculates a steering force towards a target. 
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
          float m = map(d, 0, 50, 0, maxSpeed);
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

    // We could add mass here if we want A = F / M
    acceleration.add(steer);
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
    bodyHealth -= 0.5;
  }
  
  void wraparound() {
    if (position.x < -maxRadius) position.x = width+maxRadius;
    if (position.y < -maxRadius) position.y = height+maxRadius;
    if (position.x > width+maxRadius) position.x = -maxRadius;
    if (position.y > height+maxRadius) position.y = -maxRadius;
  }
  
  // Check for death
  boolean dead() {
    if (bodyHealth < 0.0) {
      return true;
    } 
    else {
      return false;
    }
  }
  
  PVector findFood(Food f) {
    // Finds the nearest food particle around it within a 
    // certain range and calculates a new velocity to go towards it.
    float minD = 5000000; // An extremely large number
    PVector target = null;
    
    // Find the closes food particle.
    for (Flower fl : f.flowers) {
       // Calculate the minimum distance to food
       float d = PVector.dist(position, fl.position); 
       if (d < maxFoodPerceptionRad) {
         if (d < minD) {
           minD = d;   
           target = fl.position; 
         }
       }
    }
    
    return target; 
  }
  
  PVector findMedia(Food f) {
   PVector target = null;
   
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
    //fill(127);
    //stroke(0);
    pushMatrix();
    translate(position.x,position.y);
    rotate(theta);
    
    color c = color(255, 255, 255);
    fill(c);
    stroke(0, bodyHealth);
    beginShape(TRIANGLES);
    vertex(0, -maxRadius*2);
    vertex(-maxRadius, maxRadius*2);
    vertex(maxRadius, maxRadius*2);
    endShape();
    popMatrix();
    
    if (turnOnVision) {
      c = color(255, 255, 255, 100); 
      fill (c); 
      ellipse(position.x, position.y, maxFoodPerceptionRad, maxFoodPerceptionRad);
    }
    popStyle();
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
  
  //void wander() {
  //  float wanderR = 25;         // Radius for our "wander circle"
  //  float wanderD = 100;         // Distance for our "wander circle"
  //  float change = 5.0;
  //  wanderTheta += random(-change,change);     // Randomly change wander theta

  //  // Now we have to calculate the new position to steer towards on the wander circle
  //  PVector circlepos = velocity.copy();    // Start with velocity
  //  circlepos.normalize();            // Normalize to get heading
  //  circlepos.mult(wanderD);          // Multiply by distance
  //  circlepos.add(position);          // Make it relative to boid's position

  //  float h = velocity.heading();        // We need to know the heading to offset wandertheta

  //  PVector circleOffSet = new PVector(wanderR*cos(wanderTheta+h),wanderR*sin(wanderTheta+h));
  //  PVector target = PVector.add(circlepos,circleOffSet);
  //  seek(target);
  //}
};
