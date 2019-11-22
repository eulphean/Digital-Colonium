// Factory of shaders. 

class Shade  {
  PShader shade; 
  Shade(PShader sh) {
   shade = sh;  
  }
}

class ShaderFactory {
  Shade shades[];  
  
  // All shaders to load. 
  String[] shaders = new String[] {
    "brcosa.glsl", "hue.glsl", "pixelate.glsl", "blur.glsl", 
    "channels.glsl", "threshold.glsl", "neon.glsl", "edges.glsl", "pixelrolls.glsl", 
    "modcolor.glsl", "halftone.glsl", "halftone_cmyk.glsl", "invert.glsl" };
    
  // Selected shader indicices to use. 
  int [] selectedIndices = new int[] {0, 1, 2, 3, 4, 6, 8, 9 }; 
  
  ShaderFactory() {
    shades = new Shade[shaders.length]; 
    
    // Load all the shaders. 
    for (int i = 0; i < shaders.length; i++) {
     PShader shade = loadShader(shaders[i]);
     shades[i] = new Shade(shade); 
    }
    
    print("loaded all shaders");
  }
  
  Shade getShaderAtIdx(int idx) {
    // Return a clone of a shader.  
    Shade shader = shades[idx]; 
    Shade newShade = new Shade(shader.shade);
    return newShade; 
  }  
}
