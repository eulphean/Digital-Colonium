class PixelBrick {
  PVector position; PVector center; 
  int brickW; int brickH; 
  long curTime; float waitTime;
  color pixGrid[][];
  int rows; int cols; int pixWidth;
  
  PixelBrick(PVector pos, int numRows, int numCols, int pWidth) {
    position = pos; 
    rows = numRows; cols = numCols; pixWidth = pWidth; 
    brickW = pixWidth*cols; brickH = pixWidth*rows;
    center = new PVector(position.x+brickW/2, position.y+brickH/2);
    
    // Time to change colors. 
    curTime = millis();
    waitTime = random(500, 1000);
    
    // Create a new grid. 
    pixGrid = new color[cols][rows]; 
    // Create an initial grid of colors. 
    for (int x = 0; x < cols; x++) {
      for (int y = 0; y < rows; y++) {
        pixGrid[x][y] = color(random(255), random(255), random(255));
      }
    }
  }
  
  // Return the radius of a circle that inscribes this square. 
  // Use this to steer the boids away from this brick. 
  float getCircleRad() {
    return sqrt(pow(brickW/2,2)+pow(brickW/2, 2));  
  }
  
  void run() {
    // Only change the color after that time 
    if (millis() - curTime > waitTime) {
      // Create a new set of colors
      for (int x = 0; x < cols; x++) {
        for (int y = 0; y < rows; y++) {
          pixGrid[x][y] = color(random(255), random(255), random(255));
        }
      }
      
      // Reset time. 
      curTime = millis();
    }
    
    // Draw the color grid. 
    pushMatrix();
    translate(position.x, position.y);
    for (int x = 0; x < cols; x++) {
      for (int y = 0; y < rows; y++) {
        stroke(0);
        fill(pixGrid[x][y]);
        rect(pixWidth*x, pixWidth*y, pixWidth, pixWidth);  
      }
    }
    popMatrix();
    
    displayDebug();
  }
  
  void displayDebug() {
    if (debug) {
      // Draw the radius around
      pushStyle();
      stroke(0, 255, 0); 
      strokeWeight(3); 
      ellipseMode(RADIUS);
      fill(255, 255, 255, 0); 
      float radius = getCircleRad();
      ellipse(center.x, center.y, radius, radius);
      popStyle();
    }
  }
}
