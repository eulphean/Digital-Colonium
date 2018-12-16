int boardWidth = 128; 
int boardHeight = 64; 
int cellWidth = 4; 
int numCols = boardWidth / cellWidth; 
int numRows = boardHeight / cellWidth; 

boolean showGrid = true; 

// Set of all the directions a snake can go. 
// Based on 0,0 that starts on top left of the board.
//  |> Right (1, 0)   |
//  |< Left  (-1, 0)  |
//  |v Down  (0, 1)   |
//  |^ Up    (0, -1)  |

enum Direction {
  Up, 
  Down,
  Left, 
  Right
};

// Snake
Snake snake;

// Food 
ArrayList<Food> allthefood = new ArrayList<Food>();
int numFoodPieces = 5; 
void setup() {
  size(200, 200);
  
  createWorld();
}

void draw() {
  // Clear screen with every loop.
  background(255);
  
  // Update methods. 
  if ( millis() - snake.curTime > snake.curVel) {
    if (!snake.advance()) {
      // Create a new snake if the snake has collided 
      // with something. 
      createWorld();
    }
    
    snake.curTime = millis();
  }
  
  // Has food been eaten?
  for (int i = allthefood.size() -1; i >= 0; i--) {
    if (allthefood.get(i).isEaten(snake)) {
      allthefood.remove(i);
      allthefood.add(new Food()); // Add a new food randomly. 
      snake.growSnake();
    }
  }

  // Draw methods.  
  snake.show();
  
  if (showGrid) {
    for (int y = 0; y < numRows; y++) {
       for (int x = 0; x < numCols; x++) {
          noFill();
          rect(x*cellWidth, y*cellWidth, cellWidth, cellWidth);
       }
    }
  }
  
  // Left and right boundary
  for (int y = 0; y < numRows; y++) {
    fill(255, 0, 0);
    rect(0, y*cellWidth, cellWidth, cellWidth); 
    rect((numCols - 1)*cellWidth, y*cellWidth, cellWidth, cellWidth);
  }
  
  // Top and bottom boundary
  for (int x = 0; x < numCols; x++) {
    fill(255, 0, 0);
    rect(x*cellWidth, 0, cellWidth, cellWidth); 
    rect(x*cellWidth, (numRows-1)*cellWidth, cellWidth, cellWidth);
  }
  
  // Draw the food
  for (int i = 0; i < allthefood.size(); i++) {
     allthefood.get(i).show(); 
  }
}

void createWorld() {
  // Create snake
  snake = new Snake();
  
  // Empty food. 
  allthefood.clear();
  
  // Create food pieces
  for (int i = 0; i < numFoodPieces; i++) {
     allthefood.add(new Food());  
  }
  
  // Debug food
  //Food f = new Food(10, 5); 
  //allthefood.add(f);
  //f = new Food(11, 5);
  //allthefood.add(f);
  //f = new Food(15, 6);
  //allthefood.add(f);
  //f = new Food(15, 7);
  //allthefood.add(f);
  //f = new Food(15, 8);
  //allthefood.add(f);
}


void keyPressed() {
   if (key == 'g') {
     showGrid = !showGrid;
   }
   
   // Decode the direction. 
   if (key == CODED) {
     if (keyCode == UP) {
       snake.setDirection(Direction.Up);
     }
     
     if (keyCode == DOWN) {
       snake.setDirection(Direction.Down); 
     }
     
     if (keyCode == LEFT) {
       snake.setDirection(Direction.Left); 
     }
     
     if (keyCode == RIGHT) {
       snake.setDirection(Direction.Right);
     }
   }
}