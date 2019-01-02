// Natural food. 
class Flower {
  PVector position; 
  int rot;
  int flowerHeight; int flowerWidth; 
  float scale; 
  color petalColor;
  PGraphics h; PShape icon; 
  PVector centerHead, base;
  PShader shade; int idxShader;
  
  Flower(PVector pos, float s) {
    rot = 0; 
    scale = s; 
    position = pos; 
    flowerHeight = int(70*s);
    flowerWidth = int(50*s);
    petalColor = color(random(255), random(255), random(255));
    centerHead = new PVector(flowerWidth/2, flowerHeight/3); 
    base = new PVector(centerHead.x, flowerHeight);
    
    // Icon (PGraphics)
    createHead(); 
    
    // Shader 
    idxShader = floor(random(shaders.length-1));
    shade = loadShader(shaders[idxShader]); 
  }
  
  void createHead() {
    int randIdx = floor(random(0, files.length)); 
    icon = loadShape(files[randIdx].getAbsolutePath()); 
    h = createGraphics(flowerWidth, flowerWidth); 
    h.beginDraw();
    h.fill(0); 
    h.shape(icon,0, 0, flowerWidth, flowerWidth);  
    h.endDraw();
  }
  
  void run() {
    updateShaderParams();
    pushMatrix();
      pushStyle();
      translate(position.x, position.y);
      scale(scale, scale);
      
      //// Draw the bounding box
      //// Enable this for debugging. 
      //color c = color(255, 255, 255, 0); 
      //fill(c);
      //stroke(0); 
      
      //rect(0, 0, flowerWidth, flowerHeight); 
      
      // Smooth flower face. 
      noStroke();
      
      ellipseMode(CORNER);
      // Left leaf.
      pushMatrix(); 
      translate(base.x, base.y); 
        rotate(radians(200)); 
        fill(0, 255, 0);
        ellipse(0, 0, flowerWidth/2, flowerHeight/9);
      popMatrix();
      
      // Right leaf. 
      pushMatrix(); 
      translate(base.x, base.y); 
        rotate(radians(-20));
        fill(0, 255, 0);
        ellipse(0, -flowerHeight/9, flowerWidth/2, flowerHeight/9);
      popMatrix();
      
      // Stem.
      pushStyle();
      stroke(0, 153, 0);
      strokeWeight(6);
      strokeCap(SQUARE);
      line(centerHead.x, centerHead.y, base.x, base.y); 
      popStyle();
      
      pushMatrix(); 
       translate(centerHead.x - flowerWidth/2, centerHead.y - flowerHeight/3); 
       shader(shade);
       image(h, 0, 0); 
       resetShader();
      popMatrix();
      popStyle();
    popMatrix();
  } 
  
  void updateShaderParams() 
  {
    float offset = 2*PI; 
    float x = cos(frameCount/offset); float y = sin(frameCount/offset); 
    // brcosa
    if (idxShader == 0) {
      shade.set("brightness", 1.0);
      shade.set("contrast", map(x, -1, 1, -5, 5));
      shade.set("saturation", map(y, -1, 1, -5, 5));
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
      shade.set("rbias", 0.0, 0.0);
      shade.set("gbias", map(y, -1, 1, -0.2, 0.2), 0.0);
      shade.set("bbias", 0.0, 0.0);
      shade.set("rmult", map(x, -1, 1, 0.8, 1.5), 1.0);
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
      shade.set("time", (float) millis()/1000.0);
      shade.set("pixels", x*width, 250.0);
      shade.set("rollRate", map(y, -1, 1, 0, 2.0));
      shade.set("rollAmount", 0.15);
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
