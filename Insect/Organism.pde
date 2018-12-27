class Organism {
  PVector headCenter;
  ArrayList<PVector> antennas; // Start, End. 
  float radius; 
  float scale;
  
  // TODO: I need to determine max number of antennas and locations where they can be 
  // drawn from on the head's surface. 
  Organism(PVector pos, float s) {
    headCenter = pos; 
    scale = s; 
    
    // Constants
    radius = 50.0; 
    
    antennas = new ArrayList();
    
    // Calculate normal points on the head's surface to draw later
    for (int theta = 180; theta < 360; theta+=6) {
      float rad = radians(theta);
      PVector edge = new PVector(headCenter.x + radius*cos(rad), headCenter.y + radius*sin(rad));
      PVector normalDir = PVector.sub(edge, headCenter); 
      normalDir.normalize();
      normalDir.mult(random(5, 100)); // Random length of the antenna. 
      antennas.add(PVector.add(edge, normalDir)); // Stores the edges of the antennas. 
    }
  }
  
  void run() {
   antennas();
   head();
  }
  
  void head() {
    pushMatrix(); 
      translate(headCenter.x, headCenter.y);
      pushStyle();
      noStroke();
      fill(255); 
      ellipse(0, 0, radius*2, radius*2);
      stroke(255, 0, 0);
      line(-radius, 0, radius, 0);
      popStyle();
    popMatrix();
  }

  void antennas() {
    // Go through all the antennas and draw them. 
    for (int theta = 180, i = 0; theta < 360; theta+=6, i++) {
      float rad = radians(theta);
      PVector edge = new PVector(headCenter.x + radius*cos(rad), headCenter.y + radius*sin(rad));
      PVector antenna = antennas.get(i); 
      pushStyle(); 
        stroke(255, 0, 0); 
        strokeWeight(3); 
        line(edge.x, edge.y, antenna.x, antenna.y); 
        fill(255, 0, 0); 
        ellipse(antenna.x, antenna.y, 5, 5);
      popStyle();
    }
  }
}
// Head
  //fill(0);
  //ellipseMode(CENTER);
  //ellipse(200, 160, 60, 80);
  
  // // eyes
  // fill(255, 255, 0);
  // ellipse(185, 130, 5, 5);
  // ellipse(215, 130, 5, 5);
  
  //// antlers
  //fill(0);
  //strokeWeight(3);
  //line(190, 125, 170, 95);
  //ellipse(167, 95, 5, 5);
  //line(210, 125, 230, 95);
  //ellipse(233, 95, 5, 5);
  
  //// Body
  //fill(255, 0, 0);
  //ellipse(200, 200, 140, 120);
  
  //fill(0);
  //strokeWeight(5);
  //line(200, 140, 200, 260);
  //strokeWeight(1);
  
  //triangle(200, 250, 205, 260, 195, 260);
  
  //// left dots
  //fill(0);
  //ellipse(140, 200, 8, 8);
  //ellipse(155, 180, 7, 7);
  //ellipse(165, 160, 8, 8);
  //ellipse(158, 210, 6, 6);
  //ellipse(172, 197, 8, 8);
  //ellipse(185, 172, 9, 9);
  //ellipse(180, 222, 8, 8);
  //ellipse(164, 236, 8, 8);
  
  //// right dots
  //ellipse(210, 160, 8, 8);
  //ellipse(222, 178, 7, 7);
  //ellipse(235, 166, 6, 6);
  //ellipse(213, 240, 8, 8);
  //ellipse(210, 206, 9, 9);
  //ellipse(240, 198, 7, 7);
  //ellipse(252, 212, 8, 8);
  //ellipse(232, 222, 8, 8);
