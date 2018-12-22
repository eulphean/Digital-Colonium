// Media food that the agents will be able to eat. 
class DigitalFood {
  ArrayList<PixelBrick> digitalFood; 
  
  DigitalFood(int num) {
    // Ignore num for now. 
    // TODO: cleanup. 
    
    int cols = 8; int rows = 20; 
    int pixWidth = 10; 
    
    int w = pixWidth * cols + 48; int h = pixWidth * rows; 
    int newNum = width/w; // These many media bricks. But I need some space in between. 
    
    digitalFood = new ArrayList(); 
    // Starting x position = 0 then w
    // Start y position = height/2 - h/2
    float yPos = height/2 - h/2; 
    for (int i = 0; i < newNum; i++) {
     PVector position = new PVector (i*w, yPos); 
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

//PVector position;
//for (int i = 0; i < num; i++) {
//  // Keep creating a random position till the time we get a clean position
//  // that doesn't intersect with another f
//  do {
//    position = new PVector(int(random(width - pixWidth*cols)), int(random((int) height - pixWidth*rows))); 
//  } while (isIntersecting(position, rows, cols, pixWidth)); 
  
//  digitalFood.add(new PixelBrick(position, rows, cols, pixWidth));
//}
