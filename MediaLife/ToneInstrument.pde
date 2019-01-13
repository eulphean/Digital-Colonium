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

class EmitterInstrument implements Instrument
{
  // create all variables that must be used througout the class
  Oscil osc;
  ADSR  adsr;
  //Pan pan; 
  
  // constructor for this instrument
  EmitterInstrument( float frequency, float amplitude )
  {    
    osc = new Oscil( frequency, amplitude, Waves.SINE);
    adsr = new ADSR(amplitude, 10.0, 0.1, 1.0, 5.0);
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
