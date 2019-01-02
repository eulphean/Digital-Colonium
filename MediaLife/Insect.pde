class Insect extends Agent {
  // Organism
  float scale; 
  
  // Head 
  PVector headCenter;
  float headRadius; 
  
  // Antenna properties. 
  // [NOTE] Could evolve certainly. 
  ArrayList<Antenna> antennas; 
  IntList antIndices; 
  int numAntennas, maxAntennas; 
  int maxAngle; int minAngle; 
  int antennaOffset; 
  
  // Body
  float bodyHeight; float bodyWidth; 
  ArrayList<PVector> spots; int numSpots;
  
  Insect(PVector pos, DNA _dna, float s) {
    // Initialize its base class. 
    super(pos, _dna, 4*s); 
   
    // Head properties. 
    headCenter = pos; 
    scale = s;
    headRadius = 4; // Hardcoding these number. They are either coming from genotype or somewhere. 
    bodyHeight = 20;
    bodyWidth = bodyHeight/2;
    
    // List of antennas. 
    antennas = new ArrayList(); 
    antIndices = new IntList(); 
    minAngle = 200; maxAngle = 340; 
    antennaOffset = 10;
    numAntennas = floor(random(0, 10)); // Hardcoding. Should be figured out based on Agent's current state. 
    maxAntennas = (maxAngle-minAngle)/antennaOffset;
    calcRandomIndices(numAntennas, maxAntennas);
    initAntennas();
    
    // Spots
    spots = new ArrayList(); 
    numSpots = 50; 
  }
  
  void display() {
   if (displayAgent) {
     super.displayAgent(); 
   } else {
     pushMatrix(); 
      float theta = velocity.heading() + radians(90);
      translate(headCenter.x, headCenter.y); 
      rotate(theta);
      scale(scale); 
      // antennas(); 
      //head(); 
      legs(); 
      body();
     popMatrix();
   }
  }
  
  void head() {
    pushStyle();
    // Head/Eye socket
    noStroke();
    fill(255);
    ellipse(0, 0, headRadius*2, headRadius*2);
    popStyle();
  }
  
  void antennas() {
   for (Antenna a: antennas) {
    a.run(); 
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
      normalDir.mult(random(1, 3));
      PVector legEdge = PVector.add(edge, normalDir); 
      //Draw line from edge to ledEdge
      pushStyle(); 
      stroke(255); 
      strokeWeight(1); 
      line(edge.x, edge.y, legEdge.x, legEdge.y);
      popStyle();
    }
  }
  
  void body() {
    pushStyle(); 
      ellipseMode(CENTER); 
      fill(bodyColor); 
      noStroke();
      ellipse(0, bodyHeight/2, bodyWidth, bodyHeight);
      // Line
      fill(0); 
      stroke(0); strokeWeight(1);
      //line(0, 0, 0, bodyHeight);
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
  
  void initAntennas() {
    for (int i = 0; i < antIndices.size(); i++) {
     // Theta at that index. 
     int theta = antennaOffset * antIndices.get(i) + minAngle; 
     // Location on the head's surface. 
     float rad = radians(theta);
     PVector headEdge = new PVector(headRadius*cos(rad), headRadius*sin(rad));
     antennas.add(new Antenna(headEdge, i)); 
    }
  }
}
