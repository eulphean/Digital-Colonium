class Agent {
  // Not evolving traits. 
  PVector position; PVector ahead; 
  PVector velocity; PVector acceleration;
  float wandertheta; 
  
  // Possible Genotypes.  
  float maxFoodPerceptionRad; float maxSeperationRad; float maxRadius; float maxMediaPerceptionRad; 
  float maxSpeed; float maxForce; float maxAheadDistance;
  
  // Weights for acccumulating forces on the agent.  
  float foodWeight; float seperationWeight; float mediaAttractionWeight; float mediaAvoidanceWeight; float wanderingWeight;
  
  // Health units: Average of these determine the looming death of the agent. 
  // These could honestly evolve as well. This could be a genotype (maxBodyHealth and maxMediaHealth)
  float maxBodyHealth; float curBodyHealth; 
  float maxMediaHealth; float curMediaHealth;
  
  // Local flags.
  boolean isConsumingMedia = false; 
  color bodyColor; 
  
  // DNA of the agent. 
  DNA dna;   
  
  // Init the agent. 
  Agent(PVector pos, DNA _dna) {
    position = pos;
    acceleration = new PVector(0, 0); 
    velocity = new PVector(random(-1,1), random(-1, 1));
    wandertheta = 0; 
    ahead = position.copy().add(velocity.copy().normalize().mult(maxAheadDistance));
    
    maxFoodPerceptionRad = foodPerceptionRad; 
    maxMediaPerceptionRad = 100; 
    maxSpeed = 2.0;
    maxRadius = 8.0; // Size for the boid.
    maxSeperationRad = maxRadius*5;
    
    // TODO: Evolve these parameters. 
    maxForce = 0.1; 
    maxAheadDistance = 30.0;
    
    // Weights for the forces acting on the agent.  
    setWeight();
    
    // Health units. Initial units. 
    maxBodyHealth = 200.0; curBodyHealth = 200.0;
    maxMediaHealth = 100.0; curMediaHealth = 0.0; 
    
    dna = _dna; 
  }
  
  void run(Food f, ArrayList<Agent> agents) {
    // Update any GUI values.
    maxFoodPerceptionRad = foodPerceptionRad; 
    
    // Evaluate all the forces acting on the agents.
    behaviors(f, agents);
    
    // Remove food from canvas if agent stepped on it. 
    consumeFood(f); 
    
    // Check if the agent is inside a media brick. 
    consumeMedia(f);

    // Keep updating position until reaching the target.
    update(); 
    
    // Wraparound the screen if the agent leaves.
    // TODO: Use boundaries and contain the system or maybe not. 
    wraparound();
    
    // Show the agent. 
    display();
  }
  
  void setWeight() {
    // Definitely evolve these weights. 
    foodWeight = 2.0; 
    seperationWeight = 0.5; 
    mediaAttractionWeight = 0.5; 
    mediaAvoidanceWeight = 0.3;
    wanderingWeight = 0.5;
  }
  
  void behaviors(Food f, ArrayList<Agent> agents) {
    PVector target;
    PVector steer; 
    
    // Seperation between agents. 
    steer = seperation(agents); 
    steer.mult(seperationWeight); 
    applyForce(steer);
    
    // Food. 
    target = findFood(f);
    if (target != null) {
     float newFoodWeight = map(curBodyHealth, -maxBodyHealth, maxBodyHealth, foodWeight, 0.5); 
     steer = seek(target, true /*Arrive*/); 
     steer.mult(newFoodWeight); 
     applyForce(steer);
    }

    // Media attraction.
    // TODO: This is acting really funny right now. 
    target = findMedia(f); 
    if (target != null) {
     float newMediaWeight = map(curMediaHealth, -maxMediaHealth, maxMediaHealth, mediaAttractionWeight, -mediaAvoidanceWeight);
     steer = seek(target, true);
     steer.mult(newMediaWeight); 
     applyForce(steer);
    }
    
    // Wander if nothing is found. g 
    // Wander around (Reset maxSpeed to get desired results)
    if (target == null || curMediaHealth >= maxMediaHealth || curBodyHealth >= maxBodyHealth) {
      float oldMaxSpeed = maxSpeed; 
      //maxSpeed = 1.0;
      steer = wander(); 
      steer.mult(wanderingWeight);
      applyForce(steer);
      //maxSpeed = oldMaxSpeed; 
    }
  }
  
  void applyForce(PVector force) {
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
    
    // Update ahead vector position. 
    ahead = position.copy().add(velocity.copy().normalize().mult(maxAheadDistance));
    
    if (curBodyHealth >= -maxBodyHealth) {
      curBodyHealth -= 0.1;   
    }
    
    if (curMediaHealth >= -maxMediaHealth) {
      curMediaHealth -= 0.1;  
    }
  }
  
  // Is it in the vicinity of the media brick that it's actually 
  // consuming media. 
  void consumeMedia(Food f) {
    ArrayList<PixelBrick> bricks = f.bricks;  
    
    for (PixelBrick pb: bricks) {
      float d = PVector.dist(pb.center, position); 
      if (d < pb.getCircleRad()) {
        isConsumingMedia = true; 
        if (curMediaHealth <= maxMediaHealth) {
          curMediaHealth += 0.5; // Half-unit/frame 
        }
        return; 
      }
    }
    
    isConsumingMedia = false;
  }
  
  // Did it just step on food when it was hungry? 
  void consumeFood(Food f) {
    // Feeling pretty health. Nothing to consume. 
    if (curBodyHealth >= maxBodyHealth) {
      return;   
    }
    
    ArrayList<Flower> flowers = f.flowers;
    // Are we touching any food objects?
    for (int i = flowers.size()-1; i >= 0; i--) {
      Flower fl = flowers.get(i);
      float flWidth = fl.flowerWidth; float flHeight = fl.flowerHeight; 
      PVector center = new PVector(fl.position.x + flWidth/2, fl.position.y + flHeight/2);
      float d = PVector.dist(position, center); // Distance between agent's position and flower's center.
      if (d < flWidth/2) {
        curBodyHealth += 20; // 20 units/flower 
        flowers.remove(i);
        // Chance to create a new flower when one is created. 
        if (random(1) < 0.90) {
         f.createFlowers(1); 
        } 
      }
    }
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
  
  void wraparound() {
    if (position.x < -maxRadius) position.x = width+maxRadius;
    if (position.y < -maxRadius) position.y = height+maxRadius;
    if (position.x > width+maxRadius) position.x = -maxRadius;
    if (position.y > height+maxRadius) position.y = -maxRadius;
  }
  
  // Check for death
  boolean dead() {
   float netHealth = curBodyHealth + curMediaHealth; 
   return netHealth < 0.0; 
  }
  
  void display() {
    pushMatrix();
     pushStyle();
      stroke(0);
      // Draw a boid.  
      float theta = velocity.heading() + radians(90);
      translate(position.x,position.y);
      rotate(theta);
      bodyColor = isConsumingMedia ? color(255, 0, 0) : color(255);
      fill(bodyColor);
      beginShape(TRIANGLES);
      vertex(0, -maxRadius*2);
      vertex(-maxRadius, maxRadius*2);
      vertex(maxRadius, maxRadius*2);
      endShape();
     popStyle();
     
     // Show health stats. 
     if (healthStats) {
       pushStyle(); 
        textSize(15); 
        fill(255); 
        text("Body:" + nf(curBodyHealth, 0, 2), -10, 30); 
        text("Media:" + nf(curMediaHealth, 0, 2), -10, 45);
       popStyle();
     }
    popMatrix();
    
    // Debug content. 
    displayDebug();
  }
  
  void displayDebug() {
    // Debug content
    if (debug) {
      pushStyle();
      stroke(255);
      strokeWeight(3);
      line(position.x, position.y, ahead.x, ahead.y);
      popStyle();
     
      // Position marker. 
      fill(0, 255, 0);
      ellipse(position.x, position.y, 3, 3);
    }
    
    // Vision circle.
    if (turnOnVision) {
      // Food perception radius.
      fill(color(0, 255, 0, 50));
      ellipse(position.x,position.y,maxFoodPerceptionRad, maxFoodPerceptionRad); 
      
      // Seperation radius
      fill(color(255, 0, 0, 50));
      ellipse(position.x,position.y,maxSeperationRad,maxSeperationRad); 
      
      // Media perception radius. 
      fill(color(255, 255, 0, 50)); 
      ellipse(position.x, position.y, maxMediaPerceptionRad, maxMediaPerceptionRad);
    }
  }
  
  // A method just to draw the circle associated with wandering
  void drawWanderStuff(PVector position, PVector circle, PVector target, float rad) {
    stroke(255);
    noFill();
    ellipseMode(CENTER);
    ellipse(circle.x,circle.y,rad*2,rad*2);
    ellipse(target.x,target.y,4,4);
    line(position.x,position.y,circle.x,circle.y);
    line(circle.x,circle.y,target.x,target.y);
  }
  
  // -------------------------------------------- Steering Behaviors -------------------------------------------
  
  PVector wander() {
    float wanderR = 50;         // Radius for our "wander circle"
    float wanderD = 60;         // Distance for our "wander circle"
    float change = 0.5;
    wandertheta += random(-change,change);     // Randomly change wander theta

    // Now we have to calculate the new position to steer towards on the wander circle
    PVector circlepos = velocity.get();    // Start with velocity
    circlepos.normalize();            // Normalize to get heading
    circlepos.mult(wanderD);          // Multiply by distance
    circlepos.add(position);               // Make it relative to boid's position

    float h = velocity.heading2D();        // We need to know the heading to offset wandertheta

    PVector circleOffSet = new PVector(wanderR*cos(wandertheta+h),wanderR*sin(wandertheta+h));
    PVector target = PVector.add(circlepos,circleOffSet);
    
    // Render wandering circle, etc.
    //drawWanderStuff(position,circlepos,target,wanderR);
    return seek(target);
  }
  // Calculates a steering force towards a target. 
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
     return seek(target, false); 
  }
  
  PVector seek(PVector target, boolean arrive) {
    PVector desired = PVector.sub(target,position);  // A vector pointing from the position to the target
    
    // Slow down when coming towards the target
    if (arrive) {
       float d = desired.mag(); 
       if (d < 100) {
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
    
    return steer; 
  }
  
  // Obstacle avoidance. 
  PVector avoidMedia(Food f) {
    PVector steer = new PVector(0, 0);
    for (PixelBrick pb : f.bricks) {
      float desiredSeperation = pb.getCircleRad() + maxRadius;
      
      if (PVector.dist(ahead, pb.center) < desiredSeperation) {
        // Obstacle ahead. Steer to avoid this obstacle. 
        PVector desired = PVector.sub(ahead, pb.center); 
        desired.normalize(); 
        desired.limit(maxSpeed); 
        steer = PVector.sub(desired, velocity); 
        steer.limit(maxForce); 
      }
    }
    return steer; 
  }
 
  
  // Checks for nearby boids and steers away. 
  PVector seperation(ArrayList<Agent> agents) {
    PVector sum, steer; 
    sum = steer = new PVector();
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Agent other : agents) {
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than desired distance. 
      if ((d > 0) && (d < maxSeperationRad)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);
        sum.add(diff);
        count++;
      }
    }
    
    if (count > 0) {
      sum.setMag(maxSpeed);
      steer = PVector.sub(sum, velocity);
      steer.limit(maxForce);
    }
    
    return steer;
  }
  
  PVector findFood(Food f) {
    float minD = 5000000; // Helpful to calculate a local minima. 
    PVector target = null;
    
    if (curBodyHealth >= maxBodyHealth) {
     return null; 
    }
    
    // Find the closest food particle.
    for (Flower fl : f.flowers) {
       PVector center = new PVector(fl.position.x + fl.flowerWidth/2, fl.position.y + fl.flowerHeight/2);
       // Calculate the minimum distance to food
       float d = PVector.dist(position, center); 
       if (d < maxFoodPerceptionRad) {
         if (d < minD) {
           minD = d;   
           target = center; 
         }
       }
    }
    
    return target; 
  }
  
  PVector findMedia(Food f) {
    float minD = 5000000; // Helpful to calculate a local minima. 
    PVector target=null;
    
    for (PixelBrick pb : f.bricks) {
     // Find the closest food particle.
     // Calculate the minimum distance to food
     float d = PVector.dist(position, pb.center); 
     if (d < maxMediaPerceptionRad) {
       if (d < minD) {
         minD = d;   
         target = pb.center; 
       }
     }
    }
    
    return target; 
  }
};
