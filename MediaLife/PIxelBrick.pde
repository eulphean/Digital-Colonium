class PixelBrick {
  PVector position; // Position on the screen
  int rows, cols; // Rows and colums
  int pixWidth; 
  long curTime; 
  color pixGrid[][];
  float waitTime; 
  
  PixelBrick(PVector pos, int numRows, int numCols, int pWidth) {
    position = pos; 
    rows = numRows;
    cols = numCols;
    pixWidth = pWidth; 
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
      ellipse(position.x + pixWidth*cols/2, position.y + pixWidth*rows/2, pixWidth*cols/2+20, pixWidth*rows/2+20);
      popStyle();
    }
  }
}
