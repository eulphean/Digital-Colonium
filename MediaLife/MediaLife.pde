import controlP5.*; 

// Initialize the GUI
ControlP5 cp5; 

// Sliders.
Group g1; 
int agentVisionRadius = 40; Slider visSlider; 
int numAgents = 50; Slider numAgentsSlider;
int numFood = 50; Slider numFoodSlider;
int numPixelBricks = 20; Slider numPixelBricksSlider;

// Flags
boolean hideGui;
boolean turnOnVision = false; 
boolean restartWorld = false;

// Initialize a world
World world;

void setup() {
  fullScreen();
  
  // Initialize GUI flags. 
  hideGui = false;
  turnOnVision = false; 
  
  initializeGui();
  
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
  
  if (hideGui) {
    g1.hide();
  } else {
    g1.show(); 
    pushStyle();
    color c = color(255);
    fill(c);
    textSize(15);
    // Generation
    text("Gen: " + world.generation, 5, 25);
    text("Agents: " + world.agents.size(), 5, 40);
    text("Food: " + world.food.food.size(), 5, 60);
    text("Frame rate: " + frameRate, 5, 75);
    popStyle();
  }
}

void initializeGui() {
  cp5 = new ControlP5(this); 
    
  g1 = cp5.addGroup("g1")
                .setPosition(5, 95);
                
  visSlider = cp5.addSlider("agentVisionRadius")
              .setPosition(0, 0)
              .setSize(100, 22)
              .setRange(0, 50)
              .setValue(agentVisionRadius)
              .setColorCaptionLabel(color(255))
              .setGroup(g1);
              
  numAgentsSlider = cp5.addSlider("numAgents")
              .setPosition(0, 22)
              .setSize(100, 20)
              .setRange(0, 200)
              .setValue(numAgents)
              .setColorCaptionLabel(color(255))
              .setGroup(g1);
  
  numFoodSlider = cp5.addSlider("numFood")
              .setPosition(0, 42)
              .setSize(100, 20)
              .setRange(0, 200)
              .setValue(numFood)
              .setColorCaptionLabel(color(255))
              .setGroup(g1);
  
  numPixelBricksSlider = cp5.addSlider("numPixelBricks")
              .setPosition(0, 62)
              .setSize(100, 20)
              .setRange(0, 200)
              .setValue(numPixelBricks)
              .setColorCaptionLabel(color(255))
              .setGroup(g1);
              
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
