//class Cord {
// float x, y, a; 
// Cord(float x, float y, int a) {
//  this.x = x; 
//  this.y = y; 
//  this.a = a; 
// }
//}

//int numShapes=100;
//int currentShape=0; 
//Cord[] trail = new Cord[numShapes]; 

//void setup() {
//  size(500, 500); 
//}

//void draw() {
//  background(color(0, 255, 0)); 
  
//  int a = 255 - (255*currentShape)/(numShapes); 
//  trail[currentShape] = new Cord(mouseX, mouseY, a); 
  
//  noStroke();
//  // Draw all the points
//  for (int i=0; i < currentShape; i++) {
//    println(trail[i].a);
//    fill(0, 0, 0);
//    pushMatrix(); 
//      translate(trail[i].x, trail[i].y);
//      scale(10, 10); 
//      ellipse(0, 0, 10, 10);
//    popMatrix(); 
//  }
  
//  currentShape++; 
//  currentShape %= numShapes; 
//}

// object trail with array
int numShapes = 30;
int currentShape = 0;                   // counter
float[] shapeX = new float[numShapes];  // x coordinates
float[] shapeY = new float[numShapes];  // y coordinates
float[] shapeA = new float[numShapes];  // alpha values
int shapeSize = 20;


void setup() {
  size(500, 500);
  smooth();
  noStroke();
}

void draw() {
  background(255);

  shapeX[currentShape] = mouseX;
  shapeY[currentShape] = mouseY;
  shapeA[currentShape] = 255;

  for (int i=0; i<numShapes ; i++) {
    fill(0, shapeA[i]);
    ellipse(shapeX[i], shapeY[i], shapeSize, shapeSize);
    shapeA[i] -= 255/ (numShapes);
  }

  // increment counter
  currentShape++;
  currentShape %= numShapes;  // rollover counter to 0 when up to numShapes
}
