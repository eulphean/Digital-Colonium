class Creature {
  int xPos; int yPos; int curScreen; int prevScreen; 
  int creatureWidth = cellWidth * 2; 
  int creatureHeight = cellWidth * 3; 
  int move = 4; 
  
  Creature() {
    xPos = 0; yPos = 0; curScreen = 0; prevScreen = 0;
  }
  
  void show() {
    fill(0);
    //ellipse(xPos * w, yPos * w, 16, 16);  
    rect(xPos, yPos, creatureWidth, creatureHeight);
  }
  
  void move(int x, int y) {
    int newXPos, newYPos; 
    if (x != 0) {
       // Move left or right
       if (x > 0) {
           newXPos = xPos + move; 
          // Detect collision
          if (!isColliding(newXPos, yPos)) xPos += move;
          // Else, ignore this move. 
       } else {
          // Detect collision
           newXPos = xPos - move;
          if (!isColliding(newXPos, yPos)) xPos -= move;
          // Else, ignore this move. 
       }
    }
    
    if (y != 0) {
       if (y > 0) {
         newYPos = yPos + move; 
         if (!isColliding(xPos, newYPos)) yPos += move; 
         // Else, ignore move
       } else {
         newYPos = yPos - move; 
         if (!isColliding(xPos, newYPos)) yPos -= move; 
         // Else, ignore this move. 
       }
    }

    // Move is done, find what screen did this creature land on. 
    curScreen = getScreenNum(xPos, yPos);
  }
  
  boolean isColliding(int newXPos, int newYPos) {
    // Calculate x boun for the creature
    int xBound = newXPos + creatureWidth;
    int yBound = newYPos + creatureHeight; 
    
    if (newXPos < 0) return true;  // Left wall
    if (newYPos < 0) return true;  // Upper wall 
    if (xBound > worldWidth) return true;  // Right wall
    if (yBound > worldHeight) return true; // Down wall.  
    
    return false;
  }
  
  // Screen style
  //0 1
  //2 3
  //4 5
  //6 7
  //8 9
  // Return the board the creature is on for its xPos and yPos
  int getScreenNum(int xPos, int yPos) {
    int currentScreen = -1;
    if (xPos >= 0 && xPos <=7) {
      // Screen 0
       if (yPos >=0 && yPos <=15) currentScreen = 0; 
       
       // Screen 2
       if (yPos >=16 && yPos <=31) currentScreen = 2; 
       
       // Screen 4
       if (yPos >=32 && yPos <=47) currentScreen = 4; 
       
       // Screen 6
       if (yPos >=48 && yPos <= 63) currentScreen = 6; 
       
       // Screen 8
       if (yPos >=64 && yPos <=79) currentScreen = 8; 
    }
    
    if (xPos >= 8 && xPos <= 15) {
      // Screen 1
       if (yPos >=0 && yPos <=15) currentScreen = 1; 
       
       // Screen 3
       if (yPos >=16 && yPos <=31) currentScreen = 3; 
       
       // Screen 5
       if (yPos >=32 && yPos <=47) currentScreen = 5; 
       
       // Screen 7
       if (yPos >=48 && yPos <= 63) currentScreen = 7; 
       
       // Screen 9
       if (yPos >=64 && yPos <=79) currentScreen = 9; 
    }
    
    //if (currentScreen == -1) {
    //  println("-------It should never come here. There is error--------");
    //}
    
    return currentScreen; 
  }
};