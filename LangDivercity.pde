

boolean debug = false;

UIManager   myUim;
WorldMap3D  myMap;
MercatorMap mercMap;
Cities      myCities;
skDB        mySkDB;

int screenSizeX = 800;
int screenSizeY = 600;
int drawAreaSizeX = 1000;
int drawAreaSizeY = drawAreaSizeX; 


void setup() {
  size(screenSizeX, screenSizeY, P3D);
  // smooth();
  
  hint(ENABLE_STROKE_PERSPECTIVE);
  
  myUim = new UIManager(drawAreaSizeX, drawAreaSizeY);
  myMap = new WorldMap3D(drawAreaSizeX, drawAreaSizeY, 4000);
  myCities = new Cities();
  // myUim.positionOnEurope(myMap.getMapSizeX());
  myMap.setTint(255, 150);
  
  mercMap = myMap.getMercatorMap();
  
  mySkDB = new skDB(this, "skdownl-ip.sqlite");
  
}


void draw() {
  background(0);
  noStroke();
  myUim.update();

  myMap.update();
  myCities.display(mercMap);
  
  // dbgPrintMem();

}

void mouseDragged() {
  myUim.mouseDragged();
}

void dbgPrintMem() {
  long freeMem = Runtime.getRuntime().freeMemory() / 1024 / 1024;
  long maxMem = Runtime.getRuntime().maxMemory() / 1024 / 1024;
  long allocated = Runtime.getRuntime().totalMemory() / 1024 / 1024;
  println(freeMem + "M / " + maxMem + "M (allocated = " + allocated + "M)");
}


  
  
