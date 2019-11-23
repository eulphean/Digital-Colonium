import controlP5.*; 
import ddf.minim.*;
import ddf.minim.ugens.*;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

// Minim sound engine. 
Minim minim; AudioOutput out;

// Sketch applet pointer. 
PApplet sketchPointer = this; 

// Factories for Shaders and Icons. 
ShaderFactory shaderFactory; IconFactory iconFactory; 

// Background shader. 
PGraphics pg; PShader shader; 

// World that contains everything. 
World world;

// Array of all animation easings. We pick randomly.  
Easing[] easings = { 
  Ani.QUAD_OUT, Ani.CUBIC_OUT, Ani.QUART_OUT, Ani.QUINT_OUT, Ani.SINE_OUT, Ani.CIRC_IN, Ani.CIRC_OUT, 
  Ani.EXPO_IN, Ani.EXPO_OUT, Ani.BACK_IN, Ani.BACK_OUT, Ani.BOUNCE_IN, Ani.BOUNCE_OUT, 
  Ani.ELASTIC_IN, Ani.ELASTIC_OUT
};


// Interactive boolean flags. 
boolean hideGui, displayAgent, restartWorld, debug, healthStats, turnOnVision, releaseAgents, showAppWatcher; 

// Initialize the GUI
ControlP5 cp5; 

// GUI Parameters
// Agent
int numAgents = 50; 
float agentScale = 1.0; 
int foodPerceptionRad = 40; 
int seperationPerceptionRad = 40;  
int alignmentPerceptionRad = 50;  
int cohesionPerceptionRad = 50; 

// Force weight
float foodW = 2.0; 
float seperationW = 0.5; 
float alignmentW = 0.5; 
float cohesionW = 0.5; 
float wanderingW = 0.5; 

// UNUSED RIGHT NOW
float bodyHealth = 200.0; 

// Food
int numFood = 50; 
float flowerScale = 0.6; 

// Volume
float volume = 0.5; 

// App Watcher (TODO: Add the time for this)
int minWaitTime = 20000; 
int maxWaitTime = 30000; 

void setup() {
  fullScreen(P2D);
  
  // Initialize animation engine. 
  Ani.init(this);

  // Run some code when the sketch closes. 
  prepareExitHandler();
  
  // Load all shaders and icons inside the factory. 
  shaderFactory = new ShaderFactory();
  iconFactory = new IconFactory();

  // Initialize all interactive flags. 
  hideGui = displayAgent = restartWorld = debug = healthStats = turnOnVision = releaseAgents = showAppWatcher = false; 
  
  // Initialize GUI.  
  initializeGui();

  world = new World(numAgents, numFood);
  ellipseMode(RADIUS);
  smooth();

  // Initialize sound engine. 
  minim = new Minim(this);
  out = minim.getLineOut(Minim.STEREO, 2048);
  
  // Initialize background shader. 
  setupBackgroundShader(); 
}

void draw() { 
  // Redraw background shader consequently. 
  image(pg, 0, 0);

  if (restartWorld) {
    world = new World(numAgents, numFood);
    restartWorld = false;
  }
  
  // Update environment
  world.run();

  if (hideGui) {
    cp5.hide(); noCursor();
    println("Frame Rate: " + frameRate); 
  } else {
    cp5.show(); cursor(); 
    fill(0);
    text("Frame Rate: " + frameRate, 20, 690);  
  }
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
      cp5.saveProperties(("figmentsofattention"));
    }
  }
  ));
}

