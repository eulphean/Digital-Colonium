// Natural food. 
class Flower {
  PVector position; 
  int rot;
  int flowerHeight; int flowerWidth; 
  float scale; 
  
  PShape icon; PShader shade; PGraphics head;
  PVector centerHead; PVector base; 
  
  // Get center flower radius and position to calculate
  // the intersection box/radius for the circle
  
  Flower(PVector pos, float s) {    
    // Load a random svg and draw that. 
    rot = 0; 
    scale = s; 
    position = pos; 
    flowerHeight = int(70*s);
    flowerWidth = int(50*s);
    centerHead = new PVector(flowerWidth/2, flowerHeight/3); 
    base = new PVector(centerHead.x, flowerHeight);
      
    // Get a random icon and set that as the PShape icon. 
    int randIdx = floor(random(0, icons.size())); 
    icon = icons.get(randIdx); 
    
    // Load a shader
    idxShader = 1; 
    shade = loadShader(shaders[idxShader]);
    head = createGraphics(flowerWidth, flowerWidth); 
    head.beginDraw();
    head.fill(0); 
    head.shape(icon,0, 0, flowerWidth, flowerWidth);  
    head.endDraw();
  }
  
  void run() {
    pushMatrix();
      translate(position.x, position.y);
      scale(scale, scale);
      
      // Draw the bounding box
      // Enable this for debugging. 
      //stroke(255, 0, 0); 
      //strokeWeight(2);
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
      strokeWeight(10);
      strokeCap(SQUARE);
      line(centerHead.x, centerHead.y, base.x, base.y); 
      popStyle();
      
      // Icon
      pushMatrix(); 
       translate(centerHead.x - flowerWidth/2, centerHead.y - flowerHeight/3); 
       shader(shade);
       image(head, 0, 0); 
       resetShader();
      popMatrix();
    popMatrix();
  } 
}

Flower f; 
ArrayList<PShape> icons; 
String[] shaders = new String[] {
  "brcosa.glsl", "hue.glsl", "pixelate.glsl", "blur.glsl", 
  "channels.glsl", "threshold.glsl", "neon.glsl", "edges.glsl", "pixelrolls.glsl", 
  "modcolor.glsl", "halftone.glsl", "halftone_cmyk.glsl", "invert.glsl"}; 
  
int idxShader;

void setup() {
  size(500, 500, P2D); 
  
  icons = new ArrayList();
  loadIcons();
  f = new Flower(new PVector(100, 100), 0.80); 
}

void draw() {
  background(255); 
  updateShaderParams(); 
  
  // Draw the flower
  f.run(); 
}

void loadIcons() {
  String path = dataPath("SVG"); 
  File [] files = listFiles(path);
  for (File f : files) {
    // Only load SVG files. 
    String fileName = f.getAbsolutePath(); 
    icons.add(loadShape(fileName)); 
  }
}

void updateShaderParams() {
  PShader shade = f.shade; 
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
