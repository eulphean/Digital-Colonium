float[] x = new float[5];
float[] y = new float[5];
float segLength = 5;

void setup() {
  size(640, 360);
  strokeWeight(5);
  stroke(255);
}

void draw() {
  background(0);
  strokeWeight(3);
  dragSegment(0, mouseX, mouseY);
  for(int i=0; i<x.length-1; i++) {
    dragSegment(i+1, x[i], y[i]);
  }
  strokeWeight(1);
  fill(255);
  ellipse(mouseX, mouseY, 20, 20);
  fill(0);
  ellipse(mouseX, mouseY, 8, 8);
}

void dragSegment(int i, float xin, float yin) {
  float dx = xin - x[i];
  float dy = yin - y[i];
  float angle = atan2(dy, dx);  
  x[i] = xin - cos(angle) * segLength;
  y[i] = yin - sin(angle) * segLength;
  segment(x[i], y[i], angle);
}

void segment(float x, float y, float a) {
  pushMatrix();
  translate(x, y);
  rotate(a);
  line(0, 0, segLength, 0);
  popMatrix();
}
