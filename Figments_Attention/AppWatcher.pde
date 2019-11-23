import java.util.Collections; 

class AppWatcher {
  // Brick stuff. 
  ArrayList<Icon> icons; 
  PGraphics logoWall; 
  PGraphics ellipse; 
  int numRows; int numCols; 
  int svgSize; // width = height
  int wallWidth; int wallHeight;
  PVector position; // Image position from the corner since it's drawn as an Image. 
  
  long shuffleTime; 

  // Shader parameters. 
  Shade shader; 
  int idxShader; 
  long effectTime; 
  
  // Animation stufff. 
  int aniCounter; int aniPeriod; // Animation counter
  boolean isAnimating, isWaitingInitialized;
  long waitTime; long timeToWait;
  
  // Food stuff. 
  boolean createFood; long timeToCreateFood; 
  
  // Time
  long appWatcherTime; long appWatcherWait;
  float amp; float frequency; 
  EmitterInstrument instrument;
  
  // To keep track of app watcher. 
  boolean showAppWatcher; 
  
  AppWatcher() {
    // SVG params. 
    numRows = 5; numCols = 17; svgSize = 20; 
    
    // Get the shader at specific index. 
    //idxShader = floor(random(shaderFactory.shaders.length)); 
    idxShader = 7; 
    shader = shaderFactory.getShaderAtIdx(idxShader); 
    
    // Animation 
    aniCounter = 0; // Defines the change of state. 
    aniPeriod = 500; // 500 frames long animation.
    isAnimating = true; isWaitingInitialized = false;
    timeToWait = 3000; 
    
    // Food. 
    createFood = false; 
    
    // Logo brick dimensions.
    wallWidth = numCols*svgSize; wallHeight = numRows*svgSize; 
    logoWall = createGraphics(svgSize*numCols, svgSize*numRows);
    icons = iconFactory.getAllIcons();  
    
    // Reset times
    shuffleTime = millis(); effectTime = millis();
    
    // App Watcher Position.
    position = new PVector(0, 0); 
    updatePosition(); 
    
    // First time app watcher
    appWatcherTime = millis(); appWatcherWait = ceil(random(5000, 10000));
    
    // App wall and mask it with the shape. 
    drawAppsOffscreen();
    
    // Sound initialize
    frequency = Frequency.ofMidiNote(60).asHz();
    amp = 0.5;
    instrument = new EmitterInstrument(frequency, amp);
    
    showAppWatcher = false; 
    
    // Graphics. 
    ellipse = createGraphics(wallWidth, wallHeight); 
  }
  
  void run() {
    // Don't draw this when not required. 
    if (showAppWatcher) {
      updateShaderParams();
      
      // Update the shape. 
      if (isAnimating) {
       updateMaskShape(); 
       aniCounter++;
      }   
      
      // Do an alpha mask. 
      logoWall.mask(ellipse);
      
      // Actual draw logic. 
      showApps();  
      
      shuffleApps();
      
      // Evaluate animation state. 
      checkAnimation();
    } else if (millis() - appWatcherTime > appWatcherWait) {
      showAppWatcher = true; 
      out.playNote(0.5, 3.0, instrument);
    }
  }
  
  void checkAnimation(){
    // Done with 1 period of animation. 
    if (aniCounter%aniPeriod == 0) {
      showAppWatcher = false; 
      
      // Reset tie
      appWatcherTime = millis(); 
      appWatcherWait = ceil(random(minWaitTime, maxWaitTime)); 
      
      // Assign eye a new position. 
      updatePosition();
      
    } else if (aniCounter%(aniPeriod/2)==0) { // Eye fully open 
      isAnimating = false;
      
      // Begin waiting. At some point, food must be created. 
      if (!isWaitingInitialized) {
        createFood = true;
        waitTime = millis();
        isWaitingInitialized = true;
        timeToCreateFood = ceil(random(1, timeToWait-1000));
      } else if (millis() - waitTime > timeToWait) {
        isAnimating = true; 
        isWaitingInitialized = false;
      }
    }
  }
  
  void showApps() {
    // Image needs to be drawn at a specific position. 
    shader(shader.shade);
    image(logoWall, position.x, position.y);
    resetShader();
  }
 