void initializeGui() {
  ControlFont labelFont = new ControlFont(createFont("Arial",15));
  
  cp5 = new ControlP5(this);
  cp5.setColorCaptionLabel(0); 
  cp5.setFont(labelFont);
  cp5.setMoveable(true);
 

  // All the groups 
  Group agent = cp5.addGroup("Agents")
            .setBarHeight(20)
            .setWidth(150)
            .setPosition(20,30)
            .setColorLabel(color(255));
  
  cp5.addSlider("numAgents")
    .setPosition(0, 0)
    .setSize(150, 30)
    .setRange(0, 200)
    .setValue(numAgents)
    .setGroup(agent);
    
  cp5.addSlider("agentScale")
    .setPosition(0, 35)
    .setSize(150, 30)
    .setRange(0, 3.0)
    .setValue(agentScale)
    .setGroup(agent);
            
  cp5.addSlider("foodPerceptionRad")
    .setPosition(0,70)
    .setSize(150, 30)
    .setRange(0, 150)
    .setValue(foodPerceptionRad)
    .setGroup(agent);
  
  cp5.addSlider("seperationPerceptionRad")
    .setPosition(0,105)
    .setSize(150, 30)
    .setRange(0, 150)
    .setValue(seperationPerceptionRad)
    .setGroup(agent);
  
  cp5.addSlider("alignmentPerceptionRad")
    .setPosition(0,140)
    .setSize(150, 30)
    .setRange(0, 150)
    .setValue(alignmentPerceptionRad)
    .setGroup(agent);
  
  cp5.addSlider("cohesionPerceptionRad")
    .setPosition(0,175)
    .setSize(150, 30)
    .setRange(0, 150)
    .setValue(cohesionPerceptionRad)
    .setGroup(agent);
  
  cp5.addSlider("foodW")
    .setPosition(0,210)
    .setSize(150, 30)
    .setRange(0, 20.0)
    .setValue(foodW)
    .setGroup(agent);

  cp5.addSlider("seperationW")
    .setPosition(0,245)
    .setSize(150, 30)
    .setRange(0, 10.0)
    .setValue(seperationW)
    .setGroup(agent);
  
  cp5.addSlider("cohesionW")
    .setPosition(0,280)
    .setSize(150, 30)
    .setRange(0, 5.0)
    .setValue(cohesionW)
    .setGroup(agent);
    
  cp5.addSlider("alignmentW")
    .setPosition(0,315)
    .setSize(150, 30)
    .setRange(0, 5.0)
    .setValue(alignmentW)
    .setGroup(agent);

  cp5.addSlider("wanderingW")
    .setPosition(0,350)
    .setSize(150, 30)
    .setRange(0, 1.0)
    .setValue(wanderingW)
    .setGroup(agent);
 
  // Apps group. 
  Group apps = cp5.addGroup("Apps")
           .setBarHeight(20)
           .setWidth(150)
           .setPosition(20,450)
           .setColorLabel(color(255));
            
  cp5.addSlider("numFood")
    .setPosition(0, 0)
    .setSize(150, 30)
    .setRange(0, 500)
    .setValue(numFood)
    .setGroup(apps);
  
  cp5.addSlider("flowerScale")
    .setPosition(0, 35)
    .setSize(150, 20)
    .setRange(0, 1)
    .setValue(flowerScale)
    .setGroup(apps); 
       
  // App Watcher group. 
  Group appWatcher = cp5.addGroup("App Watcher")
               .setBarHeight(20)
               .setWidth(150)
               .setPosition(20, 540)
               .setColorLabel(color(255));
  
  cp5.addSlider("minWaitTime")
    .setPosition(0, 0)
    .setSize(150, 30)
    .setRange(10000, 40000)
    .setValue(minWaitTime)
    .setGroup(appWatcher);
               
  cp5.addSlider("maxWaitTime")
    .setPosition(0, 35)
    .setSize(150, 30)
    .setRange(30000, 60000)
    .setValue(maxWaitTime)
    .setGroup(appWatcher);
    
  // Sound group. 
  Group sound = cp5.addGroup("Volume")
            .setBarHeight(20)
            .setWidth(150)
            .setPosition(20,640)
            .setColorLabel(color(255)); 
            
  cp5.addSlider("volume")
    .setPosition(0, 0)
    .setSize(150, 30)
    .setRange(0, 5.0)
    .setValue(volume)
    .setGroup(sound);

  cp5.loadProperties(("figmentsofattention"));
}
