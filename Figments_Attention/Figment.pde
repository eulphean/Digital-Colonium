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
   
   pushMatrix(); 
    float theta = velocity.heading() + radians(90);
    translate(position.x, position.y); 
    rotate(theta);
    scale(scale);
    body();
   popMatrix();
  }
  
  void body() {
    pushMatrix(); 
    pushStyle(); 
      fill(bodyColor); 
      noStroke();
      
      // Always draw body.  
      fill(bodyColor);
      shape(body);
      
    popStyle();
    popMatrix();
  }
  
  
  void loadBodyParts() {
    // Only load body. 
    body = fig.getChild("body"); 
    body.disableStyle(); 
  }
}
