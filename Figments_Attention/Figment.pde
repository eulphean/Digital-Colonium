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
  PShape trailPoint;
  
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
   float theta = velocity.heading() + radians(90);
   pushStyle();
     noStroke();
     if (debug) {
       super.displayDebug(); 
       // Draw boid's body.
       pushMatrix(); 
        fill(0); 
        translate(position.x, position.y); 
        rotate(theta);
        scale(agentScale);
        shape(body);
       popMatrix();
     } else {
       //// Draw the trails.
       for (int i=0; i<maxTrailPoints; i++) {
         if (trail[i] != null) {
           pushMatrix(); 
           translate(trail[i].x, trail[i].y);
           scale(3.5, 3.5);
           stroke(0, 153, 0, trail[i].a);
           point(0, 0);
           trail[i].a -= 255/maxTrailPoints; 
           popMatrix();
         }
       }
       
       // Draw boid's fins. 
       pushMatrix();
        stroke(0);
        fill(0, 153, 0);  
        translate(position.x,position.y);
        rotate(theta);
        beginShape(TRIANGLES);
        vertex(0, 0);
        vertex(-size, size*4);
        vertex(size, size*4);
        endShape(); 
       popMatrix();
       
       // Draw boid's body.
       pushMatrix(); 
        noStroke();
        fill(bodyColor); 
        translate(position.x, position.y); 
        rotate(theta);
        scale(agentScale);
        shape(body);
       popMatrix();
     }
   popStyle(); 
  }
  
  void loadBodyParts() {
    // Only load body. 
    body = fig.getChild("body"); 
    body.disableStyle(); 
  }
}
