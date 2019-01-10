class Insect extends Agent {
  // Organism
  float scale; 
  
  // Head 
  PVector headCenter;
  float headRadius; 
  
  // Properties.  
  int maxAngle; int minAngle; 
  int antennaOffset; 
  
  // Body
  float bodyHeight; float bodyWidth; 
  ArrayList<PVector> spots; int numSpots;
  
  PShape body;
  
  Insect(PVector pos, DNA _dna, float s) {
    // Initialize its base class. 
    super(pos, _dna, 2*s); 
   
    // Head properties. 
    headCenter = pos; 
    scale = s;
    headRadius = 2; // Hardcoding these number. They are either coming from genotype or somewhere. 
    bodyHeight = 20;
    bodyWidth = bodyHeight/2;
    
    // Spots
    spots = new ArrayList(); 
    numSpots = 50; 
    
    // Create body
    ellipseMode(CENTER);
    body = createShape(ELLIPSE, 0, 0, bodyWidth, bodyHeight);
    body.setFill(color(255, 0, 0)); 
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
      //head(); 
      //legs(); 
      body(theta);
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
  
  void body(float theta) {
    pushMatrix(); 
      translate(0, bodyHeight/2); 
      body.setFill(bodyColor); 
      body.setStroke(bodyColor); 
      shape(body); 
    popMatrix();
  }
}
