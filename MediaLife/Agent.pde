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
  
  // Init the agent. 
  Agent(PVector pos, DNA _dna) {
    position = pos;
    acceleration = new PVector(0, 0); 
    velocity = new PVector(random(-1, 1), random(-1, 1));
    
    maxFoodPerceptionRad = agentVisionRadius; 
    maxMediaPerceptionRad = agentVisionRadius;
    maxSpeed = 5.0;
    maxRadius = 8.0; // Size for the boid.
    maxForce = 0.1;
    
    bodyHealth = 200.0; 
    mediaHealth = 200.0;
    
    curState = State.Hungry; 
    
    dna = _dna; 
    //maxSpeed = map(dna.genes[0], 0, 1, 8, 1); 
    //radius = map(dna.genes[0], 0, 1, 5, 10); // Smaller the radius, more the speed. 
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

        consumeFood(f); 
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
    
    wraparound();
    display();
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
    float minD = 5000000; // Helpful to calculate a local minima. 
    PVector target = null;
    
    // Find the closes food particle.
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
    PVector target = null;
    
    for (PixelBrick brick : f.bricks) {
       // Calculate the distance to all the points. 
       int brickW = brick.pixWidth*brick.cols; int brickH = brick.pixWidth*brick.rows; 
       
       PVector brickPoint;
       float d;
       // Top and Bottom rows.
       for (int i = 0; i < brickW; i+=4) {
         // Top row.
         brickPoint = new PVector(brick.position.x + i, brick.position.y); 
         d = PVector.dist(position, brickPoint); 
         if (d < maxMediaPerceptionRad) {
           if (d < minD) {
             minD = d;   
             target = brickPoint; 
           }
         }
         
         // Bottom row.
         brickPoint = new PVector(brick.position.x + i, brick.position.y + brickH); 
         d = PVector.dist(position, brickPoint); 
         if (d < maxMediaPerceptionRad) {
           if (d < minD) {
             minD = d;   
             target = brickPoint; 
           }
         }
       }
       
       // Left and right columns.
       for (int i = 0; i < brickH; i+=4) {
         // Left column.
         brickPoint = new PVector(brick.position.x, brick.position.y + i); 
         d = PVector.dist(position, brickPoint); 
         if (d < maxMediaPerceptionRad) {
           if (d < minD) {
             minD = d;   
             target = brickPoint; 
           }
         }
         
         // Right column.
         brickPoint = new PVector(brick.position.x + brickW, brick.position.y + i); 
         d = PVector.dist(position, brickPoint); 
         if (d < maxMediaPerceptionRad) {
           if (d < minD) {
             minD = d;   
             target = brickPoint; 
           }
         }
       }
      
    }
    
    return target; 
  }
  
  // Did it just step on food when it was hungry? 
  void consumeFood(Food f) {
    ArrayList<Flower> flowers = f.flowers;
    // Are we touching any food objects?
    for (int i = flowers.size()-1; i >= 0; i--) {
      Flower fl = flowers.get(i);
      float flWidth = fl.flowerWidth; float flHeight = fl.flowerHeight; 
      PVector center = new PVector(fl.position.x + flWidth/2, fl.position.y + flHeight/2);
      float d = PVector.dist(position, center); // Distance between agent's position and flower's center.
      if (d < maxRadius) {
        bodyHealth += 100; 
        flowers.remove(i);
      }
    }
  }
  
  void display() {
    pushMatrix();
     pushStyle();
      // Triangle. 
      float theta = velocity.heading() + radians(90);
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
      
      // Vision circle.
      if (turnOnVision) {
        c = color(255, 255, 255, 100); 
        fill(c);
        ellipse(0,0,maxFoodPerceptionRad, maxFoodPerceptionRad); 
      }
      
      // Position marker. 
      fill(0, 255, 0);
      ellipse(0, 0, 3, 3); 
     popStyle();
    popMatrix();
  }
  
  // -------------------------------------------- Steering Behaviors -------------------------------------------
  
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
  
  // Separation
  // Method checks for nearby boids and steers away
  void seperate (ArrayList<Agent> agents) {
    float desiredseparation = maxRadius*2;
    PVector sum = new PVector();
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Agent other : agents) {
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than desired distance. 
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        sum.add(diff);
        count++;            // Keep track of how many
      }
    }
    
    // Average -- divide by how many
    if (count > 0) {
      // Our desired vector is moving away maximum speed
      sum.setMag(maxSpeed);
      // Implement Reynolds: Steering = Desired - Velocity
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxForce);
      // Apply force. 
      acceleration.add(steer);
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
};
