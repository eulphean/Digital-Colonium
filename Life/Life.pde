// I'm making a quick prototype to test if I can move a creature around on the 
// OLEDs if I want to or not. These OLEDs are installed on the structure currently
// in a certain way. 

import processing.serial.*; 

// Global parameters used across
int worldWidth = 128; // 64 * 2 // 2 Columns (128)
int worldHeight = 640; // 128 * 5 // 5 rows (640) 
int cellWidth = 8; // Hypothetical width for a grid cell. 

World world = new World();

// Flags for showing things. 
boolean showGrid = false;
boolean showColoredDivision = false; 
boolean showFood = true; 

// Serial
Serial myPort; 
void setup() {
  size(128, 640);
  
  // Print an array of all the cells. 
  //printArray(Serial.list());
  
  // Open the port you are using at the rate you want:
  //myPort = new Serial(this, Serial.list()[11], 9600);
}

void draw() {
  background(255);
  
  // Update environment
  world.update();
  
  // Show the world
  world.show();
}

void keyPressed() {
  if (key == ' ') {
     showGrid = !showGrid;  
  }
  
  if (key == 'c') {
     showColoredDivision = !showColoredDivision; 
  }
  
  if (key == 'f') {
     showFood = !showFood;  
  }
  
  if (key == CODED) {
     if (keyCode == RIGHT) {
        world.moveCreature(1, 0);
     }
     
     if (keyCode == LEFT) {
        world.moveCreature(-1, 0);
     }
     
     if (keyCode == UP) {
        world.moveCreature(0, -1);  
     }
     
     if (keyCode == DOWN) {
        world.moveCreature(0, 1);
     }
     
     //println(toTransmit);
     //myPort.write(toTransmit);
  }
}

void serialEvent(Serial p) {
  // get message till line break (ASCII > 13)
  String message = myPort.readStringUntil(13);
  if (message != null) {
    println(message);
  }
}