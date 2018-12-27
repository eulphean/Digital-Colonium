Organism o;

void setup() {
  size(500, 500);
  ellipseMode(CENTER);
  // Organism(PVector headCenter, float scale, int numAntennas, int headRadius, int bodyHeight)
  o = new Organism(new PVector(width/2, height/2), 1.0, 10, 10, 50); 
}

void draw() {
  background(255);
  o.run();
}

void keyPressed() {
 //o = new Organism(new PVector(width/2, height/2), random(0, 1.0), floor(random(23))); 
}
