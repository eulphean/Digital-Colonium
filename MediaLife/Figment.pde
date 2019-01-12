class Figment extends Agent {
  int bodyHeight; int bodyWidth; 
  
  // Individual parts of the body. 
  PShape fig; 
  PShape body;
  
  // Mutations parts. 
  PShape tail; 
  PShape eye;
  ArrayList<PShape> antennas; 
  ArrayList<PShape> first; 
  ArrayList<PShape> second; 
  ArrayList<PShape> third; 
  ArrayList<PShape> fourth; 
  ArrayList<PShape> fifth; 
  ArrayList<PShape> sixth; 
 
  int maxFins; int maxSpots;
  int [] randFins;
  
  Figment(PVector pos) {
    // Initialize its base class. 
    super(pos); 
    bodyHeight = 20;
    bodyWidth = bodyHeight/2;
    maxFins = 13; maxSpots = 12; 

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
      
      // Body
      fill(bodyColor); 
      shape(antennas.get(0)); 
      shape(antennas.get(1));
      
      // Draw first extensions. 
      fill(bodyColor); 
      shape(first.get(0)); 
      shape(first.get(1));
      
      // Draw second extensions. 
      fill(bodyColor); 
      shape(second.get(0)); 
      shape(second.get(1));
      
      // Draw third extensions. 
      fill(bodyColor); 
      shape(third.get(0)); 
      shape(third.get(1));
    
      // Draw fourth extensions. 
      fill(bodyColor); 
      shape(fourth.get(0)); 
      shape(fourth.get(1));
      
      // Draw fifth extensions. 
      fill(bodyColor); 
      shape(fifth.get(0)); 
      shape(fifth.get(1));
      
      // Draw sixth extensions. 
      fill(bodyColor); 
      shape(sixth.get(0)); 
      shape(sixth.get(1));
      
      // Draw tail
      fill(bodyColor); 
      shape(tail);
      
      // Draw body. 
      fill(bodyColor);
      shape(body);
      
      //// Draw eye
      fill(255);
      shape(eye);
    popMatrix();
  }
  
  //int [] calcRandIndices(int min, int max){
  //  IntList randIndices = new IntList();
  //  int num = max - min; 
    
  //  for (int i = 0; i < num; i++) {
  //    int idx; 
  //    do {
  //      idx = floor(random(min, max+1));
  //    } while (randIndices.hasValue(idx));
  //    randIndices.push(idx);
  //  }
    
  //  return randIndices.array();
  //}
  
  void loadBodyParts() {
    // Load body. 
    body = fig.getChild("body"); 
    body.disableStyle();
    
    // Load tail.
    tail = fig.getChild("tail"); 
    tail.disableStyle();
    
    // Load eye. 
    eye = fig.getChild("eye");
    eye.disableStyle();
    
    // Load antennas. 
    antennas = new ArrayList(); 
    antennas.add(fig.getChild("antenna-left")); 
    antennas.add(fig.getChild("antenna-right")); 
    
    // First extension
    first = new ArrayList();
    first.add(fig.getChild("first-left"));
    first.add(fig.getChild("first-right"));
    
    // Second extension
    second = new ArrayList();
    second.add(fig.getChild("second-left"));
    second.add(fig.getChild("second-right"));
    
    // Third extension
    third = new ArrayList();
    third.add(fig.getChild("third-left"));
    third.add(fig.getChild("third-right"));
    
    // Fourth extension
    fourth = new ArrayList();
    fourth.add(fig.getChild("fourth-left"));
    fourth.add(fig.getChild("fourth-right"));
    
    // Fifth extension
    fifth = new ArrayList();
    fifth.add(fig.getChild("fifth-left"));
    fifth.add(fig.getChild("fifth-right"));
    
    // Sixth extension
    sixth = new ArrayList();
    sixth.add(fig.getChild("sixth-left"));
    sixth.add(fig.getChild("sixth-right")); 
  }
}
