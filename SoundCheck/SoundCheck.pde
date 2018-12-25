// Simple processing example to play around with Midi notes, oscillators, and ADSR 
// to create sounds for MediaLife project. 
import processing.sound.*;
import controlP5.*; 

// GUI
ControlP5 cp5; 

// Oscillators and ADSR envelope
TriOsc triOsc; SinOsc sinOsc; SawOsc sawOsc; SqrOsc sqrOsc; Pulse pulseOsc;
Oscillator curOsc;
Env env; 

BrownNoise noise;
Reverb reverb; 
HighPass lowPass;
Delay delay; 

enum Oscillate {
  Sin,
  Triangle, 
  Square,
  Saw,
  Pulse
};

// Times and levels for the ASR envelope
float attack = 0.1; Slider attackSlider; 
float decay = 0.01; Slider decaySlider; 
float sustain = 0.2; Slider sustainSlider; 
float release = 0.2; Slider releaseSlider; 

// This is an octave in MIDI notes.
int[] midi = {84,87,89,91,82};

int noteIdx; 
boolean shouldNote = false; 
boolean shouldNoise = false;
Oscillate osci = Oscillate.Sin; 
void setup() {
  size(300, 300);
  background(255);
  
  // All oscillators
  triOsc = new TriOsc(this);
  sinOsc = new SinOsc(this);
  sawOsc = new SawOsc(this); 
  pulseOsc = new Pulse(this); 
  sqrOsc = new SqrOsc(this);
  
  // Noise
  noise = new BrownNoise(this); 
  
  // Effects
  reverb = new Reverb(this); 
  delay = new Delay(this);
  
  // Filters
  lowPass = new LowPass(this);
  
  initGui();
  
  prepareExitHandler();
  
  // Envelope
  env = new Env(this);
}

void initGui() {
  cp5 = new ControlP5(this); 
                
  attackSlider = cp5.addSlider("attack")
              .setPosition(5, 0)
              .setSize(100, 20)
              .setRange(0, 5.0)
              .setValue(attack)
              .setColorCaptionLabel(color(0));
  
  decaySlider = cp5.addSlider("decay")
              .setPosition(5, 20)
              .setSize(100, 20)
              .setRange(0, 2.0)
              .setValue(decay)
              .setColorCaptionLabel(color(0));

  sustainSlider = cp5.addSlider("sustain")
              .setPosition(5, 40)
              .setSize(100, 20)
              .setRange(0, 2.0)
              .setValue(sustain)
              .setColorCaptionLabel(color(0));
              

  releaseSlider = cp5.addSlider("release")
              .setPosition(5, 60)
              .setSize(100, 20)
              .setRange(0, 2.0)
              .setValue(release)
              .setColorCaptionLabel(color(0));
  
  cp5.loadProperties("soundcheck");
}

void draw() { 
  background(255); 
  
  pushStyle(); 
    fill(0); 
    textSize(15); 
    text("Oscillator: " + osci, 5, 100); 
  popStyle();
  
  if (shouldNoise) {
    noise.play();
    noise.amp(0.1); 
    reverb.process(noise); 
    reverb.wet(0.5); 
    reverb.damp(0.5);
    lowPass.process(noise);
    shouldNoise = false;
  }
  
  if (shouldNote) {
    switch (osci) {
     case Sin: curOsc = sinOsc; break;
     
     case Triangle: curOsc = triOsc; break;
     
     case Saw: curOsc = sawOsc; break;
     
     case Pulse: curOsc = pulseOsc; break;
     
     case Square: curOsc = sqrOsc; break;
     
     default: {
      break; 
     }
    }
    
    // Play the note. 
    curOsc.play(midiToFreq(midi[noteIdx]), 0.1);
    reverb.process(curOsc); reverb.room(0.5);
    delay.process(curOsc, 2.0, 0.5); 
    env.play(curOsc, attack, decay, sustain, release);
    shouldNote = false;
  }
  
  // Map the left/right mouse position to a cutoff frequency between 10 and 15000 Hz
  float cutoff = map(mouseX, 0, width, 10, 15000);
  lowPass.freq(cutoff);

  // Draw a circle indicating the position + width of the frequencies passed through
  background(125, 255, 125);
  noStroke();
  fill(255, 0, 150);
  ellipse(width, height, 2*(width - mouseX), 2*(width - mouseX));
} 

// This helper function calculates the respective frequency of a MIDI note
float midiToFreq(int note) {
  return (pow(2, ((note-69)/12.0))) * 440;
}

void keyPressed() {
  if (key == 'a') {
    noteIdx = floor(random(midi.length));
    shouldNote = true;
  }
  
  if (key == 'b') {
    noteIdx = floor(random(midi.length)); 
    //shouldNote = true; 
    shouldNoise = true; 
  }
  
  if (key == '1') {
    osci = Oscillate.Sin; 
  }
  
  if (key == '2') {
    osci = Oscillate.Triangle;     
  }
  
  if (key == '3') {
    osci = Oscillate.Square;  
  }
  
  if (key == '4') {
    osci = Oscillate.Saw;  
  }
  
  if (key == '5') {
    osci = Oscillate.Pulse;  
  }
}

void prepareExitHandler () {
  Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
    public void run () {
      cp5.saveProperties(("soundcheck"));
    }
  }));
}
