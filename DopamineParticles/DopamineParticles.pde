class Particle {
 PVector position;
 PVector velocity; 
 Particle() { 
 }
 
 void run(float alpha) {
   position = position.add(velocity); 
   pushStyle();
   noStroke();
   fill (0, 0, 0, alpha); 
   ellipse(position.x, position.y, 5, 5); 
   popStyle();
 }
 
 void init(PVector newPos) {
   position = new PVector(0, 0);
   position.x = newPos.x;
   position.y  = newPos.y;
   velocity = new PVector(random(-0.8, 0.8), random(-0.5, 0.5)); 
 }
}

class ParticleSystem {
  ArrayList<Particle> particles; 
  int numParticles;
  boolean run; float alpha; int frame; 
  
  ParticleSystem() {
   numParticles = 10;
   run = false; 
   alpha = 255; frame = 0; 
   particles = new ArrayList(); 
   for (int i = 0; i < numParticles; i++) {
     particles.add(new Particle()); 
   }
  }
  
  void run() {
   alpha = map(frame, 0, 30, 255, 0);
   if (run) {
     for (Particle p: particles) {
       p.run(alpha);
     }
     frame++;
   }
     
   // Stop the particle system until it's reset. 
   if (frame == 30) {
    run = false; 
   }
  }
  
  void init(PVector position) {
    // Initialize the system. 
    alpha = 255; frame = 0;  
    for (int i = 0; i < numParticles; i++) {
     particles.get(i).init(position); 
    }
    
    // Run it. 
    run = true; 
  }
  
}

ParticleSystem particles; 
void setup() {
  size(200, 200);
  particles = new ParticleSystem();
}

void draw() {
  background(255);
  particles.run();
}

void mousePressed() {
  particles.init(new PVector(mouseX, mouseY)); 
}
