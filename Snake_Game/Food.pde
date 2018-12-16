class Food { 
  int xPos, yPos;
  
  Food() {
    // Outer corners are the boundary
    // Take that into account when creating food position.
    xPos = (int) random(1, numCols - 2) * cellWidth;
    yPos = (int) random(1, numRows - 2) * cellWidth;
  }
  
  boolean isEaten(Snake s) {
    // Check if the food should be consumed with creature's new position. 
    int foodTopRight = xPos + cellWidth; 
    int foodBottom = yPos + cellWidth;
    
    // Head should intersect with the food for it to be consumed. 
    PVector snakeHead = s.shape.get(0);
    int snakeTopRight = (int) snakeHead.x + cellWidth;
    int snakeBottom = (int) snakeHead.y + cellWidth; 
    
    // Collision condition.
    // if(rectOneRight > rectTwoLeft && rectOneLeft < rectTwoRight && rectOneBottom > rectTwoTop && rectOneTop < rectTwoBottom){
    boolean a = snakeTopRight > xPos && snakeHead.x < foodTopRight && snakeBottom > yPos && snakeHead.y < foodBottom;
    return a;
  }
  
  void show() {
    fill(0, 0, 255); 
    rect(xPos, yPos, cellWidth, cellWidth);
  }
}