class Antenna {
  PVector antEdge; 
  PVector headEdge; 
  int minLength; int maxLength; 
  int idx; // For debugging
  
  Antenna(PVector start, int i) {
    minLength = 5; maxLength = 30; 
    headEdge = start; idx = i; 
    
    // Antenna edge vector (assume we have already transposed). We always scale the creature's body. 
    // That's why vector is calculated with respect to the origin. 
    PVector normalDir = PVector.sub(headEdge, new PVector(0, 0));
    normalDir.normalize();
    normalDir.mult(random(minLength, maxLength));
    antEdge = PVector.add(headEdge, normalDir); 
  }
  
  // Show antenna
  void run() {
    // Update for animation.
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
