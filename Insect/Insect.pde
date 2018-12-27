Organism o;

void setup() {
  size(300, 300);
  ellipseMode(CENTER);
  
  o = new Organism(new PVector(width/2, height/2), 1.0); 
}

void draw() {
  background(0);
  o.run();
}

// Draw the normals of a circle
