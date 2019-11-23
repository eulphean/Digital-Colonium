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
   
   // Draw the trail
   for (int i=0; i<maxTrailPoints; i++) {
     if (trail[i] != null) {
       pushMatrix(); 
       translate(trail[i].x, trail[i].y); 
       fill(color(34, 38, 35, trail[i].a)); 
       ellipse(0, 0, 2.2, 2.2);
       trail[i].a -= 255/maxTrailPoints; 
       popMatrix();
     }
   }
   
   // Draw the body
   fill(bodyColor); 
   pushMatrix(); 
    float theta = velocity.heading() + radians(90);
    translate(position.x, position.y); 
    rotate(theta);
    scale(agentScale);
    shape(body);
   popMatrix();
   popStyle();
  }
  
  void loadBodyParts() {
    // Only load body. 
    body = fig.getChild("body"); 
    body.disableStyle(); 
  }
}
