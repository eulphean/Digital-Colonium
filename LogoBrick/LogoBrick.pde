Apps apps; 
  
void setup() {
  fullScreen(P2D);
  apps = new Apps(); 
  smooth();
}

void draw() {
  background(0);
  apps.run(); 
}
