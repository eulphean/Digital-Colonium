import controlP5.*; 

int numAgents = 50; int numFood = 100; // Starting parameters for food. 
int numPixelBricks = 15; 

// Initialize the GUI
ControlP5 cp5; 
int agentVisionRadius; 
Slider visSlider; 

// Flags
boolean hideGui;
boolean turnOnVision = false; 
boolean restartWorld = false;

// Initialize a world
World world;

void setup() {
  //size(500, 500);
  fullScreen();
  
  // Initialize GUI flags. 
  hideGui = false;
  turnOnVision = false; 
  
  agentVisionRadius = 40; 
  cp5 = new ControlP5(this); 
  visSlider = cp5.addSlider("agentVisionRadius")
              .setPosition(5, 5)
              .setSize(100, 20)
              .setRange(10, 200)
              .setValue(agentVisionRadius)
              .setColorCaptionLabel(color(255));
              
  
  world = new World(numAgents, numFood, numPixelBricks);
  ellipseMode(RADIUS);
  smooth();
}

void draw() {
  background(0);
  
  if (restartWorld) {
    world = new World(numAgents, numFood, numPixelBricks);
    restartWorld = false;
  }
    
  // Update environment
  world.run();
  
  // Print health of the system
  // Number of agents
  // Number of food particles
  // Generations
  if (hideGui) {
    visSlider.hide();
  } else {
    visSlider.show();  
    pushStyle();
    color c = color(255);
    fill(c);
    textSize(15);
    // Generation
    text("Gen: " + world.generation, 5, 45);
    text("Agents: " + world.agents.size(), 5, 60);
    text("Food: " + world.food.food.size(), 5, 75);
    text("Frame rate: " + frameRate, 5, 90);
    popStyle();
  }
}

void keyPressed() {
  if (key == 'h') {
    hideGui = !hideGui;
  }
  
  if (key == 't') {
    turnOnVision = !turnOnVision; 
  }
  
  if (key == 'r') {
    restartWorld = !restartWorld;  
  }
}
