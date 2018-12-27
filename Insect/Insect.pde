Organism o;

void setup() {
  size(350, 350);
  ellipseMode(CENTER);
  
  o = new Organism(new PVector(width/2, height/2), random(0, 1.0), floor(random(0, 44))); 
}

void draw() {
  background(255);
  o.run();
}

void keyPressed() {
 o = new Organism(new PVector(width/2, height/2), random(0, 1.0), floor(random(0, 44))); 
}
