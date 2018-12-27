class Organism {
  // Organism
  float scale; 
  
  // Head 
  PVector headCenter;
  float headRadius; 
  
  // Antenna properties. 
  // [NOTE] Could evolve certainly. 
  IntList antIndices; 
  ArrayList<PVector> antEdges; 
  int maxAngle; int minAngle; 
  int antennaOffset; 
  int maxAntennas; 
  int minLength; int maxLength;
  
  // Body
  float bodyHeight; float bodyWidth;
  ArrayList<PVector> spots; int numSpots;
  
  Organism(PVector pos, float s, int numAntennas, int radius, int bh) {
    // Antenna head properties. 
    antIndices = new IntList(); 
    antEdges = new ArrayList();
    minAngle = 160; maxAngle = 390; 
    antennaOffset = 10; 
    maxAntennas = (maxAngle-minAngle)/antennaOffset; 
    minLength = 5; maxLength = 30;
    
    // Head properties. 
    headCenter = pos; 
    scale = s;
    headRadius = radius; 
    bodyHeight = bh;
    bodyWidth = bodyHeight/2;
    
    // Spots
    spots = new ArrayList(); 
    numSpots = 50; 
    
    // Create antennas and spot collections. 
    calcRandomIndices(numAntennas, maxAntennas); 
    createAntennaVectors();
    createSpots();
  }
  
  void run() {
   pushMatrix();
     translate(headCenter.x, headCenter.y); 
     // Always scale!! Everything is relative to the 
     // organism's head's center. 
     scale(scale);
     antennas();
     head();
     legs();
     body();
   popMatrix();
  }
  
  void head() {
    pushStyle();
    // Head/Eye socket
    stroke(0); strokeWeight(2);
    fill(0);
    ellipse(0, 0, headRadius*2, headRadius*2);
    popStyle();
  }

  void antennas() {
    // Calculate antenna locations on the head's surface for random
    // index where an antenna needs to be there.    
    for (int i = 0; i < antIndices.size(); i++) {
     // Theta at that index. 
     int theta = antennaOffset * antIndices.get(i) + minAngle; 
     
     // Location on the head's surface. 
     float rad = radians(theta);
     PVector headEdge = new PVector(headRadius*cos(rad), headRadius*sin(rad));
     
     // Antenna's edge. 
     PVector antEdge = antEdges.get(i);
     pushStyle(); 
      strokeWeight(1); 
      stroke(0);
      line(headEdge.x, headEdge.y, antEdge.x, antEdge.y); 
      noStroke(); 
      fill(255, 0, 0);
      ellipse(antEdge.x, antEdge.y, 3, 3);
     popStyle();
    }
  }
  
  void legs() {
    // Create tiny little legs around the body. 
    PVector bodyCenter = new PVector(0, bodyHeight/2);
    
    // Entire body with tentacles.
    for (int theta = 0; theta < 360; theta+=18) {
      float rad = radians(theta);
      PVector edge = new PVector(bodyCenter.x + bodyWidth/2*cos(rad), bodyCenter.y + bodyHeight/2*sin(rad)); 
      PVector normalDir = PVector.sub(edge, bodyCenter);
      normalDir.normalize();
      normalDir.mult(random(2, 5));
      PVector legEdge = PVector.add(edge, normalDir); 
      //Draw line from edge to ledEdge
      pushStyle(); 
      stroke(0); 
      strokeWeight(1); 
      line(edge.x, edge.y, legEdge.x, legEdge.y);
      popStyle();
    }
  }
  
  void body() {
    pushStyle(); 
      ellipseMode(CENTER); 
      fill(255, 0, 0); 
      noStroke();
      ellipse(0, bodyHeight/2, bodyWidth, bodyHeight);
      
      // Draw the spots. 
      fill(0); 
      stroke(0); strokeWeight(1);
      line(0, 0, 0, bodyHeight);
    popStyle();
  }
  
  void calcRandomIndices(int numAntennas, int maxAntennas) {
    for (int i = 0; i < numAntennas; i++) {
      int idx; 
      do {
       idx = floor(random(maxAntennas));
      } while(antIndices.hasValue(idx)); // Keep checking until I find a random number that's not in the list. 
      antIndices.append(idx); 
    }
  }
  
  void createAntennaVectors() {
    // Assume that we have already transposed. So, all the calculations are done
    // as if the headCenter is at 0,0. This is important to save the length of the
    // organism's antennas. 
    for (int i = 0; i < antIndices.size(); i++) {
     // Theta at that index. 
     int theta = antennaOffset * antIndices.get(i) + minAngle; 
     
     // Location on the head's surface. 
     float rad = radians(theta);
     PVector headEdge = new PVector(headRadius*cos(rad), headRadius*sin(rad));
    
     // Antenna edge vector (assume we have already transposed). We always scale the creature's body. 
     // That's why vector is calculated with respect to the origin. 
     PVector normalDir = PVector.sub(headEdge, new PVector(0, 0));
     normalDir.normalize();
     normalDir.mult(random(minLength, maxLength));
     antEdges.add(PVector.add(headEdge, normalDir)); 
    }
  }
  
  void createSpots() {
    //// Num spots
    //PVector bodyCenter = new PVector(0, bodyHeight/2);
    //for (int i = 0; i < numSpots; i++) {
    //  float angle = random(360); 
    //  float randX = bodyCenter.x + random(bodyWidth/2) * cos(angle); 
    //  float randY = bodyCenter.y + random(bodyHeight/2) * sin(angle);
    //  spots.add(new PVector(randX, randY));
    //}
  }
}
