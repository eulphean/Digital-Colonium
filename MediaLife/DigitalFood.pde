// Media food that the agents will be able to eat. 
class DigitalFood {
  ArrayList<PixelBrick> digitalFood; 
  
  DigitalFood(int num) {
    int cols = 5; int rows = 5; 
    int pixWidth = 9; 
    
    // Initialize num of PixelBricks
    digitalFood = new ArrayList(); 
    PVector position;
    for (int i = 0; i < num; i++) {
      // Keep creating a random position till the time we get a clean position
      // that doesn't intersect with another flower.
      do {
        position = new PVector(int(random(width - pixWidth*cols)), int(random((int) height - pixWidth*rows))); 
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
  }
}
