class Figment extends Agent {
  int bodyHeight; int bodyWidth; 
  PShape body; 
  
  Figment(PVector pos,  float s) {
    // Initialize its base class. 
    super(pos, s); 
    bodyHeight = 20;
    bodyWidth = bodyHeight/2;

    body = createShape(ELLIPSE, 0, 0, 10, 20); 
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
    body(theta);
   popMatrix();
  }
  
  void body(float theta) {
    pushMatrix(); 
      translate(0, bodyHeight/2);
      body.setFill(bodyColor); 
      body.setStroke(strokeColor); 
      body.strokeWeight(strokeWeight);
      shape(body); 
    popMatrix();
  }
}
