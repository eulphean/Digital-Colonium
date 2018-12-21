// Natural food. 
class Flower {
  PVector position; 
  int rot;
  float flowerScale; 
  int centerDiameter; int petalDiameter;
  int stemLength;
  
  Flower(PVector pos, float scale) {
    rot = 0; 
    
    // Flower positions. 
    position = pos; 
    flowerScale = scale; 
    centerDiameter = 50; 
    petalDiameter = 40; 
    stemLength = 60; 
  }
  
  void run() {
    pushMatrix(); 
      // Translate to location. 
      translate(position.x, position.y);
      pushStyle();
      ellipseMode(CENTER);
      noStroke(); 
      scale(flowerScale, flowerScale);
      
      PVector point1 = new PVector(25 * cos(PI/2), 25 * sin(PI/2)); 
      PVector point2 = new PVector(point1.x, point1.y + stemLength);
      
      // Left leaf.
      pushMatrix(); 
      translate(point2.x, point2.y); 
        rotate(radians(220)); 
        pushStyle();
        ellipseMode(CORNERS);
        fill(0, 255, 0);
        ellipse(4, 0, 30, 7);
        popStyle();
      popMatrix();
      
      // Right leaf. 
      pushMatrix(); 
      translate(point2.x, point2.y); 
        rotate(radians(317));
        pushStyle();
        ellipseMode(CORNER);
        fill(0, 255, 0);
        ellipse(4, -6, 25, 7);
        popStyle();
      popMatrix();
      
      // Stem.
      pushStyle();
      stroke(0, 153, 0);
      strokeWeight(10);
      line(point1.x, point1.y, point2.x, point2.y); 
      popStyle();
      
      // Petals.
      pushMatrix(); 
      rotate(radians(rot));
        fill(255, 0, 0); // green
        for (int i = 0; i < 6; i++) {
          ellipse(0, -30, petalDiameter, petalDiameter);
          rotate(radians(60));
        }
        rot++;
      popMatrix();
      
      // Center part. 
      fill(255, 255, 0);
      ellipse(0, 0, centerDiameter, centerDiameter);
      popStyle();
    popMatrix();
  } 
  
  // Use this for drawing multiple flowers on the screen. 
  PShape getBoundingBox() {
    float w = (centerDiameter + petalDiameter) * flowerScale; 
    float h = (centerDiameter + stemLength + petalDiameter/2) * flowerScale;
    PShape rect = createShape(RECT, position.x - w/2, position.y - h/3, w, h); 
    return rect; 
  }
  
  // Use this for eating the flower.  
  PShape getFaceBoundingBox() {
    float w = (centerDiameter + petalDiameter) * flowerScale; 
    float h = (centerDiameter + petalDiameter) * flowerScale;
    PShape rect = createShape(RECT, position.x - w/2, position.y - h/2, w, h); 
    return rect; 
  }
}
