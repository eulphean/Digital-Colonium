class Food {
  ArrayList<PVector> food; // Array of locations
  int foodWidth = 8; int foodHeight = foodWidth; 
  
  Food(int num) {
     // Assign food position within world dimensions. 
     food = new ArrayList();
     for (int i = 0; i < num; i++) {
       food.add(new PVector(random(width-foodWidth), random(height-foodHeight)));
     }
  }
  
  void grow() {
    food.add(new PVector(random(width - foodWidth), random(height-foodHeight))); 
  }
  
  void add(PVector pos) {
    food.add(pos);
  }
  
  void run() {
     // Show food. 
     fill(0, 255, 0);
     for (PVector f: food) {
       rect(f.x, f.y, foodWidth, foodHeight);  
     }
  }
  
  ArrayList getFood() {
     return food;  
  }
}