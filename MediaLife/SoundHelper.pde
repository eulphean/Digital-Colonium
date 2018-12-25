// A simple helper for the sound behavior of this program. Agents call into
// this helper mostly. 

// Random oscillator assignment. 
Oscillator getRandomOscillator() {
  Oscillator osc = null; 
  float prob = random(1); 
  
  if (prob <= 0.3) {
    osc = new SinOsc(sketchPointer); 
  }
  
  if (prob > 0.3 && prob <= 1.0) {
    osc = new TriOsc(sketchPointer); 
  }
  
  //if (prob > 0.8 && prob <= 1.0) {
  //  osc = new SqrOsc(sketchPointer); 
  //}
  
  //if (prob > 0.8 && prob <= 1.0) {
  //  osc = new SawOsc(sketchPointer);
  //}
  
  //if (prob > 0.8 && prob <= 1.0) {
  //  osc = new Pulse(sketchPointer);
  //}
  return osc;
}

// Create a random set of ADSR values for the oscillators. 
float [] getADSRValues() {
  float val[] = new float[4];
  val[0] = random(15,100)/1000; /// Attack
  val[1] = random(10,50)/100; /// Decay
  val[2] = 0.05; /// Sustain
  val[3] = (random(50, 100)/100); /// Release
  return val;
}

// Generates a random midi note for the agent. 
int getRandomMidi() {
  return floor(random(50, 120));
}

float midiToFreq(int note) {
  return (pow(2, ((note-69)/12.0))) * 440;
}

// Some nice values
//val[0] = 1.0; /// Attack
//val[1] = 0.2; /// Decay
//val[2] = 0.5; /// Sustain
//val[3] = 0.5; /// Release
