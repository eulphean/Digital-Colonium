class PixelBrick {
  PVector position; // Position on the screen
  int rows, cols; // Rows and colums
  int pixWidth; 
  
  PixelBrick(PVector pos, int numRows, int numCols, int pWidth) { //<>//
    position = pos; 
    rows = numRows;
    cols = numCols;
    pixWidth = pWidth; 
  }
  
  void run() {
    // Draw the color grid. 
    pushMatrix();
    translate(position.x, position.y);
    for (int x = 0; x < cols; x++) {
      for (int y = 0; y < rows; y++) {
        stroke(0);
        fill(color(random(255), random(255), random(255)));
        rect(pixWidth*x, pixWidth*y, pixWidth, pixWidth);  
      }
    }
    popMatrix();
  }
  
}
class DigitalFood {
  ArrayList<PixelBrick> digitalFood; 
  
  DigitalFood(int num) {
    int cols = 10; int rows = 10; 
    int pixWidth = 10; 
    
    // Initialize num of PixelBricks
    digitalFood = new ArrayList(); 
    PVector position;
    for (int i = 0; i < num; i++) {
      // Keep creating a random position till the time we get a clean position
      // that doesn't intersect with another brick. 
      do {
        position =  new PVector(int(random(width - pixWidth*cols)), int(random((int) height - pixWidth*rows))); 
      } while (isIntersecting(position, rows, cols, pixWidth)); 
      
      digitalFood.add(new PixelBrick(position, rows, cols, pixWidth));
    }
    
  }
  
  void run() {
    for (int i = 0; i < digitalFood.size(); i++) {
      digitalFood.get(i).run();
    }
  }
  
  boolean isIntersecting(PVector position, int rows, int cols, int pixWidth) {
    // Check to see if the two rectangles intersect
    
    // Calculate current Pixel Brick's dimensions. 
    int newPBTopRight = int(position.x + pixWidth*cols); 
    int newPBBottom = int(position.y + pixWidth*rows);
    
    for (int i = 0; i < digitalFood.size(); i++) {
      // Existing PixelBrick dimensions. 
      PixelBrick pB = digitalFood.get(i); 
      int pBTopRight = int(pB.position.x + pB.pixWidth*pB.cols); 
      int pBBottom = int(pB.position.y + pB.pixWidth*pB.cols); 
      
      // Compare the two and check if they intensect. 
      boolean a = (pBTopRight > position.x && pB.position.x < newPBTopRight && pBBottom > position.y && pB.position.y < newPBBottom); 
     
      // Break and return immediately. 
      if (a) {
        return a;  
      }
    }
    
    return false; 
    
    // Collision condition.
    // if(rectOneRight > rectTwoLeft && rectOneLeft < rectTwoRight && rectOneBottom > rectTwoTop && rectOneTop < rectTwoBottom){
  }
}

int numPixelBricks = 8; 
DigitalFood mediaFood; 

// Before making the next pixel brick, 
void setup() {
  fullScreen();
   mediaFood = new DigitalFood(numPixelBricks); 
}

void draw() {
  background(0);
  mediaFood.run(); 
  println(frameRate);
}
