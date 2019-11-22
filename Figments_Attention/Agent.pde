class Agent {
  // Not evolving traits. 
  PVector position;
  PVector velocity; PVector acceleration;
  float wandertheta; 
  
  // Possible Genotypes.  
  float maxFoodPerceptionRad;
  float maxSeperationRad; float maxCohesionRad; float maxAlignmentRad; 
  float maxSpeed; float maxForce;
  
  // Weights for acccumulating forces on the agent.  
  float foodWeight; float seperationWeight; float wanderingWeight; float cohesionWeight; float alignmentWeight; 
  
  // Health units. 
  float maxBodyHealth; float curBodyHealth; float foodUnitHealth; float minusHealth; float flockThreshHealth; 
  
  // Agent props
  color bodyColor; float scale; 
  float size; 
  
  // Particle systems. 
  ParticleSystem particles; 
  
  // Sound system. 
  float frequency; float amp;
 
  // Trail variables. 
  int currentTrailIdx, maxTrailPoints;  
  TrailPoint[] trail;
  
  // Init the agent. 
  Agent(PVector pos, float a) {
    position = pos;
    acceleration = new PVector(0, 0); 
    velocity = new PVector(random(-5,5), random(-5, 5));
    wandertheta = 0; 
    
    size = 5.0; // Size for the boid.
    
    // Genotypes. 
    bodyColor = color(32, 32, 32);
    scale = 0.5;
    maxSeperationRad = map(scale, 0.5, 1.0, 25, 65);
    maxFoodPerceptionRad = map(scale, 0.5, 1.0, 70, 110);
    maxSpeed = 3.0;
 
    // TODO: Evolve these parameters. 
    maxForce = 0.15; 

    // Health units. Initial units. 
    maxBodyHealth = 240.0; curBodyHealth = 20; foodUnitHealth = 60; minusHealth = 0.2; 
    flockThreshHealth = 50;   
    
    // Agent's instrument. 
    // Calculate a random midi note and get its corresponding frequency.
    int randMidi = floor(random(70, 120));
    frequency = Frequency.ofMidiNote(randMidi).asHz(); 
    amp = a;
    
    // Particles 
    particles = new ParticleSystem();
    
    // Initialize trail 
    currentTrailIdx = 0; 
    maxTrailPoints = 60; // TODO: possibly in the GUI.
    trail = new TrailPoint[maxTrailPoints];
  }
  
  void run(ArrayList<Flower> flowers, ArrayList<Figment> agents) {
    updateGuiParameters(); 
    
    // Evaluate all the forces acting on the agents.
    behaviors(flowers, agents);
    
    // Remove food from canvas if agent stepped on it. 
    consumeFood(flowers); 

    // Keep updating position until reaching the target.
    update(); 
    
    // Wraparound the screen if the agent leaves. 
    wraparound();
    
    // Update particles systems if there are live particles. 
    particles.run();
    
    // Update trail
    updateTrailPoints(); 
  }
  
  void updateTrailPoints() {
   // Position is updated so I can store this. 
   trail[currentTrailIdx] = new TrailPoint(position.x, position.y, 255); 
   currentTrailIdx++; 
   currentTrailIdx %= maxTrailPoints; 
  }
 
  void updateGuiParameters() {
    // Weights Rad
    foodWeight = foodW; 
    seperationWeight = seperationW; 
    cohesionWeight = cohesionW; 
    alignmentWeight = alignmentW; 
    wanderingWeight = wanderingW;
    
    // Perception Rad
    // maxFoodPerceptionRad = foodPerceptionRad; Genotype
    // maxSeperationRad = seperationPerceptionRad; Genotype
    maxCohesionRad = cohesionPerceptionRad; // TODO: Have its own param. 
    maxAlignmentRad = alignmentPerceptionRad; // TODO: Have its own param. 
  }
  
  void behaviors(ArrayList<Flower> f, ArrayList<Figment> agents) {
    PVector target;
    PVector steer; 
    
    // Convert into a flock.
    if (curBodyHealth >= flockThreshHealth) {
     alignmentWeight = 0; 
     cohesionWeight = 0;
    }
    
    // Seperation between agents. 
    steer = seperation(agents); 
    steer.mult(seperationWeight); 
    applyForce(steer);
    
    steer = align(agents); 
    steer.mult(alignmentWeight);
    applyForce(steer); 
    
    steer = cohesion(agents);   
    steer.mult(cohesionWeight); 
    applyForce(steer); 
    
    // Food. 
    target = findFood(f);
    if (target != null) {
     float newFoodWeight = map(curBodyHealth, 0, maxBodyHealth, foodWeight, 0); 
     steer = seek(target, true /*Arrive*/); 
     steer.mult(newFoodWeight); 
     applyForce(steer);
    }
    
    //// Wander if nothing is found or I'm way too healthy or media saturated. 
    if (target == null) {
      steer = wander(); 
      steer.mult(wanderingWeight);
      applyForce(steer);
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
    
    if (curBodyHealth >= 0) {
      curBodyHealth -= minusHealth;   
    }
  }
  
  // Did it just step on food when it was hungry? 
  void consumeFood(ArrayList<Flower> flowers) {
    // Feeling pretty health. Nothing to consume. 
    if (curBodyHealth >= maxBodyHealth) {
      return;   
    }
    
    // Are we touching any food objects that are not eaten? 
    for (int i = flowers.size()-1; i >= 0; i--) {
      Flower fl = flowers.get(i);
      // Only check this flower is there. 
      if (fl.isThere()) {
        float flWidth = fl.flowerWidth; float flHeight = fl.flowerHeight; 
        PVector center = new PVector(fl.position.x + flWidth/2, fl.position.y + flHeight/2);
        float d = PVector.dist(position, center); // Distance between agent's position and flower's center.
        
        // Food is successfully consumed, do something when that happens. 
        if (d < flWidth/2) {
          curBodyHealth += foodUnitHealth;
          fl.isEaten = true; // Critical flag. 
          
          maxSeperationRad = map(scale, 0.5, 1.0, 20, 45);
          maxFoodPerceptionRad = map(scale, 0.5, 1.0, 90, 130);
          
          // Release particles. 
          particles.init(center);
          
          // Play a sound when food is consumed. 
          out.playNote(0, 0.1, new ToneInstrument(frequency, amp));
        }
      }
    }
  }
  
  // At any moment there is a teeny, tiny chance a bloop will reproduce
  Figment reproduce() {
    // asexual reproduction
    if (random(1) < 0.0001) {
      // Child is exact copy of single parent
      return new Figment(new PVector(0, 0), 0.0);
    } 
    else {
      return null;
    }
  }
  
  void wraparound() {
    if (position.x < -size) position.x = width+size;
    if (position.y < -size) position.y = height+size;
    if (position.x > width+size) position.x = -size;
    if (position.y > height+size) position.y = -size;
  }
  
  // Check for death
  boolean dead() {
   return false;
  }
  
  void displayAgent() {
    pushMatrix();
      stroke(0);
      // Draw a boid.  
      float theta = velocity.heading() + radians(90);
      translate(position.x,position.y);
      rotate(theta);
      beginShape(TRIANGLES);
      vertex(0, 0);
      vertex(-size, size*2);
      vertex(size, size*2);
      endShape();
     
     // Show health stats. 
     if (healthStats) {
        textSize(15); 
        fill(255);
        text("Body:" + nf(curBodyHealth, 0, 2), -10, 30); 
     }
    popMatrix();
    
    // Debug content. 
    displayDebug();
  }
  
  void displayDebug() {
    // Debug content
    if (debug) {     
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
    PVector circlepos = velocity.copy();    // Start with velocity
    circlepos.normalize();            // Normalize to get heading
    circlepos.mult(wanderD);          // Multiply by distance
    circlepos.add(position);               // Make it relative to boid's position

    float h = velocity.heading();        // We need to know the heading to offset wandertheta

    PVector circleOffSet = new PVector(wanderR*cos(wandertheta+h),wanderR*sin(wandertheta+h));
    PVector target = PVector.add(circlepos,circleOffSet);
    
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
 
  // Checks for nearby boids and steers away. 
  PVector seperation(ArrayList<Figment> agents) {
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
  
  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Figment> agents) {
    PVector steer = new PVector();
    int count = 0;
    for (Agent other : agents) {
      float d = PVector.dist(position,other.position);
      if ((d > 0) && (d < maxAlignmentRad)) {
        steer.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      steer.div((float)count);
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxSpeed);
      steer.sub(velocity);
      steer.limit(maxForce);
    }
    return steer;
  }

  // Cohesion
  // For the average position (i.e. center) of all nearby boids, calculate steering vector towards that position
  PVector cohesion (ArrayList<Figment> agents) {
    PVector sum = new PVector(0,0);   // Start with empty vector to accumulate all positions
    int count = 0;
    for (Agent other : agents) {
      float d = PVector.dist(position,other.position);
      if ((d > 0) && (d < maxCohesionRad)) {
        sum.add(other.position); // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      return seek(sum);  // Steer towards the position
    }
    return sum;
  }
  
  PVector findFood(ArrayList<Flower> flowers) {
    float minD = 5000000; // Helpful to calculate a local minima. 
    PVector target = null;
    
    if (curBodyHealth >= maxBodyHealth/3) {
     return null; 
    }
    
    // Find the closest food particle.
    for (Flower fl : flowers) {
       if (fl.isThere()) {
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
    }
    
    return target; 
  }
};
