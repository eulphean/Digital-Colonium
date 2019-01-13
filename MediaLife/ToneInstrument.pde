// A simple helper for the sound behavior of this program. Agents call into
// this helper mostly. 

class ToneInstrument implements Instrument
{
  // create all variables that must be used througout the class
  Oscil osc;
  ADSR  adsr;
  //Pan pan; 
  
  // constructor for this instrument
  ToneInstrument( float frequency, float amplitude )
  {    
    // create new instances of any UGen objects as necessary
    if (random(1) < 0.4) {
     osc = new Oscil( frequency, amplitude, Waves.SINE);
    } else {
     osc = new Oscil(frequency, amplitude, Waves.TRIANGLE);  
    }
    adsr = new ADSR(amplitude, random(15,100)/1000, random(10,50)/100, 0.05, (random(50, 100)/100));
    //pan = new Pan(0);
    
    // patch everything together up to the final output
    osc.patch( adsr );
  }
  
  // every instrument must have a noteOn( float ) method
  void noteOn( float dur )
  {
    // turn on the ADSR
    adsr.noteOn();
    // patch to the output
    adsr.patch( out );
   }
  
  // every instrument must have a noteOff() method
  void noteOff()
  {
    // tell the ADSR to unpatch after the release is finished
    adsr.unpatchAfterRelease( out );
    // call the noteOff 
    adsr.noteOff();
  }
  
  void setAmplitude(float amp) {
    osc.setAmplitude(amp);
  }
}


//// Random oscillator assignment. 
//Oscillator getRandomOscillator() {
//  Oscillator osc = null; 
//  float prob = random(1); 
  
//  // Sin.
//  if (prob <= 0.3) {
//    osc = new SinOsc(sketchPointer); 
//  }
  
//  // Triangle.
//  if (prob > 0.3 && prob <= 1.0) {
//    osc = new TriOsc(sketchPointer); 
//  }
//  return osc;
//}

//// Create a random set of ADSR values for the oscillators. 
//float [] getADSRValues(boolean brick) {
//  float val[] = new float[4]; 
  
//  if (brick) {
//   val[0] = random(400,1000)/1000; /// Attack
//   val[1] = random(100,200)/100; /// Decay
//   val[2] = 0.5; /// Sustain
//   val[3] = (random(500, 1000)/1000); /// Release
//  } else {
//   val[0] = random(15,100)/1000; /// Attack
//   val[1] = random(10,50)/100; /// Decay
//   val[2] = 0.05; /// Sustain
//   val[3] = (random(50, 100)/100); /// Release
//  }
  
//  return val;
//}

//// Generates a random midi note for the agent. 
//int getRandomMidi(boolean brick) {
//  if (brick) {
//   return floor(random(40, 90));
//  } else {
//   return floor(random(50, 120));
//  }
//}

//float midiToFreq(int note) {
//  return (pow(2, ((note-69)/12.0))) * 440;
//}
