void setup() {
  size(600, 600);
  
  background(240);

  float w = width * 0.2;
  float h = width * 0.2;

  stroke(30);
  strokeWeight(4);
  strokeCap(SQUARE);
  noFill();
  pushMatrix();
  translate(0, height/2); 
  beginShape();
    vertex(0, 0);
    bezierVertex(250, -100, 50, 0, 150, -50); 
    //bezierVertex(500, 0, 300, -100, 500, -50);
    //vertex(600, 0);
  endShape();
  popMatrix();
  

  noLoop();
}

void draw() {
 fill(255, 0, 0); 
 pushMatrix(); 
 translate(0, height/2);
 // 1st bezier
 ellipse(50, 0, 10, 10); 
 ellipse(250, -100, 10, 10);
 
 //ellipse(200, -50, 5, 5); 
 
 //// 2nd bezier
 //ellipse(300, -100, 10, 10);
 //ellipse(500, 0, 10, 10); 
 
 popMatrix();
  
}
