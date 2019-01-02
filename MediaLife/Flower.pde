// Natural food. 
class Flower {
  PVector position; 
  int rot;
  int flowerHeight; int flowerWidth; 
  float scale; 
  color petalColor;
  PGraphics head; PShape icon; 
  PVector centerHead, base;
  
  Flower(PVector pos, float s) {
    rot = 0; 
    scale = s; 
    position = pos; 
    flowerHeight = int(70*s);
    flowerWidth = int(50*s);
    petalColor = color(random(255), random(255), random(255));
    centerHead = new PVector(flowerWidth/2, flowerHeight/3); 
    base = new PVector(centerHead.x, flowerHeight);
    
    createHead(); 
  }
  
  void createHead() {
    int randIdx = floor(random(0, files.length)); 
    icon = loadShape(files[randIdx].getAbsolutePath()); 
    head = createGraphics(flowerWidth, flowerWidth); 
    head.beginDraw();
    head.fill(0); 
    head.shape(icon,0, 0, flowerWidth, flowerWidth);  
    head.endDraw();
  }
  
  void run() {
    pushMatrix();
      translate(position.x, position.y);
      scale(scale, scale);
      
      //// Draw the bounding box
      //// Enable this for debugging. 
      //color c = color(255, 255, 255, 0); 
      //fill(c);
      //stroke(0); 
      
      //rect(0, 0, flowerWidth, flowerHeight); 
      
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
      
      pushMatrix(); 
       translate(centerHead.x - flowerWidth/2, centerHead.y - flowerHeight/3); 
       //shader(shade);
       image(head, 0, 0); 
       //resetShader();
      popMatrix();
    popMatrix();
  } 
}
