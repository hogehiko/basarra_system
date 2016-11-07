import processing.sound.*;
import hogehiko.basara.*;
import java.util.*;
FFT fft;
AudioIn in;
int bands = 512;
int max = 128;
float[] spectrum = new float[bands];
int[] peak = new int[0];
float[] spectrumFreeze = null;
Capture capture = new Capture(bands, 10);

void setup() {
  
  size(512, 360);
  background(255);
    
  // Create an Input stream which is routed into the Amplitude analyzer
  fft = new FFT(this, bands);
  in = new AudioIn(this, 0);
  
  // start the Audio Input
  in.start();
  
  // patch the AudioIn
  fft.input(in);
}      

void draw() { 
  background(255);
  float[] _spectrum = new float[bands];
  fft.analyze(_spectrum);
  capture.capture(_spectrum);
  spectrum = capture.getAverage();
  for(int i = 0; i < max; i++){
  // The result of the FFT is normalized
  // draw the line for frequency band i scaling it up by 5 to get more amplitude.
    float[] shown = (spectrumFreeze == null)?spectrum:spectrumFreeze;
    if(peak.length >= i && i >0){
      switch(peak[i-1]){
        case 1:
          fill(255, 0, 0);
          break;
        case 2:
          fill(0, 255, 0);
          //ellipse(i*4-5,   height - shown[i]*height*5-5, 10, 10) ;
          break;
        case 3:
          fill(0, 0, 255);
          break;
        case 4:
          fill(0,0,0);
          break;
      }
      
    }else{
      fill(0,0,0);
    }
    rect( i*4,  height - shown[i]*height*5, 4, shown[i]*height*5 );
  } 
}

void mouseClicked() {
  if(spectrumFreeze == null){
    spectrumFreeze = Arrays.copyOf(spectrum, spectrum.length);   
    peak = capture.getPeak(spectrumFreeze);
    System.out.println("freeze");
    
  }else{
    spectrumFreeze = null;
    peak = new int[0];
    System.out.println("play");
  }
}