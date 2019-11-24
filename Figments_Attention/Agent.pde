class Agent {
  // Not evolving traits. 
  PVector position;
  PVector velocity; PVector acceleration;
  float wandertheta; 
  
  // Weights for acccumulating forces on the agent.  
  float seperationWeight; float cohesionWeight; float alignmentWeight; 
  
  // Agent props
  color bodyColor;
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
    bodyColor = color(153, 255, 204);
    
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
  
  void run(ArrayList<Flower> flowers, ArrayList<Figment> agents, boolean shouldFlock) {
    updateGuiParameters(); 
    
    // Evaluate all the forces acting on the agents.
    behaviors(flowers, agents, shouldFlock);
    
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
    // Critical forces that determine the flocking behavior. 
    // Modify them when changing this behavior. 
    seperationWeight = seperationW; 
    cohesionWeight = cohesionW; 
    alignmentWeight = alignmentW;
  }
  
  void behaviors(ArrayList<Flower> f, ArrayList<Figment> agents, boolean shouldFlock) {
    PVector target;
    PVector steer; 
    
    // Are the agents flocking? 
    if (!shouldFlock) {
      seperationWeight = 0; 
      cohesionWeight = 0; 
      alignmentWeight = 0; 
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
     steer = seek(target, true /*Arrive*/); 
     steer.mult(foodW); 
     applyForce(steer);
    }
    
    //// Wander if nothing is found or I'm way too healthy. 
    if (target == null) {
      steer = wander(); 
      steer.mult(wanderingW);
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
  }
  
  // Did it just step on food when it was hungry? 
  void consumeFood(ArrayList<Flower> flowers) {    
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
          fl.isEaten = true; // Critical flag. 
         
          // Release particles. 
          particles.init(center);
          
          // Play a sound when food is consumed. 
          out.playNote(0, 0.1, new ToneInstrument(frequency, amp));
        }
      }
    }
  }
  
  void wraparound() {
    if (position.x < -size) position.x = width+size;
    if (position.y < -size) position.y = height+size;
    if (position.x > width+size) position.x = -size;
    if (position.y > height+size) position.y = -size;
  }
  
  void displayDebug() {
    // Debug content
    if (debug) {  
      pushStyle();
        noStroke();
        // Food perception radius.
        fill(color(255, 0, 0, 100));
        ellipse(position.x,position.y, foodPerceptionRad, foodPerceptionRad); 
        
        // Seperation perception
        fill(color(245, 195, 32, 75));
        ellipse(position.x,position.y, seperationPerceptionRad, seperationPerceptionRad); 
        
        // Alignment perception
        fill(color(198, 57, 254, 50));
        ellipse(position.x,position.y, alignmentPerceptionRad, alignmentPerceptionRad); 
              
        // Cohesion perception
        fill(color(62, 255, 27, 25));
        ellipse(position.x,position.y, cohesionPerceptionRad, cohesionPerceptionRad); 
      popStyle();
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
      if ((d > 0) && (d < seperationPerceptionRad)) {
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
      if ((d > 0) && (d < alignmentPerceptionRad)) {
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
      if ((d > 0) && (d < cohesionPerceptionRad)) {
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
    
    // Find the closest food particle.
    for (Flower fl : flowers) {
       if (fl.isThere()) {
         PVector center = new PVector(fl.position.x + fl.flowerWidth/2, fl.position.y + fl.flowerHeight/2);
         // Calculate the minimum distance to food
         float d = PVector.dist(position, center); 
         if (d < foodPerceptionRad) {
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
