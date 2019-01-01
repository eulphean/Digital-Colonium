// Brick stuff. 
ArrayList<PShape> logos; 
PGraphics logoWall; 
PGraphics ellipse; 
int numRows = 5; int numCols = 12; 
int svgSize = 60; // width = height
int wallWidth; int wallHeight;

// Shader stuff.
// All the shaders. Shortlist which ones to keep for the final version. 
String[] shaders = new String[] {
  "brcosa.glsl", "hue.glsl", "pixelate.glsl", "blur.glsl", 
  "channels.glsl", "threshold.glsl", "neon.glsl", "edges.glsl", "pixelrolls.glsl", "patches.glsl", 
  "modcolor.glsl", "halftone.glsl", "halftone_cmyk.glsl", "invert.glsl"};
PShader shade1; PShader shade2; PShader shade; 
int idxShader; 
  
void setup() {
  fullScreen(P2D);
  
  idxShader = 0; 
  shade = loadShader(shaders[idxShader]);
  
  // Logo brick dimensions. 
  wallWidth = numCols*svgSize; wallHeight = numRows*svgSize; 
  createMask();
  createLogoWall(); 
    
  // Do an alpha mask. 
  logoWall.mask(ellipse);
  
  smooth();
}

void draw() {
  background(0);
  updateShaderParams(); 
  
  int x = width - wallWidth; int y = height - wallHeight; 
  
  shader(shade);
  image(logoWall, x/2, y/2);
  resetShader();
}

void keyPressed() {
  if (keyCode == LEFT) {
    idxShader = (idxShader + shaders.length - 1) % shaders.length; 
  }
  
  if (keyCode == RIGHT) {
    idxShader = (idxShader + 1) % shaders.length;
  }
  
  // Load the correct shader based on the index. 
  shade = loadShader(shaders[idxShader]); 
  
  println(shaders[idxShader]);
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

  // patches
  else if (idxShader == 9) {
    shade.set("row", map(mouseX, 0, width, 0, 1));
    shade.set("col", map(mouseY, 0, height, 0, 1));
  }

  // modcolor
  else if (idxShader == 10) {
    shade.set("modr", map(mouseX, 0, width, 0, 0.5));
    shade.set("modg", 0.3);
    shade.set("modb", map(mouseY, 0, height, 0, 0.5));
  }

  // halftone
  else if (idxShader == 11) {
    shade.set("pixelsPerRow", (int) map(mouseX, 0, width, 2, 100));
  }
  
  // halftone cmyk
  else if (idxShader == 12) {
    shade.set("density", map(mouseX, 0, width, 0, 1));
    shade.set("frequency", map(mouseY, 0, height, 0, 100));
  }

  // inversion (no parameters)
  else if (idxShader == 13) {
  }  
}

void createMask() {
  int maskWidth = svgSize*numCols; int maskHeight = svgSize*numRows; 
  ellipse = createGraphics(maskWidth, maskHeight); 
  ellipse.beginDraw(); 
  ellipse.background(0);
  ellipse.ellipseMode(CENTER); 
  ellipse.fill(255); 
  noStroke();
  ellipse.smooth();
  ellipse.ellipse(maskWidth/2, maskHeight/2, maskWidth, maskHeight); 
  ellipse.endDraw(); 
}

void createLogoWall() {
  logoWall = createGraphics(svgSize*numCols, svgSize*numRows);
  logos = new ArrayList(); 
  
  loadLogos();
  drawLogos();
}
void loadLogos() {
  String path = dataPath(""); 
  File [] files = listFiles(path); 
  for (File f : files) {
    String fileName = f.getName(); 
    logos.add(loadShape(fileName)); 
  }
}

void drawLogos() {
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
}
