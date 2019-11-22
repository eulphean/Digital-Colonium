import controlP5.*; 
import ddf.minim.*;
import ddf.minim.ugens.*;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

// Initialize the GUI
ControlP5 cp5; 

// Sliders.
Group g1; 

// Food
int numFood = 50; 
Slider numFoodSlider;
float flowerScale = 0.6; 
Slider flowerScaleSlider; 

// Agent
int numAgents = 50; 
Slider numAgentsSlider;
float bodyHealth = 200.0; 
Slider bodyHealthSlider; 
float agentScale = 1.0; 
Slider agentScaleSlider; 

// Perceptions
int foodPerceptionRad = 40; 
Slider foodRadSlider; 
int seperationPerceptionRad = 40; 
Slider seperationRadSlider; 
int alignmentPerceptionRad = 50; 
Slider alignmentRadSlider; 
int cohesionPerceptionRad = 50; 
Slider cohesionRadSlider; 

// Weights
float foodW = 2.0; 
Slider foodWeightSlider;
float seperationW = 0.5; 
Slider seperationWeightSlider; 
float alignmentW = 0.5; 
Slider alignmentWeightSlider; 
float cohesionW = 0.5; 
Slider cohesionWeightSlider; 
float wanderingW = 0.5; 
Slider wanderSlider;
float volume = 0.5; 
Slider volumeSlider; 

// Animation easings 
Easing[] easings = { 
  Ani.QUAD_OUT, Ani.CUBIC_OUT, Ani.QUART_OUT, Ani.QUINT_OUT, Ani.SINE_OUT, Ani.CIRC_IN, Ani.CIRC_OUT, 
  Ani.EXPO_IN, Ani.EXPO_OUT, Ani.BACK_IN, Ani.BACK_OUT, Ani.BOUNCE_IN, Ani.BOUNCE_OUT, 
  Ani.ELASTIC_IN, Ani.ELASTIC_OUT
};

// Lookead
float aheadDistance = 30.0; 
Slider aheadDistanceSlider; 

// Boolean flags. 
boolean hideGui;
boolean displayAgent; 
boolean restartWorld;
boolean debug;
boolean healthStats;
boolean turnOnVision;
boolean releaseAgents; 
boolean showAppWatcher; 

// Sound engine.
Minim minim; 
AudioOutput out;

// Initialize a world
World world;

// Sketch applet pointer
PApplet sketchPointer = this; 

// Factories for Shaders and Icons. 
ShaderFactory shaderFactory;
IconFactory iconFactory; 

// Background shader
PGraphics pg; 
PShader shader; 

void setup() {
  fullScreen(P2D);
  
  Ani.init(this);

  // Run some code when the sketch closes. 
  prepareExitHandler();
  
  // Load all shaders and icons inside the factory. 
  shaderFactory = new ShaderFactory();
  iconFactory = new IconFactory();

  // Initialize GUI flags. 
  hideGui = true; 
  displayAgent = false; 
  restartWorld = false;
  debug = false;
  healthStats = false; 
  turnOnVision = false;
  releaseAgents = false;
  showAppWatcher = false; 
  
  // GUI stuff. 
  initializeGui();

  world = new World(numAgents, numFood);
  ellipseMode(RADIUS);
  smooth();

  // Setup sound. 
  minim = new Minim(this);
  out = minim.getLineOut(Minim.STEREO, 2048);
  
  // Setup background shader
  setupBackgroundShader(); 
}

void draw() { 
  //background(255);  
  
  // Redraw background shader consequently. 
  image(pg, 0, 0);

  if (restartWorld) {
    world = new World(numAgents, numFood);
    restartWorld = false;
  }
  
  // Update environment
  world.run();

  if (hideGui) {
    g1.hide();
    noCursor();
  } else {
    g1.show(); 
    cursor(); 
    text("Frame rate: " + frameRate, 200, 100);  
  }
}

