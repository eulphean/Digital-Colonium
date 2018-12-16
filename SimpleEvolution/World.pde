class World {
    Creature c; 
    ArrayList<Food> food;
    
    int numCols = worldWidth/cellWidth; int numRows = worldHeight/cellWidth; 

    // Microcontroller screens (World will be divided into screens)
    // Let's ignore that for a bit. 
    int numScreenCols = 2; int numScreenRows = 5; 
    int screenWidth = 64; int screenHeight = 128; // Dimension of each screen. 

    World() {
        c = new Creature();
        
        // Create a default number of food objects on the screen. 
        food = new ArrayList();  
        for (int i = 0; i < 50; i++) {
           // Create the food on a grid cell
           // TODO, if a food is already on a grid cell, create it somewhere else. 
           createNewFood();
        }
    }
    
    void update() {
      // Update food with creature's new position
      for (int i = food.size()-1; i >= 0; i--) {
         if (food.get(i).isColliding(c)) {
            food.remove(i); // Remove the food from the array that has been collided
            //createNewFood();
         }
      }
    }

    void show() {
      if (showColoredDivision) {
        // Red outline for the screens
        for (int x = 0; x < numScreenCols; x++) {
            for (int y = 0; y < numScreenRows; y++) {
                int a = 255 / (x+y+1);
                color c = color(a, a*2, a*3); // Red outline
                fill(c);
                rect(x*screenWidth, y*screenHeight, screenWidth, screenHeight);
            }
        }
      }
          
      if (showGrid) {
        // Draw the board. 
        for (int y = 0; y < numRows; y++) {
            for (int x = 0; x < numCols; x++) {
                noFill();
                rect(x*cellWidth, y*cellWidth, cellWidth, cellWidth);
            }
        }
      }
      
      // Show all the food. 
      if (showFood) {
        for (int i = 0; i < food.size(); i++) {
          food.get(i).show(); 
        }
      }

      // Show creature
      c.show();
    }
    
    void createNewFood() {
      int xFood = (int) random(0, numRows); int yFood = (int) random(0, numCols);
      food.add(new Food(xFood, yFood)); 
    }
    
    void moveCreature(int x, int y) {
       c.move(x, y);
       
       // Send data to microcontrollers. 
       // int newPos[] = getPositionForScreens();
       //String toTransmit = c.curScreen + "," + newPos[0] + "," + newPos[1]; 
       //// Before screen change logic, send the screen number
       //if (c.curScreen != c.prevScreen) {
       //  // Send the prev screen as well.
       //  toTransmit += "," + c.prevScreen + "."; 
    
       //  // Next time we send a blank for the prev screen so we don't use it. 
       //  c.prevScreen = c.curScreen; 
       //} else {
       //  // Some arbitrary large number
       //  toTransmit += "," + 100 + "."; // End the transmission string.  
       //}
    }
    
    int [] getPositionForScreens() {
      int [] newPos = new int[2];
      switch (c.curScreen) {
         case 0: {
           newPos[0] = c.xPos; newPos[1] = c.yPos; 
           break;
         }
         
        case 1: {
         newPos[0] = c.xPos - 8; newPos[1] = c.yPos; 
         break;
       }
         
        case 2: {
         newPos[0] = c.xPos; newPos[1] = c.yPos - 16; 
         break;
       }
       
        case 3: {
         newPos[0] = c.xPos - 8; newPos[1] = c.yPos - 16; 
         break;
       }
       
       case 4: {
         newPos[0] = c.xPos; newPos[1] = c.yPos - 32; 
         break;
       }
       
       case 5: {
         newPos[0] = c.xPos - 8; newPos[1] = c.yPos - 32; 
         break;
       }
       
       case 6: {
         newPos[0] = c.xPos; newPos[1] = c.yPos - 48; 
         break;
       }
       
        case 7: {
         newPos[0] = c.xPos - 8; newPos[1] = c.yPos - 48; 
         break;
       }
        
       case 8: {
         newPos[0] = c.xPos; newPos[1] = c.yPos - 64; 
         break;
       }
       
       case 9: {
         newPos[0] = c.xPos - 8; newPos[1] = c.yPos - 64; 
         break;
       }
      
       default: {
         break;
       }
      }
      return newPos; 
    }
}