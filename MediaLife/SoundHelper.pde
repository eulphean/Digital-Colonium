// A simple helper for the sound behavior of this program. Agents call into
// this helper mostly. 

// Random oscillator assignment. 
Oscillator getRandomOscillator() {
  Oscillator osc = null; 
  float prob = random(1); 
  
  // Sin.
  if (prob <= 0.3) {
    osc = new SinOsc(sketchPointer); 
  }
  
  // Triangle.
  if (prob > 0.3 && prob <= 1.0) {
    osc = new TriOsc(sketchPointer); 
  }
  return osc;
}

// Create a random set of ADSR values for the oscillators. 
float [] getADSRValues(boolean brick) {
  float val[] = new float[4]; 
  
  if (brick) {
   val[0] = random(400,1000)/1000; /// Attack
   val[1] = random(100,200)/100; /// Decay
   val[2] = 0.5; /// Sustain
   val[3] = (random(500, 1000)/1000); /// Release
  } else {
   val[0] = random(15,100)/1000; /// Attack
   val[1] = random(10,50)/100; /// Decay
   val[2] = 0.05; /// Sustain
   val[3] = (random(50, 100)/100); /// Release
  }
  
  return val;
}

// Generates a random midi note for the agent. 
int getRandomMidi(boolean brick) {
  if (brick) {
   return floor(random(40, 90));
  } else {
   return floor(random(50, 120));
  }
}

float midiToFreq(int note) {
  return (pow(2, ((note-69)/12.0))) * 440;
}
