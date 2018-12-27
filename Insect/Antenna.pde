class Antenna {
  PVector antEdge; 
  PVector headEdge; 
  int minLength; int maxLength; 
  int idx; // For debugging
  float angle; float incrementer;
  
  Antenna(PVector start, int i) {
    minLength = 10; maxLength = 20; 
    headEdge = start; idx = i; 
    
    // Antenna edge vector (assume we have already transposed). We always scale the creature's body. 
    // That's why vector is calculated with respect to the origin. 
    PVector normalDir = PVector.sub(headEdge, new PVector(0, 0));
    normalDir.normalize();
    normalDir.mult(random(minLength, maxLength));
    antEdge = PVector.add(headEdge, normalDir); 
    
    // Initialize animation.
    angle = 0; incrementer = random(-0.015, 0.015);
  }
  
  // Show antenna
  void run() {
    // [NOTE] Temporary animation for the tentacles. This 
    // can definitely be improved in the next iteration, 
    angle+=incrementer; 
    
    // Update for animation.
    pushStyle(); 
     strokeWeight(1); 
     stroke(0);
     float endX = antEdge.x + sin(angle)*2;  
     line(headEdge.x, headEdge.y, endX, antEdge.y); 
     noStroke(); 
     fill(255, 0, 0);
     ellipse(endX, antEdge.y, 3, 3);
    popStyle();
  }  
}
