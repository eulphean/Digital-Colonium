class Food {
  ArrayList<Flower> flowers; // Natural food
  ArrayList<PixelBrick> bricks; // Media bricks
  
  float scale; 
  
  Food(int num) {
    flowers = new ArrayList();
    bricks = new ArrayList();
    scale = flowerScale; // GUI value
    
    //createBricks(); // These are static. 
    createFlowers(num); // These are random.
  }
  
  void createFlowers(int num) {
   // Dummy flower to calculate the height and width. 
   Flower f = new Flower(new PVector(0, 0), scale); 
   
   for (int i = 0; i < num; i++) {
     PVector position = getNewFlower(f.flowerWidth, f.flowerHeight);
     flowers.add(new Flower(position, scale));
   }
  }
  
  void createBricks() {
    // Maybe I can get all these values from the GUI. 
    int cols = 30; int rows = 30; 
    int pixWidth = 5; 
    int space = 120;
    int w = pixWidth * cols + space; int h = pixWidth * rows;   
    int numBricks = 6;
   
    // Top row
    for (int i = 0; i < numBricks; i++) {
     PVector position = new PVector (190 + i*w, 200); 
     float amp = (1.0 / numBricks);
     bricks.add(new PixelBrick(position, rows, cols, pixWidth, amp)); 
    }
    
    // Bottom row
    for (int i = 0; i < numBricks; i++) {
     PVector position = new PVector (190 + i*w, height-400); 
     float amp = (1.0 / numBricks);
     bricks.add(new PixelBrick(position, rows, cols, pixWidth, amp)); 
    }

  }
  
  PVector getNewFlower(int flowerWidth, int flowerHeight) {
    PVector position; boolean a; 
    
    do {
      position = new PVector(int(random(width-flowerWidth)), int(random(height-flowerHeight))); 
      // Intersecting with another flower or another brick? 
      a = isIntersecting(position, flowerWidth, flowerHeight);
    } while (a); 
    
    return position; 
  }
  
  boolean isIntersecting(PVector position, int w, int h) {
    // Calculate current Flower's dimensions. 
    int newTopRight = int(position.x + w); 
    int newBottom = int(position.y + h);
    
    // Check with all the existing flower.
    for (int i = 0; i < flowers.size(); i++) {
      // Existing Flower dimensions. 
      Flower f = flowers.get(i); 
      int oldTopRight = int(f.position.x + w); 
      int oldBottom = int(f.position.y + h); 
      
      // Compare the two and check if they intensect. 
      boolean a = (oldTopRight > position.x && 
                f.position.x < newTopRight && 
                  oldBottom > position.y && 
                    f.position.y < newBottom); 
     
      // Break and return immediately. 
      if (a) {
        return a;  
      }
    }
    
    // Intersecting with another brick?
    for (int j = 0; j < bricks.size(); j++) {
      PixelBrick brick = bricks.get(j); 
      int brickW = brick.pixWidth * brick.cols; int brickH = brick.pixWidth * brick.rows;  
      int oldTopRight = int(brick.position.x + brickW); 
      int oldBottom = int(brick.position.y + brickH);
      
      boolean a = (oldTopRight > position.x && 
        brick.position.x < newTopRight && 
          oldBottom > position.y && 
            brick.position.y < newBottom); 
      if (a) {
       return a;  
      }
    }
    
    return false; 
  }
  
  void run(ArrayList<Insect> agents) {
   // Show flowers.  
   for (Flower f: flowers) { 
     f.run();
   }
   
   // Show bricks.
   //for (int i = 0; i < bricks.size(); i++) {
   //  bricks.get(i).run(agents);
   //}
  }
}
