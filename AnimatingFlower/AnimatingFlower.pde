// Animating flower. 

class Flower {
  PVector position; 
  int rot;
  float flowerScale; 
  int centerDiameter = 50;
  int petalDiameter = 40; 
  
  Flower(PVector pos, float scale) {
    position = pos; 
    rot = 0; 
    flowerScale = scale; 
  }
  
  void run() {
    pushMatrix(); 
      // Translate to location. 
      translate(position.x, position.y);
      pushStyle();
      noStroke(); 
      scale(flowerScale, flowerScale);
      
      PVector point1 = new PVector(25 * cos(PI/2), 25 * sin(PI/2)); 
      PVector point2 = new PVector(point1.x, point1.y + 60);
      
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
      strokeWeight(4);
      line(point1.x, point1.y, point2.x, point2.y); 
      popStyle();
      
      // Petals.
      pushMatrix(); 
      rotate(radians(rot));
        fill(255, 0, 0); // green
        for (int i = 0; i < 6; i++) {
          ellipse(0, -30, 40, 40);
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
  
  // Width for intersection.
  float flowerWidth() {
    return (centerDiameter + petalDiameter) * flowerScale; 
  }
}

Flower f; 

void setup() {
  size(400, 400);
  smooth();
  f = new Flower(new PVector(width/2, height/2), 1);
}

void draw() {
  background(255);
  f.run();
  println(f.flowerWidth());
}
