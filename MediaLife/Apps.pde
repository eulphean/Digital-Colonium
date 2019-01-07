import java.util.Collections; 
  
class Apps {
  // Brick stuff. 
  ArrayList<Icon> icons; 
  PGraphics logoWall; 
  PGraphics ellipse; 
  int numRows = 4; int numCols = 20; 
  int svgSize = 60; // width = height
  int wallWidth; int wallHeight;
  long shuffleTime; 
  
  Shade shader; 
  int idxShader; 
  long effectTime; 
  
  Apps() {
    // Get the shader at specific index. 
    idxShader = 4; 
    shader = shaderFactory.getShaderAtIdx(idxShader); 
    
    // Logo brick dimensions.
    wallWidth = numCols*svgSize; wallHeight = numRows*svgSize; 
    logoWall = createGraphics(svgSize*numCols, svgSize*numRows);
    icons = iconFactory.getAllIcons(); 
    
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
    //if (millis() - effectTime > 5000) {
    //  //idxShader = (idxShader + shaders.length - 1) % shaders.length;'
    //  //idxShader = floor(random(shaders.length-1));
    //  effectTime = millis();
    //}
    
    showApps(); 
  }
  
  void showApps() {
    int x = width - wallWidth; int y = height - wallHeight; 
    shader(shader.shade);
    image(logoWall, x/2, y/2);
    resetShader();
  }
  
  void prepareAppWall() {    
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
         PShape img = icons.get(idx).ic;  
         logoWall.shape(img, x*svgSize, y*svgSize, svgSize, svgSize); 
       }
      }
    logoWall.endDraw();
    // Do an alpha mask. 
    logoWall.mask(ellipse);
  }

  void shuffleApps() {
    Collections.shuffle(icons);
    drawAppsOffscreen();
  }
  
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
  
  //void updateShaderParams() 
  //{
  //  // brcosa
  //  if (idxShader == 0) {
  //    shade.set("brightness", 1.0);
  //    shade.set("contrast", map(mouseX, 0, width, -5, 5));
  //    shade.set("saturation", map(mouseY, 0, height, -5, 5));
  //  }
  
  //  // hue
  //  else if (idxShader == 1) {
  //    shade.set("hue", map(mouseX, 0, width, 0, TWO_PI));
  //  } 
  
  //  // pixelate
  //  else if (idxShader == 2) {
  //    shade.set("pixels", 0.1 * mouseX, 0.1 * mouseY);
  //  } 
  
  //  // blur
  //  else if (idxShader == 3) {
  //    shade.set("sigma", map(mouseX, 0, width, 0, 10.0));
  //    shade.set("blurSize", (int) map(mouseY, 0, height, 0, 30.0));
  //    shade.set("texOffset", 1.0, 1.0);
  //  } 
  
  //  // channels
  //  else if (idxShader == 4) {
  //    shade.set("rbias", 0.0, 0.0);
  //    shade.set("gbias", map(mouseY, 0, height, -0.2, 0.2), 0.0);
  //    shade.set("bbias", 0.0, 0.0);
  //    shade.set("rmult", map(mouseX, 0, width, 0.8, 1.5), 1.0);
  //    shade.set("gmult", 1.0, 1.0);
  //    shade.set("bmult", 1.0, 1.0);
  //  } 
    
  //  // threshold
  //  else if (idxShader == 5) {
  //    shade.set("threshold", map(mouseX, 0, width, 0, 1));
  //  } 
  
  //  // neon
  //  else if (idxShader == 6) {
  //    shade.set("brt", map(mouseX, 0, width, 0, 0.5));
  //    shade.set("rad", (int) map(mouseY, 0, height, 0, 3));
  //  } 
  
  //  // edges (no parameters)
  //  else if (idxShader == 7) {
  //  }
   
  //  // pixelRolls
  //  else if (idxShader == 8) {
  //    shade.set("time", (float) millis()/1000.0);
  //    shade.set("pixels", mouseX/5, 250.0);
  //    shade.set("rollRate", map(mouseY, 0, height, 0, 10.0));
  //    shade.set("rollAmount", 0.25);
  //  }
  
  //  // modcolor
  //  else if (idxShader == 9) {
  //    shade.set("modr", map(mouseX, 0, width, 0, 0.5));
  //    shade.set("modg", 0.3);
  //    shade.set("modb", map(mouseY, 0, height, 0, 0.5));
  //  }
  
  //  // halftone
  //  else if (idxShader == 10) {
  //    shade.set("pixelsPerRow", (int) map(mouseX, 0, width, 2, 100));
  //  }
    
  //  // halftone cmyk
  //  else if (idxShader == 11) {
  //    shade.set("density", map(mouseX, 0, width, 0, 1));
  //    shade.set("frequency", map(mouseY, 0, height, 0, 100));
  //  }
  
  //  // inversion (no parameters)
  //  else if (idxShader == 12) {
  //  }  
  //}
}
