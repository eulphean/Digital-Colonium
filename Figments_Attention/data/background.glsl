#define PROCESSING_COLOR_SHADER

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

// ------------------------------------------------------- //
// Noise Helpers
// ------------------------------------------------------- //
float hash( float n )
{
	return fract(sin(n+0.5) * 0.5); // By not multiplying with such a large factor, it fixes the clipping mac os mojave.  
}

float noise( in vec2 x )
{
	vec2 p = floor(x);
	vec2 f = fract(x);
	f = f*(3-2.0*f);
	float n = p.x + p.y*57.0;
	float a = mix(hash(n + 0.0), hash(n +  1.0),f.x); 
	float b = mix(hash(n + 57.0), hash(n + 58.0),f.x); 
	float res = mix(a, b, f.y);
	return res;
}

float fbm( vec2 p )
{
	float f = 0.0;
	mat2 m = mat2( 0.8,  0.6, -0.6,  0.6 );
	f += 0.50000*noise( p ); p = m*p*2.02;
	f += 0.25000*noise( p ); p = m*p*2.03;
	f += 0.12500*noise( p ); p = m*p*2.01;
	f += 0.06250*noise( p ); p = m*p*2.04;
	f += 0.03125*noise( p );
	return f/0.984375;
}

// ------------------------------------------------------- //
// BEGIN.
// ------------------------------------------------------- //
void main(void)
{    	
	float newTime = time/1000; 
	vec2 q = gl_FragCoord.xy / resolution.xy;
	vec2 p = -1.0 + 1.5 * q;
	vec2 m = -1.0 + 2.0 / resolution.xy;
	m.y = -m.y;
	p.y *= (resolution.x/resolution.y);

	vec3 color;
   	color.x = 0.450 + 0.701*fbm(0.917*p + vec2(newTime*0.4, newTime*0.1));
   	color.y = 0.462 + 0.705*fbm(0.913*p + vec2(newTime*0.1, newTime*0.2));
   	color.z = 0.490 + 0.694*fbm(0.901*p + vec2(newTime*0.3, newTime*0.1));
   	gl_FragColor = vec4(color,1.0);
}