  void updateMaskShape() {
    ellipse.beginDraw(); 
    ellipse.background(0);
    ellipse.ellipseMode(CENTER); 
    ellipse.fill(255); 
    noStroke();
    ellipse.smooth();
    
    // Starts at 0 right now. 
    float val = cos(TWO_PI*aniCounter/500);
    int ellipseHeight = int(map(val, -1, 1, wallHeight, 0));
    
    ellipse.ellipse(wallWidth/2, wallHeight/2, wallWidth, ellipseHeight); 
    ellipse.endDraw();
  }
  
  void drawAppsOffscreen() {
    logoWall.beginDraw();
      logoWall.fill(0); // Clear
      for (int x = 0; x < numCols; x++) {
       for (int y = 0; y < numRows; y++) {
         int idx = x + numCols * y;
         PShape img = icons.get(idx).ic;  
         logoWall.shape(img, x*svgSize, y*svgSize, svgSize, svgSize); 
       }
      }
    logoWall.endDraw();
  }

  void shuffleApps() {
    if (millis() - shuffleTime > 100) { 
      shuffleTime = millis(); 
      Collections.shuffle(icons);
      drawAppsOffscreen();
    }
  }
  
  void updatePosition() {
    int x = width - wallWidth; int y = height - wallHeight; 
    position.x = random(0, x); position.y = random(0, y);
  }
  
  // Shader params for the appWatcher
  void updateShaderParams() 
  {
    PShader shade = shader.shade; 
    
    float offset = 2*PI; 
    float x = cos(frameCount/offset); float y = sin(frameCount/offset);
    
    // brcosa
    if (idxShader == 0) {
      float o = 5*PI; 
      float a = cos(frameCount/offset); float b = sin(frameCount/offset); 
      shade.set("brightness", 1.0);
      shade.set("contrast", map(a, -1, 1, -5, 5));
      shade.set("saturation", map(b, -1, 1, -5, 5));
    }
  
    // hue
    else if (idxShader == 1) {
      shade.set("hue", map(x, -1, 1, 0, TWO_PI));
    } 
  
    // pixelate
    else if (idxShader == 2) {
      shade.set("pixels", 0.1 * x * width/5, 0.1 * y * height/5);
    } 
  
    // blur
    else if (idxShader == 3) {
      shade.set("sigma", map(x, -1, 1, 0, 10.0));
      shade.set("blurSize", (int) map(y, -1, 1, 0, 30.0));
      shade.set("texOffset", 1.0, 1.0);
    } 
  
    // channels
    else if (idxShader == 4) {
      float o = 50*PI; 
      float a = cos(frameCount/offset); float b = sin(frameCount/offset);
    
      shade.set("rbias", 0.0, 0.0);
      shade.set("gbias", map(b, -1, 1, -0.05, 0.05), 0.0);
      shade.set("bbias", 0.0, 0.0);
      shade.set("rmult", map(a, -1, 1, 0.01, 0.05), 0.5);
      shade.set("gmult", 1.0, 1.0);
      shade.set("bmult", 1.0, 1.0);
    } 
    
    // threshold
    else if (idxShader == 5) {
      shade.set("threshold", map(x, -1, 1, 0, 1));
    } 
  
    // neon
    else if (idxShader == 6) {
      shade.set("brt", map(x, -1, 1, 0, 0.5));
      shade.set("rad", (int) map(y, -1, 1, 0, 3));
    } 
  
    // edges (no parameters)
    else if (idxShader == 7) {
    }
   
    // pixelRolls
    else if (idxShader == 8) {
      float o = 5*PI; 
      float a = cos(frameCount/offset); float b = sin(frameCount/offset);
      shade.set("time", (float) millis()/5000.0);
      shade.set("pixels", a*width, 250.0);
      shade.set("rollRate", map(b, -1, 1, 0, 2.0));
      shade.set("rollAmount", 0.1);
    }
  
    // modcolor
    else if (idxShader == 9) {
      shade.set("modr", map(x, -1, 1, 0, 0.5));
      shade.set("modg", 0.3);
      shade.set("modb", map(y, -1, 1, 0, 0.5));
    }
  
    // halftone
    else if (idxShader == 10) {
      shade.set("pixelsPerRow", (int) map(x, -1, 1, 20, 60));
    }
    
    // halftone cmyk
    else if (idxShader == 11) {
      shade.set("density", map(x, -1, 1, 0.5, 1));
      shade.set("frequency", map(y, -1, 1, 30, 100));
    }
  
    // inversion (no parameters)
    else if (idxShader == 12) {
    }  
  }
}
