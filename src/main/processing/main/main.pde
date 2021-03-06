import processing.sound.*;
import hogehiko.basara.*;
import java.util.*;
import controlP5.*;
import java.lang.Math;
import java.awt.*;
import java.awt.event.*;

FFT fft;
AudioIn in,in2;
int samplingBand = 2048;
int bands = 512;
int max = 128;
float[] spectrum = new float[samplingBand];
int[] peak = new int[0];
float[] spectrumFreeze = null;
Capture capture = new Capture(bands, 10, "sample.log", "pignose.log");
ControlP5 p5;
Robot robot;

int curX = 500;
int curY = 200;

double sumOfSpectrum(){
  double s = 0;
  for(float f:spectrum){
    s =+ Math.log(f);
  }
  return s;
}

void setup() {
  size(512, 360);
  background(255);
  try{
    robot = new Robot();
  }catch(AWTException e){
    e.printStackTrace(); 
  }
  p5 = new ControlP5(this);
  PFont font = createFont("arial", 20);
  
  // Create an Input stream which is routed into the Amplitude analyzer
  fft = new FFT(this, samplingBand);
  in = new AudioIn(this, 0);
  
  // gui
    p5.addTextfield("note")
    .setPosition(20, 20)
      .setSize(200, 40)
        .setFont(font)
          .setFocus(true)
            .setColor(color(255, 0, 0))
              ;
              
  // and add another 2 buttons
  p5.addButton("capture")
     //.setValue(100)
     .setPosition(230,20)
     .setSize(70,40)
     ;
  // start the Audio Input
  in.start();
  
  // patch the AudioIn
  fft.input(in);
  
}      

void capture(){
  capture.log(p5.get(Textfield.class, "note").getText(), spectrum); 
}  

void draw() { 
  
  float[] _spectrum = new float[samplingBand];
  fft.analyze(_spectrum);
  capture.capture(_spectrum);
  
  spectrum = capture.getAverage();
  String result = capture.calc(spectrum);
  background(255);
  if(sumOfSpectrum()>-12){
     text(result, 400, 30);
     if(result.equals("E")){
       curY += 2;
     }else if(result.equals("G")){
        curX += 2; 
     }else if(result.equals("A")){
         curX -= 2;
     }else if(result.equals("C")){
         curY -= 2;
     }
     robot.mouseMove(curX, curY);
     if(result.equals("D")){
         robot.mousePress(InputEvent.BUTTON1_MASK);
         robot.mouseRelease(InputEvent.BUTTON1_MASK);
     }
  }
  
  peak = capture.getPeak(spectrum);
  for(int i = 0; i < max; i++){
    float[] shown = spectrum;//(spectrumFreeze == null)?spectrum:spectrumFreeze;
    if(peak.length >= i && i >0){
      switch(peak[i-1]){
        case 1:
          fill(255, 0, 0);
          break;
        case 2:
          fill(0, 255, 0);
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