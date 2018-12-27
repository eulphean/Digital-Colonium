class PixelBrick {
  PVector position; PVector center; 
  int brickW; int brickH; 
  long curTime; float waitTime;
  color pixGrid[][];
  int rows; int cols; int pixWidth;
  
  // Sound stuff. 
  BrownNoise noise; float amp; 
  Oscillator osc; Env env; float [] evals; int midi; LowPass lowPass; BandPass bandPass; 
  boolean hasPlayed; boolean isOccupied; float alpha; color outerColor;
 
  PixelBrick(PVector pos, int numRows, int numCols, int pWidth, float a) {
    position = pos; 
    rows = numRows; cols = numCols; pixWidth = pWidth; 
    brickW = pixWidth*cols; brickH = pixWidth*rows;
    center = new PVector(position.x+brickW/2, position.y+brickH/2);
    
    // State variables
    hasPlayed = isOccupied = false; 
    
    // Time to change colors. 
    curTime = millis();
    waitTime = random(500, 1000);
    
    // Create a new grid. 
    pixGrid = new color[cols][rows]; 
    // Create an initial grid of colors. 
    for (int x = 0; x < cols; x++) {
      for (int y = 0; y < rows; y++) {
        pixGrid[x][y] = color(random(255), random(255), random(255));
      }
    }
    
    outerColor = color(255); alpha = 255; // Outer color gets updated based on the color of the creature that enters. 
    
    // Brick's sound. 
    noise = new BrownNoise(sketchPointer); bandPass = new BandPass(sketchPointer); amp = a;
    osc = getRandomOscillator(); osc.amp(a); midi = getRandomMidi(true); env = new Env(sketchPointer);
    evals = getADSRValues(true); lowPass = new LowPass(sketchPointer); noise = new BrownNoise(sketchPointer);
  }
  
  // Return the radius of a circle that inscribes this square. 
  // Use this to steer the boids away from this brick. 
  float getCircleRad() {
    return sqrt(pow(brickW/2,2)+pow(brickW/2, 2));  
  }
  
  void run(ArrayList<Insect> agents) {
    updateSound(agents);
    display();
    displayDebug();
  }
  
  void updateSound(ArrayList<Insect> agents) {
    isOccupied = false;
    // Is any agent inside the PixelBrick? 
    for (Agent a: agents) {
     float d = PVector.dist(center, a.position);  
     if (d < getCircleRad()) {
      isOccupied = true; 
      outerColor = a.bodyColor;
     }
    }
    
    if (isOccupied) {
     waitTime -= 5; 
     if (alpha >=1 ) { alpha -= 1.0; outerColor = (outerColor & 0xffffff) | (floor(alpha) << 24); }
    }
    
    // Play the sound. 
    if (isOccupied && !hasPlayed) {
     // Noise
     noise.amp(amp/10); noise.play();
     if (!bandPass.isProcessing()) {
      bandPass.process(noise, amp); bandPass.freq(750); 
     }

     // Oscillator.
     osc.play(midiToFreq(midi), amp);
     if (!lowPass.isProcessing()) {
       lowPass.process(osc, amp); lowPass.freq(750);
     } 
     env.play(osc, evals[0], evals[1], evals[2], evals[3]); 
     
     hasPlayed = true; 
    }
    
    // if it's not occupied, reset hasPlayed
    if (!isOccupied) {
     noise.stop();
     hasPlayed = false;
     
     // Reset wait time
     waitTime = random(500, 1000);
     
     alpha = 255;
    }
  }
  
  void display() {
    // Only change the color after that time 
    if (millis() - curTime > waitTime) {
      // Create a new set of colors
      for (int x = 0; x < cols; x++) {
        for (int y = 0; y < rows; y++) {
          pixGrid[x][y] = color(random(255), random(255), random(255));
        }
      }
      
      // Reset time. 
      curTime = millis();
    }
    
    // Draw the color grid. 
    pushMatrix();
      translate(position.x, position.y);
      if (isOccupied) {
       fill(outerColor);
       rect(-5, -5, pixWidth*cols+10, pixWidth*rows+10);
      }
      
      for (int x = 0; x < cols; x++) {
        for (int y = 0; y < rows; y++) {
          stroke(0);
          fill(pixGrid[x][y]);
          rect(pixWidth*x, pixWidth*y, pixWidth, pixWidth);  
        }
      }
    popMatrix();
  }
  
  void displayDebug() {
    if (debug) {
      // Draw the radius around
      pushStyle();
      stroke(0, 255, 0); 
      strokeWeight(3); 
      ellipseMode(RADIUS);
      fill(255, 255, 255, 0); 
      float radius = getCircleRad();
      ellipse(center.x, center.y, radius, radius);
      popStyle();
    }
  }
}
