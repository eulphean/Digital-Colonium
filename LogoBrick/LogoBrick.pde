// Logo brick with all the social media icons. 
// Load images. Right now, we have 50 images and arrange them
// in a grid. Then mask it with an ellipse. 
// Then add visual effects. 

ArrayList<PShape> logos; 
PGraphics logoWall; 
int numRows = 6; int numCols = 11; 
int svgSize = 90; // width = height
void setup() {
  fullScreen(P2D);
  
  // Create the logo wall in a virtual window.  
  createLogoWall(); 
  
  smooth();
}

void draw() {
  background(0);
  
  int wallWidth = numCols*svgSize; int wallHeight = numRows*svgSize; 
  int x = width - wallWidth; int y = height - wallHeight; 
  // Calculate the coordinates to put the fbo at. 
  image(logoWall, x/2, y/2);
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
