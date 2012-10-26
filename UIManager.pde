/**
Wheel mouse taken from http://wiki.processing.org/index.php/Wheel_mouse
@author Rick Companje
*/
import java.awt.event.*;

class UIManager {
  float rotX;
  float rotY;
  int offsX;
  int offsY;
  float zoomScale;
  float zoomExp;
  float initialTx, initialTy;
  String dbgMyName;
 
  UIManager(int drawSizeX, int drawSizeY) {
    initialTx = (width - drawSizeX) / 2.0;
    initialTy = (height - drawSizeY) / 2.0;
    rotX = PI/4;
    rotY = PI/4;
    offsX = 0;
    offsY = 0;
    zoomScale = 1.0;
    zoomExp = 0.0;
    dbgMyName = this.getClass().getName() + "::";
    
    // Mouse wheel
    addMouseWheelListener(new MouseWheelListener() { 
      public void mouseWheelMoved(MouseWheelEvent mwe) { 
        mouseWheel(mwe.getWheelRotation());
    }}); 
    
  }
  
  void update() {
    setInitialTranslate();
    translate(offsX, offsY, 0);
    rotateX(rotX);
    rotateY(rotY);
    scale(zoomScale);
    dbgPrintMyStats();
  }
  
  void mouseDragged() {
    if (mouseButton == LEFT) {
      float rate = 0.01;
      rotX += (pmouseY-mouseY) * rate;
      rotY += (mouseX-pmouseX) * rate;
    } else if (mouseButton == RIGHT) {
      int ratio = 10;
      offsY -= pmouseY-mouseY;
      offsX -= pmouseX-mouseX; 
    } 
  }
  
  void mouseWheel(int delta) {
    //int zoomcoeff = 1 * (1 + abs(zoomScale) / 400); 
    float zoomcoeff = 0.05;
    zoomExp -= (delta * zoomcoeff);
    zoomScale = pow(10, zoomExp);
    
    // println("zoomScale = " + zoomScale);
    // println("mouse has moved by " + delta + " units."); 
  }  
  
  void dbgPrintMyStats() {
    if (debug) {
      println(dbgMyName + "offsx = " + offsX);
      println(dbgMyName + "offsy = " + offsY);
      println(dbgMyName + "rotx = " + rotX);
      println(dbgMyName + "roty = " + rotY);
      println(dbgMyName + "zoomscale = " + zoomScale);
    }
  }
  
  void positionOnEurope(int mapSizeX) {
    // should work fine with mapSizeX = 4000 for now
    /*
    offsX = -307;
    offsY = 1399;
    rotX = 0.475;
    rotY = 0.475;
    zoomScale = 4840;
    */
    
    offsX = -89;
    offsY = 691;
    rotX = -0.354;
    rotY = 0.435;
    zoomScale = 2240;
  
    update();
  } 
  
  void positionOnLondon() {
    
    offsX = -282;
    offsY = 461;
    rotX = -0.284;
    rotY = 1.086;
    zoomScale = 2.818;
  
    update();
  } 


  void setInitialTranslate() {
    // translate(initialTx, initialTy, 0);
    translate(width/2.0, height/2.0, 0);
  }
  
  void clearInitialTranslate() {
    // translate(-initialTx, -initialTy, 0);
    translate(-width/2.0, -height/2.0, 0);
  }
    

  
}

