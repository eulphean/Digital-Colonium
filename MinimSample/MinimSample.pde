import ddf.minim.*; 
import ddf.minim.ugens.*; 

Minim minim; 
AudioOutput out;

class ToneInstrument implements Instrument
{
  // create all variables that must be used througout the class
  Oscil osc;
  ADSR  adsr;
  Pan pan; 
  
  // constructor for this instrument
  ToneInstrument( float frequency, float amplitude )
  {    
    // create new instances of any UGen objects as necessary
    if (random(1) < 0.4) {
     osc = new Oscil( frequency, amplitude, Waves.SINE);
    } else {
     osc = new Oscil(frequency, amplitude, Waves.TRIANGLE);  
    }
    adsr = new ADSR(amplitude, random(15,100)/1000, random(10,50)/100, 0.05, 0.5, (random(50, 100)/100));
    pan = new Pan(0);
    
    // patch everything together up to the final output
    osc.patch( adsr ).patch(pan);
  }
  
  // every instrument must have a noteOn( float ) method
  void noteOn( float dur )
  {
    // turn on the ADSR
    adsr.noteOn();
    // patch to the output
    pan.patch( out );
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

ToneInstrument in;

void setup() {
  minim = new Minim(this);
  out = minim.getLineOut(Minim.STEREO, 2048);
  
  int randMidi = floor(random(50, 120));
  float val = Frequency.ofMidiNote(randMidi).asHz();
  in = new ToneInstrument(val, 0.4f);
}

void draw() {
  
}

void keyPressed() {
  out.playNote(0, 0.3, in);
}
