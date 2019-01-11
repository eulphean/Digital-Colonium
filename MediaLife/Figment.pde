class Figment extends Agent {
  int bodyHeight; int bodyWidth; 
  PShape fig; 
  
  Figment(PVector pos) {
    // Initialize its base class. 
    super(pos); 
    bodyHeight = 20;
    bodyWidth = bodyHeight/2;

    // Base shape. 
    fig = loadShape("Figment.svg"); 
    fig.disableStyle();
    fig.scale(2.0); // Base scale. 
    fig.translate(-fig.width, 0);
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
      shape(fig); 
      popStyle();
    popMatrix();
  }
}
