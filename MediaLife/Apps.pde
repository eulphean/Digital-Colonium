import java.util.Collections; 
  
class Apps {
  // Brick stuff. 
  ArrayList<PShape> logos; 
  PGraphics logoWall; 
  PGraphics ellipse; 
  int numRows = 6; int numCols = 14; 
  int svgSize = 98; // width = height
  int wallWidth; int wallHeight;
  long shuffleTime; 
  
  // Shader stuff.
  // All the shaders. Shortlist which ones to keep for the final version. 
  String[] shaders = new String[] {
    "brcosa.glsl", "hue.glsl", "pixelate.glsl", "blur.glsl", 
    "channels.glsl", "threshold.glsl", "neon.glsl", "edges.glsl", "pixelrolls.glsl", 
    "modcolor.glsl", "halftone.glsl", "halftone_cmyk.glsl", "invert.glsl"};
  PShader shade; 
  int idxShader; 
  long effectTime; 
  
  Apps() {
    idxShader = 8; 
    shade = loadShader(shaders[idxShader]);
    
    // Logo brick dimensions.
    wallWidth = numCols*svgSize; wallHeight = numRows*svgSize; 
    logoWall = createGraphics(svgSize*numCols, svgSize*numRows);
    logos = new ArrayList(); 
    
    prepareAppWall(); 
    
    // Reset times
    shuffleTime = millis(); effectTime = millis();
  }
  
  void run() {
    updateShaderParams(); 
  
    // Should shuffle the apps? 
    if (millis() - shuffleTime > 500) {
     shuffleApps(); 
     shuffleTime = millis(); 
    }
    
    // Should update the effect? 
    //if (millis() - effectTime > 1000) {
    //  idxShader = (idxShader + shaders.length - 1) % shaders.length;
    //  shade = loadShader(shaders[idxShader]); 
    //  effectTime = millis();
    //}
    
    showApps(); 
  }
  
  void showApps() {
    int x = width - wallWidth; int y = height - wallHeight; 
    shader(shade);
    image(logoWall, x/2, y/2);
    resetShader();
  }
  
  void prepareAppWall() {
    // Load all the logos. 
    for (File f : files) {
      // Only load SVG files. 
      String fileName = f.getAbsolutePath(); 
      logos.add(loadShape(fileName)); 
    }
    
    createMask(); 
    drawAppsOffscreen();
  }
 
  void createMask() {
    ellipse = createGraphics(wallWidth, wallHeight); 
    ellipse.beginDraw(); 
    ellipse.background(0);
    ellipse.ellipseMode(CENTER); 
    ellipse.fill(255); 
    noStroke();
    ellipse.smooth();
    ellipse.ellipse(wallWidth/2, wallHeight/2, wallWidth, wallHeight); 
    ellipse.endDraw(); 
  }
  
  void drawAppsOffscreen() {
    logoWall.beginDraw();
      logoWall.fill(0); // Clear
      for (int x = 0; x < numCols; x++) {
       for (int y = 0; y < numRows; y++) {
         int idx = x + numCols * y;
         PShape img = logos.get(idx); 
         logoWall.shape(img, x*svgSize, y*svgSize, svgSize, svgSize); 
       }
      }
    logoWall.endDraw();
    // Do an alpha mask. 
    logoWall.mask(ellipse);
  }

  void shuffleApps() {
    Collections.shuffle(logos);
    drawAppsOffscreen();
  }
  
  void updateShaderParams() 
  {
    // brcosa
    if (idxShader == 0) {
      shade.set("brightness", 1.0);
      shade.set("contrast", map(mouseX, 0, width, -5, 5));
      shade.set("saturation", map(mouseY, 0, height, -5, 5));
    }
  
    // hue
    else if (idxShader == 1) {
      shade.set("hue", map(mouseX, 0, width, 0, TWO_PI));
    } 
  
    // pixelate
    else if (idxShader == 2) {
      shade.set("pixels", 0.1 * mouseX, 0.1 * mouseY);
    } 
  
    // blur
    else if (idxShader == 3) {
      shade.set("sigma", map(mouseX, 0, width, 0, 10.0));
      shade.set("blurSize", (int) map(mouseY, 0, height, 0, 30.0));
      shade.set("texOffset", 1.0, 1.0);
    } 
  
    // channels
    else if (idxShader == 4) {
      shade.set("rbias", 0.0, 0.0);
      shade.set("gbias", map(mouseY, 0, height, -0.2, 0.2), 0.0);
      shade.set("bbias", 0.0, 0.0);
      shade.set("rmult", map(mouseX, 0, width, 0.8, 1.5), 1.0);
      shade.set("gmult", 1.0, 1.0);
      shade.set("bmult", 1.0, 1.0);
    } 
    
    // threshold
    else if (idxShader == 5) {
      shade.set("threshold", map(mouseX, 0, width, 0, 1));
    } 
  
    // neon
    else if (idxShader == 6) {
      shade.set("brt", map(mouseX, 0, width, 0, 0.5));
      shade.set("rad", (int) map(mouseY, 0, height, 0, 3));
    } 
  
    // edges (no parameters)
    else if (idxShader == 7) {
    }
   
    // pixelRolls
    else if (idxShader == 8) {
      shade.set("time", (float) millis()/1000.0);
      shade.set("pixels", mouseX/5, 250.0);
      shade.set("rollRate", map(mouseY, 0, height, 0, 10.0));
      shade.set("rollAmount", 0.25);
    }
  
    // modcolor
    else if (idxShader == 9) {
      shade.set("modr", map(mouseX, 0, width, 0, 0.5));
      shade.set("modg", 0.3);
      shade.set("modb", map(mouseY, 0, height, 0, 0.5));
    }
  
    // halftone
    else if (idxShader == 10) {
      shade.set("pixelsPerRow", (int) map(mouseX, 0, width, 2, 100));
    }
    
    // halftone cmyk
    else if (idxShader == 11) {
      shade.set("density", map(mouseX, 0, width, 0, 1));
      shade.set("frequency", map(mouseY, 0, height, 0, 100));
    }
  
    // inversion (no parameters)
    else if (idxShader == 12) {
    }  
  }
}
