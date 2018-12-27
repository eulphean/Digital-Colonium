Organism o;

void setup() {
  size(500, 500);
  ellipseMode(CENTER);
  // Organism(PVector headCenter, float scale, int numAntennas, int headRadius, int bodyWidth, int bodyHeight)
  o = new Organism(new PVector(width/2, height/2), 2.0, 10, 10, 40); 
}

void draw() {
  background(255);
  o.run();
}

void keyPressed() {
 //o = new Organism(new PVector(width/2, height/2), random(0, 1.0), floor(random(23))); 
}
