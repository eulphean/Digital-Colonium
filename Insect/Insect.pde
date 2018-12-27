Organism o;

void setup() {
  size(350, 350);
  ellipseMode(CENTER);
  
  o = new Organism(new PVector(width/2, height/2), 0.5, 10); 
}

void draw() {
  background(0);
  o.run();
}

void keyPressed() {
 o = new Organism(new PVector(width/2, height/2), 0.5, 10); 
}

// Draw the normals of a circle
