class Snake {
  // Representing the snake
  ArrayList<PVector> shape = new ArrayList<PVector>();
  int dx, dy;
  Direction curDirection;
  color c;
  long curVel; long curTime;
  // As the snake's length increases, this update time increases. 
  
  Snake() {
    // Set a random snake on canvas
    // Takes a row and column on the grid
    // Each cell of the snake is equivalent to the width
    // of the grid cell.  
    PVector head = new PVector(4, 4); 
    
    c = color((int)random(255),(int)random(255), (int)random(255));
    
    // Go right.
    curDirection = Direction.Right;
    
    // For right direction
    dx = 1; 
    dy = 0; 
    
    // Cur time and velocity
    curTime = 0;
    curVel = 50; 
    
    // Default snake length is 3
    shape.add(new PVector(head.x * cellWidth, head.y * cellWidth));
    shape.add(new PVector((head.x -1)* cellWidth, head.y * cellWidth));
    shape.add(new PVector((head.x - 2) * cellWidth, head.y * cellWidth));
  }
  
  boolean advance() {
    // Based on the current displacement, figure out the direction
    // in which the snake is moving
    boolean goingUp = (dy == -1); boolean goingDown = (dy == 1);
    boolean goingLeft = (dx == -1); boolean goingRight = (dx == 1);
    
    //// Snake shouldn't reverse direction with the keys. Rest, all is fine. 
    if (curDirection == Direction.Left && !goingRight) {
      dx = -1; dy = 0;
    }
    if (curDirection == Direction.Right && !goingLeft) { 
      dx = 1; dy = 0; 
    }
    if (curDirection == Direction.Up && !goingDown) {
      dx = 0; dy = -1;
    }
    if (curDirection == Direction.Down && !goingUp) { 
      dx = 0; dy = 1; 
    }
    
    // Displace the snake. 
    PVector tail = shape.get(shape.size() - 1); 
    PVector head = shape.get(0); 
    
    // New head's position
    tail.x = head.x + dx * cellWidth;
    tail.y = head.y + dy * cellWidth; 
    
    // Check if this tail node is colliding with the boundaries
    if (isCollidingWithWalls(tail)) {
      return false; 
    } else if (isCollidingWithItself()) {
      return false; 
    } else {
      // Remove the tail and add it back upfront. 
      shape.remove(tail); 
      shape.add(0, tail);
      return true;
    }
  }
  
  boolean isCollidingWithWalls(PVector head) {
    // Raw vector position on the board
    int xPos = (int) head.x; int yPos = (int) head.y; 

    int snakeRight = xPos + cellWidth; int snakeBottom = yPos + cellWidth; 
    
    // CellWidth is for the boundary of the wall.
    if (xPos < cellWidth) return true;  // Left wall
    if (yPos < cellWidth) return true;  // Upper wall 
    
    if (snakeRight > boardWidth-cellWidth) return true;  // Right wall
    if (snakeBottom > boardHeight-cellWidth) return true; // Down wall.  
    
    return false;
  }
  
  boolean isCollidingWithItself() {
    // run collision logic 
    PVector head = shape.get(0);
    int headTopRight = (int) head.x + cellWidth; 
    int headBottom = (int) head.y + cellWidth; 
    
    for (int i = 1; i < shape.size(); i++) {
       PVector cell = shape.get(i);
       int cellTopRight = (int) cell.x + cellWidth; 
       int cellBottom = (int) cell.y + cellWidth; 
       
       // Collision condition. 
       //if(rectOneRight > rectTwoLeft && rectOneLeft < rectTwoRight && rectOneBottom > rectTwoTop && rectOneTop < rectTwoBottom){
       boolean a = headTopRight > cell.x && head.x < cellTopRight && headBottom > cell.y && head.y < cellBottom;
       if (a) {
         return true; 
       }
    }
    return false;
  }
  
  void show() {
    // Show the array list
    for (int i = 0; i < shape.size(); i++) {
      fill(c);
      rect(shape.get(i).x, shape.get(i).y, cellWidth, cellWidth);  
    }
  }
  
  void setDirection(Direction newDir) {
    curDirection = newDir;
  }
  
  void growSnake() {
    PVector head = shape.get(0);
    PVector newCell = new PVector(); 
    
    if (curDirection == Direction.Up) {
      newCell.x = head.x; newCell.y = head.y - cellWidth;
    }
    
    if (curDirection == Direction.Down) {
      newCell.x = head.x; newCell.y = head.y + cellWidth; 
    }
    
    if (curDirection == Direction.Left) {
      newCell.x = head.x - cellWidth; newCell.y = head.y;
    }
    
    if (curDirection == Direction.Right) {
      newCell.x = head.x + cellWidth; newCell.y = head.y;
    }
    
    shape.add(0, newCell);
    
    // Update velocity of the snake as compared to the 
    // length
    curVel = (long) map(shape.size(), 3, 20, 50, 100);
  }
}