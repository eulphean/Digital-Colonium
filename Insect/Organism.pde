class Organism {
  // Organism. 
  PVector headCenter;
  float radius; 
  float scale;
  
  // Antenna properties. 
  // [NOTE] Could evolve certainly. 
  IntList antIndices; 
  ArrayList<PVector> antEdges; 
  int maxAngle; int minAngle; 
  int antennaOffset; 
  int maxAntennas; 
  int minLength; int maxLength;
  
  Organism(PVector pos, float s, int numAntennas) {
    // Antenna head properties. 
    antIndices = new IntList(); 
    antEdges = new ArrayList();
    minAngle = 160; maxAngle = 380; 
    antennaOffset = 10; 
    maxAntennas = (maxAngle-minAngle)/antennaOffset; 
    minLength = 20; maxLength = 100;
    
    // Head properties. 
    headCenter = pos; 
    scale = s;
    radius = 50.0; 
    
    // Populate antIndices. 
    calcRandomIndices(numAntennas, maxAntennas); 
    
    // Assume that we have already transposed. So, all the calculations are done
    // as if the headCenter is at 0,0. This is important to save the length of the
    // organism's antennas. 
    for (int i = 0; i < antIndices.size(); i++) {
     // Theta at that index. 
     int theta = antennaOffset * antIndices.get(i) + minAngle; 
     
     // Location on the head's surface. 
     float rad = radians(theta);
     PVector headEdge = new PVector(radius*cos(rad), radius*sin(rad));
    
     // Antenna edge vector (assume we have already transposed). We always scale the creature's body. 
     // That's why vector is calculated with respect to the origin. 
     PVector normalDir = PVector.sub(headEdge, new PVector(0, 0));
     normalDir.normalize();
     normalDir.mult(random(minLength, maxLength));
     antEdges.add(PVector.add(headEdge, normalDir)); 
    }
  }
  
  void calcRandomIndices(int numAntennas, int maxAntennas) {
    for (int i = 0; i < numAntennas; i++) {
      int idx; 
      do {
       idx = floor(random(maxAntennas));
      } while(antIndices.hasValue(idx)); // Keep checking until I find a random number that's not in the list. 
      antIndices.append(idx); 
    }
  }
  
  void run() {
   pushMatrix();
     translate(headCenter.x, headCenter.y); 
     // Always scale!! Everything is relative to the 
     // organism's head's center. 
     scale(scale);
     antennas();
     head();
   popMatrix();
  }
  
  void head() {
    pushStyle();
    stroke(0); strokeWeight(1);
    fill(255);
    ellipse(0, 0, radius*2, radius*2);
    popStyle();
  }

  void antennas() {
    // Calculate antenna locations on the head's surface for random
    // index where an antenna needs to be there.    
    for (int i = 0; i < antIndices.size(); i++) {
     // Theta at that index. 
     int theta = antennaOffset * antIndices.get(i) + minAngle; 
     
     // Location on the head's surface. 
     float rad = radians(theta);
     PVector headEdge = new PVector(radius*cos(rad), radius*sin(rad));
     
     // Antenna's edge. 
     PVector antEdge = antEdges.get(i);
     pushStyle(); 
      strokeWeight(3); 
      stroke(0);
      line(headEdge.x, headEdge.y, antEdge.x, antEdge.y); 
      noStroke(); 
      fill(random(255), random(255), 0);
      ellipse(antEdge.x, antEdge.y, 14, 15);
     popStyle();
    }
  }
}

//for (int i = 0; i < antIndices.size(); i++) {
//     // Theta at that index. 
//     int theta = antennaOffset * antIndices.get(i) + minAngle; 
     
//     // Location on the head's surface. 
//     float rad = radians(theta);
//     PVector headEdge = new PVector(headCenter.x + radius*cos(rad), headCenter.y + radius*sin(rad));
     
//     // Antenna's edge. 
//     PVector antEdge = antEdges.get(i);
//     pushStyle(); 
//      stroke(255, 0, 0); 
//      strokeWeight(3); 
//      line(headEdge.x, headEdge.y, antEdge.x, antEdge.y); 
//      fill(255, 0, 0); 
//      ellipse(antEdge.x, antEdge.y, 4, 4);
//     popStyle();
//    }
// Create numAntennas random indices to find where to create the antenna. 
// There can be total of 44 antennas that an organism can have between 
// 160-380 degrees circle surface. 
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
