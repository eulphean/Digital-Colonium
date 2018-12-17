import controlP5.*; 

int numAgents = 20; int numFood = 50; // Starting parameters for food. 


// Initialize the GUI
ControlP5 cp5; 
int agentVisionRadius = 25; 
Slider visSlider; 

// Flags
boolean hideGui;

// Initialize a world
World world;

void setup() {
  size(500, 500);
  
  // Initialize GUI flags. 
  hideGui = false;
  
  agentVisionRadius = 25; 
  cp5 = new ControlP5(this); 
  visSlider = cp5.addSlider("agentVisionRadius")
              .setPosition(5, 5)
              .setSize(100, 20)
              .setRange(10, 200)
              .setValue(agentVisionRadius)
              .setColorCaptionLabel(255);
              
  
  world = new World(numAgents, numFood);
  ellipseMode(RADIUS);
  smooth();
}

void draw() {
  background(0);
  
  if (hideGui) {
    visSlider.hide();
  } else {
    visSlider.show();  
  }
    
  // Update environment
  world.run();
}

void keyPressed() {
  if (key == 'h') {
    hideGui = !hideGui;
  }
}
