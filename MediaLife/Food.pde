class Food {
  // Natural food. 
  ArrayList<Flower> food;
  int flowerWidth; int flowerHeight; 
  
  Food(int num) {
     // Assign food position within world dimensions. 
     // Create no overlapping food. 
     food = new ArrayList();
     
     // Create a dummy flower to get the bounding box to create multiple others. 
     PVector position = new PVector(0, 0); 
     Flower f = new Flower(position, 0.2); 
    
     // Create a list of non-intersecting flowers.   
     flowerWidth = int(f.getBoundingBox().width); flowerHeight = int(f.getBoundingBox().height); 
     for (int i = 0; i < num; i++) {
       do {
         position = new PVector(int(random(width-flowerWidth)), int(random(flowerHeight/2, height-flowerHeight)));
       } while (isIntersecting(position, flowerWidth, flowerHeight)); 
       
       food.add(new Flower(position, 0.2));
     }
  }
  
  boolean isIntersecting(PVector position, int w, int h) {
    // Calculate current Flower's dimensions. 
    PVector newFoodRect = new PVector(position.x - w/2, position.y - h/2);
    int newFoodTopRight = int(newFoodRect.x + w); 
    int newFoodBottom = int(newFoodRect.y + h/2);
    
    for (int i = 0; i < food.size(); i++) {
      // Existing Flower dimensions. 
      Flower f = food.get(i); 
      PVector foodRect = new PVector(f.position.x - w/2, f.position.y - h/2);
      int foodRectTopRight = int(foodRect.x + w/2); 
      int foodRectBottom = int(foodRect.y + h/2); 
      
      // Compare the two and check if they intensect. 
      boolean a = (foodRectTopRight > newFoodRect.x && 
                foodRect.x < newFoodTopRight && 
                  foodRectBottom > newFoodRect.y && 
                    foodRect.y < newFoodBottom); 
     
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