void initializeGui() {
  cp5 = new ControlP5(this); 

  g1 = cp5.addGroup("g1")
    .setPosition(5, 20);

  foodRadSlider = cp5.addSlider("foodPerceptionRad")
    .setPosition(0, 0)
    .setSize(100, 20)
    .setRange(0, 150)
    .setValue(foodPerceptionRad)
    .setColorCaptionLabel(color(255))
    .setGroup(g1);

  seperationRadSlider = cp5.addSlider("seperationPerceptionRad")
    .setPosition(0, 40)
    .setSize(100, 20)
    .setRange(0, 150)
    .setValue(seperationPerceptionRad)
    .setColorCaptionLabel(color(255))
    .setGroup(g1);

  flowerScaleSlider = cp5.addSlider("flowerScale")
    .setPosition(0, 60)
    .setSize(100, 20)
    .setRange(0, 1)
    .setValue(flowerScale)
    .setColorCaptionLabel(color(255))
    .setGroup(g1); 

  numAgentsSlider = cp5.addSlider("numAgents")
    .setPosition(0, 80)
    .setSize(100, 20)
    .setRange(0, 200)
    .setValue(numAgents)
    .setColorCaptionLabel(color(255))
    .setGroup(g1);

  numFoodSlider = cp5.addSlider("numFood")
    .setPosition(0, 100)
    .setSize(100, 20)
    .setRange(0, 500)
    .setValue(numFood)
    .setColorCaptionLabel(color(255))
    .setGroup(g1);

  foodWeightSlider = cp5.addSlider("foodW")
    .setPosition(0, 120)
    .setSize(100, 20)
    .setRange(0, 20.0)
    .setValue(foodW)
    .setColorCaptionLabel(color(255))
    .setGroup(g1);

  seperationWeightSlider = cp5.addSlider("seperationW")
    .setPosition(0, 140)
    .setSize(100, 20)
    .setRange(0, 10.0)
    .setValue(seperationW)
    .setColorCaptionLabel(color(255))
    .setGroup(g1);
  
  cohesionWeightSlider = cp5.addSlider("cohesionW")
    .setPosition(0, 160)
    .setSize(100, 20)
    .setRange(0, 5.0)
    .setValue(cohesionW)
    .setColorCaptionLabel(color(255))
    .setGroup(g1);
    
  alignmentWeightSlider = cp5.addSlider("alignmentW")
    .setPosition(0, 180)
    .setSize(100, 20)
    .setRange(0, 5.0)
    .setValue(alignmentW)
    .setColorCaptionLabel(color(255))
    .setGroup(g1);

  wanderSlider = cp5.addSlider("wanderingW")
    .setPosition(0, 200)
    .setSize(100, 20)
    .setRange(0, 1.0)
    .setValue(wanderingW)
    .setColorCaptionLabel(color(255))
    .setGroup(g1);

  aheadDistanceSlider = cp5.addSlider("aheadDistance")
    .setPosition(0, 220)
    .setSize(100, 20)
    .setRange(0, 100)
    .setValue(aheadDistance)
    .setColorCaptionLabel(color(255))
    .setGroup(g1);

  volumeSlider = cp5.addSlider("volume")
    .setPosition(0, 240)
    .setSize(100, 20)
    .setRange(0, 5.0)
    .setValue(volume)
    .setColorCaptionLabel(color(255))
    .setGroup(g1);

  agentScaleSlider = cp5.addSlider("agentScale")
    .setPosition(0, 260)
    .setSize(100, 20)
    .setRange(0, 3.0)
    .setValue(agentScale)
    .setColorCaptionLabel(color(255))
    .setGroup(g1);
  
  alignmentRadSlider = cp5.addSlider("alignmentPerceptionRad")
    .setPosition(0, 280)
    .setSize(100, 20)
    .setRange(0, 150)
    .setValue(alignmentPerceptionRad)
    .setColorCaptionLabel(color(255))
    .setGroup(g1);
  
  cohesionRadSlider = cp5.addSlider("cohesionPerceptionRad")
    .setPosition(0, 300)
    .setSize(100, 20)
    .setRange(0, 150)
    .setValue(cohesionPerceptionRad)
    .setColorCaptionLabel(color(255))
    .setGroup(g1);


  cp5.loadProperties(("medialife"));
}

void keyPressed() {
  if (key == 'g') {
    hideGui = !hideGui;
  }

  if (key == 'a') {
    displayAgent = !displayAgent;
  }

  if (key == 't') {
    turnOnVision = !turnOnVision;
  }

  if (key == 'r') {
    restartWorld = !restartWorld;
  }

  if (key == 'd') {
    debug = !debug;
  }

  if (key == 'h') {
    healthStats = !healthStats;
  }

  if (key == ' ') {
    releaseAgents = !releaseAgents;
  }
  
  if (key == 'e') {
    showAppWatcher = true; 
  }
}

void setupBackgroundShader() {
  pg = createGraphics(width, height, P2D); 
  shader = loadShader("background.glsl");
  shader.set("time", (float) millis()/500.0);
  shader.set("resolution", float(pg.width), float(pg.height));
  pg.beginDraw(); 
  pg.shader(shader); 
  pg.rect(0, 0, pg.width, pg.height); 
  pg.endDraw(); 
}

void prepareExitHandler () {
  Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
    public void run () {
      cp5.saveProperties(("medialife"));
    }
  }
  ));
}
