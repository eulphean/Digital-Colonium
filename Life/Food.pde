class Food {
  int xPos; int yPos; 
  int foodWidth = cellWidth; int foodHeight = foodWidth;
  
  Food(int numRow, int numCol) {
     // Assign food position within world dimensions. 
     xPos = numCol * cellWidth; 
     yPos = numRow * cellWidth;
  }
  
  boolean isColliding(Creature c) {
    // Check if the food should be consumed with creature's new position. 
    int foodTopRight = xPos + foodWidth; 
    int foodBottom = yPos + foodHeight;
    
    int creatureTopRight = c.xPos + c.creatureWidth;
    int creatureBottom = c.yPos + c.creatureHeight; 
    
    // Collision condition.
    // if(rectOneRight > rectTwoLeft && rectOneLeft < rectTwoRight && rectOneBottom > rectTwoTop && rectOneTop < rectTwoBottom){
    boolean a = creatureTopRight > xPos && c.xPos < foodTopRight && creatureBottom > yPos && c.yPos < foodBottom;
    if (a) println(a);
    return a;
  }
  
  void show() {
     fill(0);
     rect(xPos, yPos, foodWidth, foodHeight);
  }
}