// Natural food. 
class Flower {
  PVector position; 
  int rot;
  int flowerHeight; int flowerWidth; 
  float scale; 
  
  // Get center flower radius and position to calculate
  // the intersection box/radius for the circle
 
  
  Flower(PVector pos, float s) {
    rot = 0; 
    scale = s; 
    position = pos; 
    flowerHeight = int(90*s);
    flowerWidth = int(60*s);
  }
  
  void run() {
    pushMatrix();
      translate(position.x, position.y);
      scale(scale, scale);
      
      // Draw the bounding box
      // Enable this for debugging. 
      color c = color(255, 255, 255, 0); 
      fill(c);
      stroke(0); 
      
      rect(0, 0, flowerWidth, flowerHeight); 
      
      PVector centerHead = new PVector(flowerWidth/2, flowerHeight/3); 
      PVector base = new PVector(centerHead.x, flowerHeight);
      
      // Smooth flower face. 
      noStroke();
      
      ellipseMode(CORNER);
      // Left leaf.
      pushMatrix(); 
      translate(base.x, base.y); 
        rotate(radians(200)); 
        fill(0, 255, 0);
        ellipse(0, 0, flowerWidth/2, flowerHeight/9);
      popMatrix();
      
      // Right leaf. 
      pushMatrix(); 
      translate(base.x, base.y); 
        rotate(radians(-20));
        fill(0, 255, 0);
        ellipse(0, -flowerHeight/9, flowerWidth/2, flowerHeight/9);
      popMatrix();
      
      // Stem.
      pushStyle();
      stroke(0, 153, 0);
      strokeWeight(6);
      strokeCap(SQUARE);
      line(centerHead.x, centerHead.y, base.x, base.y); 
      popStyle();
      
      ellipseMode(CENTER); 
      // Petals.
      pushMatrix();
        translate(centerHead.x, centerHead.y);
        rotate(radians(rot));
        fill(255, 0, 0); // green
        for (int i = 0; i < 6; i++) {
          ellipse(0, -flowerWidth/4, flowerWidth/2, flowerWidth/2);
          rotate(radians(60));
        }
        rot++;
      popMatrix();
      
      // Center part. 
      noStroke();
      fill(255, 255, 0);
      ellipse(centerHead.x, centerHead.y, flowerWidth/2.5, flowerWidth/2.5);
    popMatrix();
  } 
}
