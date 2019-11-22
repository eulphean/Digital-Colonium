class TrailPoint {
  float x=0, y=0, a=0; 
  TrailPoint(float x, float y, float alpha) {
   this.x = x; this.y = y; this.a = alpha;  
  }
}

class Figment extends Agent {
  int bodyHeight; int bodyWidth; 
  
  // Individual parts of the body. 
  PShape fig; 
  PShape body;
  
  Figment(PVector pos, float amp) {
    // Initialize its base class. 
    super(pos, amp); 
    // Base shape
    fig = loadShape("Figment.svg");
    fig.disableStyle();
    fig.translate(-fig.width/2, 0);
    fig.scale(3.0); 
    loadBodyParts();
  }
  
  void display() {
   if (displayAgent) {
     super.displayAgent(); 
   }
   
   // Draw the trails. 
   pushStyle(); 
   noStroke();
   // Draw the body
   fill(bodyColor); 
   pushMatrix(); 
    float theta = velocity.heading() + radians(90);
    translate(position.x, position.y); 
    rotate(theta);
    scale(scale);
    shape(body);
   popMatrix();
   
   // Draw the trail
   for (int i=0; i<maxTrailPoints; i++) {
     if (trail[i] != null) {
       fill(bodyColor, trail[i].a); 
       ellipse(trail[i].x, trail[i].y, 2, 2);
       trail[i].a -= 255/maxTrailPoints; 
     }
   }
   popStyle();
  }
  
  void loadBodyParts() {
    // Only load body. 
    body = fig.getChild("body"); 
    body.disableStyle(); 
  }
}
