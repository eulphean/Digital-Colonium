class Food {
  // Natural food. 
  ArrayList<Flower> food;
  
  Food(int num) {
     food = new ArrayList();
     
     float scale = 0.6; 
     // Dummy flower to calculate the height and width. 
     Flower f = new Flower(new PVector(0, 0), scale); 

     PVector position;      
     // Create a list of non-intersecting flowers.   
     for (int i = 0; i < num; i++) {
       do {
         position = new PVector(int(random(width-f.flowerWidth)), int(random(height-f.flowerHeight))); 
       } while (isIntersecting(position, f.flowerWidth, f.flowerHeight)); 
       
       food.add(new Flower(position, scale));
     }
  }
  
  boolean isIntersecting(PVector position, int w, int h) {
    // Calculate current Flower's dimensions. 
    int newTopRight = int(position.x + w); 
    int newBottom = int(position.y + h);
    
    for (int i = 0; i < food.size(); i++) {
      // Existing Flower dimensions. 
      Flower f = food.get(i); 
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
    
    return false; 
  }
  
  void grow() {
    // food.add(new PVector(random(width - foodWidth), random(height-foodHeight))); 
  }
  
  void add(PVector pos) {
    // food.add(pos);
  }
  
  void run() {
     // Show food. 
   for (Flower f: food) {
     //rect(f.x, f.y, foodWidth, foodHeight);  
     f.run();
   }
  }
  
  ArrayList getFood() {
     return food;  
  }
}
