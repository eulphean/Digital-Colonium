// Create a simple flower
int outerD = 50; int innerD = 35; int innerInnerD = 20; 

void setup() {
  size(200, 200); 
}

void draw() {
  background(255); 
  
  strokeWeight(2);
  ellipseMode(CENTER); 
  fill(255, 128, 0);
  ellipse(width/2, height/2, outerD, outerD-10);
  fill(255, 255, 0); 
  ellipse(width/2, height/2, innerD, innerD-7);
  fill(255, 255, 255); 
  ellipse(width/2, height/2, innerInnerD, innerInnerD-5);
  
  // Create a line from the outer circle -90' to some distance in 
  // the -y axis. 
  PVector point1 = new PVector(width/2 + outerD/2 * cos(PI/2), height/2 + (outerD-10)/2 * sin(PI/2)); 
  PVector point2 = new PVector(point1.x, point1.y + 30); 
  fill(0); 
  line(point1.x, point1.y, point2.x, point2.y);
}
