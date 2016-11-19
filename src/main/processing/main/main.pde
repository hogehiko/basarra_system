import processing.sound.*;
import hogehiko.basara.*;
import java.util.*;
import controlP5.*;
import java.lang.Math;
import java.awt.*;
import java.awt.event.*;

FFT fft;
AudioIn in,in2;
int bands = 512;
int max = 128;
float[] spectrum = new float[bands];
int[] peak = new int[0];
float[] spectrumFreeze = null;
Capture capture = new Capture(bands, 10, "sample.log", "ibanez.log");
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
  fft = new FFT(this, bands);
  
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
  System.out.println(p5.get(Textfield.class, "note").getText());
}  

void draw() { 
  
  float[] _spectrum = new float[bands];
  fft.analyze(_spectrum);
  capture.capture(_spectrum);
  
  spectrum = capture.getAverage();
  String result = capture.calc(spectrum);
  
  //if(result){
    background(255);
   
  //}else{
  //  background(128); 
  //}
  //int ty= 30;
  //for(String s:result){
  if(sumOfSpectrum()>-10){
     text(result, 400, 30);
     //System.out.print(s);
     //ty += 50;
     if(result.equals("E")){
       curY += 1;
     }else if(result.equals("G")){
        curX += 1; 
     }else if(result.equals("A")){
         curX -= 1;
     }else if(result.equals("C")){
         curY -= 1;
     }
     robot.mouseMove(curX, curY);
     if(result.equals("D")){
         robot.mousePress(InputEvent.BUTTON1_MASK);
         robot.mouseRelease(InputEvent.BUTTON1_MASK);
     }
  }
  //}
  System.out.println();
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
  System.out.println(sumOfSpectrum());
}

void mouseClicked() {
  //if(spectrumFreeze == null){
  //  spectrumFreeze = Arrays.copyOf(spectrum, spectrum.length);   
  //  peak = capture.getPeak(spectrumFreeze);
  //  System.out.println("freeze");
    
  //}else{
  //  spectrumFreeze = null;
  //  peak = new int[0];
  //  System.out.println("play");
  //}
}