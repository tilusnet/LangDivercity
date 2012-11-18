import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

import processing.opengl.*;


float ts;
boolean debug = false;
boolean dbgRenderTime = false;
boolean dbgRenderTime2 = false;
boolean dbgZoom = true;
int datactr = 0;
int drawctr = 0;
int drawnBars = 0;
boolean datadone = false;

// UIManager   myUim;
PeasyCam myUim;
WorldMap3D  myMap;
MercatorMap mercMap;
// Cities      myCities;
Map<String,City>      myCities;
Map<String,Language>  myLanguages;
skDB        mySkDB, myLangDB;

PFont       myFont;

int screenSizeX = 1600;
int screenSizeY = 900;
int drawAreaSizeX = 1000;
int drawAreaSizeY = drawAreaSizeX; 


void setup() {
  size(screenSizeX, screenSizeY, OPENGL);
  colorMode(HSB, 360, 100, 100, 100);
  myFont = createFont("CharterBT-Bold-48",48,true);
  smooth();
  
  // myUim = new UIManager(drawAreaSizeX, drawAreaSizeY);
  myUim = new PeasyCam(this, 500);
  myUim.setMinimumDistance(0);
  // myUim.setYawRotationMode();
  // reassign particular drag gestures, or set them to null; more: http://mrfeinberg.com/peasycam
  myUim.setCenterDragHandler(null);
  myUim.setRightDragHandler(myUim.getPanDragHandler());
  myUim.setWheelHandler(new PeasyWheelHandler() {
    public void handleWheel(final int delta) {
      loop();
      myUim.getZoomWheelHandler().handleWheel(delta);
    }
  });
  
  myMap = new WorldMap3D(drawAreaSizeX, drawAreaSizeY, 4000);
  myCities = new HashMap<String,City>();
  myLanguages = new HashMap<String,Language>();
  
  // myUim.positionOnEurope(myMap.getMapSizeX());
  //myUim.positionOnLondon();
  myMap.setTint(255, 60);
  
  mercMap = myMap.getMercatorMap();

  println("Loading data...");  
  ts = millis();
  mySkDB = new skDB(this, "skdownl-ip.sqlite");
  mySkDB.query("SELECT ts,lang_id,country_code,country_name,city,latitude,longitude FROM combo WHERE city <> ''");
  // mySkDB.query("SELECT * from sk_data as s LEFT JOIN ip_group_city as i ON s.ip_start=i.ip_start WHERE city <> ''"); 
  println("City data loaded in " + (millis() - ts)/1000 + " s.");
  
  myLangDB = new skDB(this, "skdownl-ip.sqlite");
  myLangDB.query("SELECT lang_id,latitude,longitude,hue FROM languages");
  
}




void readdata() {
  
  ts = millis();
  while (myLangDB.next()) {
    String cLangId = myLangDB.getString("lang_id");
    float cLat = myLangDB.getFloat("latitude");
    float cLong = myLangDB.getFloat("longitude");
    int cHue = Integer.parseInt(myLangDB.getString("hue"));
    myLanguages.put(cLangId, new Language(cLangId, new LatLong(cLat, cLong), cHue));
  }
  if (dbgRenderTime) println("Language data loaded in " + (millis() - ts)/1000 + " s.");
  
  
  int atOnceCtr = 5000;
  while (mySkDB.next()) {
    atOnceCtr--;
    
    if (++datactr % 1000 == 0) println(datactr);
    // Update myCities with the current row 
    String cCityName = mySkDB.getString("city");
    String cLangId = mySkDB.getString("lang_id");
    // City city;
    
    if (!cCityName.isEmpty()) {
      if (myCities.containsKey(cCityName)) {
        // println(cityName + ": yes");
        City city = (City) myCities.get(cCityName);
        city.addLangOccurr(cLangId, 1);
      } else {
        // println(cityName + ": no");
        LatLong cityLatLong = new LatLong(mySkDB.getFloat("latitude"), mySkDB.getFloat("longitude"));
        City city = new City(cCityName, cityLatLong, mySkDB.getString("country_code"), mercMap);
        myCities.put(cCityName, city);
      }

      // Render: updates only a single citybar block, the one that corresponds to the current DB entry
      // renderCityBar(city);

    }
    if (atOnceCtr <= 0) break;
  }
  
  if (!mySkDB.next()) datadone=true;
  
}

void render() {

  // println("!!!!");
  Iterator entries = myCities.entrySet().iterator();
  int ctr = 0;
  float ts_loc;
  
  while (entries.hasNext()) {
  // for (Map.Entry<String,City> entry : myCities.entrySet()) {
    Map.Entry entry = (Map.Entry) entries.next();
    String cityName = (String)entry.getKey();
    // TODO print city
    City city = (City)entry.getValue();
    
    ts_loc = millis();
    renderCityBar(city);
    if (dbgRenderTime2) println(" CityBarRender =  " + (millis() - ts_loc) + " ms.");
    
    
    // if (++ctr > 100) break; 
    
  }
}

void draw() {
  background(0);
  noStroke();

  printRenderedBarNum(drawnBars);
  printFPS();  

  drawnBars = 0;

/*
  fill(0,0,99);
  textFont(myFont,16);        
  textAlign(LEFT);
  text("Dummy",100,180);
 */ 

  ts = millis();
  // myUim.update();
  if (dbgRenderTime) println("UiM =  " + (int)(millis() - ts) + " ms.");
  
  ts = millis();
  readdata();
  if (dbgRenderTime) println("Readdata =  " + (int)(millis() - ts) + " ms.");
  
  // println("@@ " + drawctr);
  ts = millis();
  if (++drawctr % 1 == 0) render();
  if (dbgRenderTime) println("Render =  " + (int)(millis() - ts) + " ms.");
  // if (datadone) render();
  
  ts = millis();
  myMap.update();
  if (dbgRenderTime) println("MapRender =  " + (int)(millis() - ts) + " ms.");
  
  // el = System.currentTimeMillis() - st;
  // println(String.format("Draw runtime = %d min %02d.%03d sec", el/1000/60, (el / 1000) % 60 , el % 1000));  
  
  if (datadone) noLoop();
}

void mouseDragged() {
  loop();
  // myUim.mouseDragged();
}


void renderCityBar(City city) {
  
  int barBase = 0;
  int iStop = 20000, oStop = 500;
  boolean b = false; // = city.getCityName().equals("London");
  PVector pvCityLL = new PVector();
  int cnt = 0;

  Iterator entries = city.getLangCountsSorted().entrySet().iterator();
  
  if (b)       println("~~~");
  
  strokeWeight(4);
  while (entries.hasNext()) {
    ++cnt;
  // for (Map.Entry<String,Integer> entry : city.getLangCountsSorted().entrySet()) {
    Map.Entry entry = (Map.Entry) entries.next();
    String langId = (String)entry.getKey();
    int langCount = (Integer)entry.getValue();
    PVector cityXY = city.getXYLocation();

    if (b) {
      println(langId + ':' + langCount);
    }

    pushMatrix();
    int barHeightCentre = barBase + langCount/2;
    int barHeight = barBase;
        
    translate(cityXY.x, cityXY.y, map(barHeight, 0, iStop, 0, oStop));
    // translate(cityXY.x, cityXY.y, map(barHeightCentre, 0, iStop, 0, oStop));
    
    if (city.getCountry().equals(langId.substring(3,5))) {
      stroke(0, 0, 99, 20); // white
      // fill(0, 0, 99); // white
    } else {
      int colHue = myLanguages.get(langId).getColourHue();
      stroke(colHue, 99, 66);
      // fill(colHue, 50, 50);
    }

    line(0,0,0, 0,0, map(langCount, 0, iStop, 0, oStop));
    // box(1,1,map(langCount, 0, iStop, 0, oStop));
    drawnBars++;
    // cdata.incBS();

    popMatrix();

    barBase += langCount;
    
    /*
    if (city.getCityName().equals("Budapest")) {
      println("  [" + langId + "] = " + langCount);
    }
    */
  
  }
  
  strokeWeight(1);

  // println(String.format(" %40s - %d languages.", city.getCityName(), cnt));
}

void dbgPrintMem() {
  long freeMem = Runtime.getRuntime().freeMemory() / 1024 / 1024;
  long maxMem = Runtime.getRuntime().maxMemory() / 1024 / 1024;
  long allocated = Runtime.getRuntime().totalMemory() / 1024 / 1024;
  println(freeMem + "M / " + maxMem + "M (allocated = " + allocated + "M)");
}


void printFPS() {
  // oversampled fonts tend to look better
  textFont(myFont,18);
  // white float frameRate
  fill(255);
  text("fps = " + (int)frameRate,20,120);
}
  
void printRenderedBarNum(int num) {
  textFont(myFont,18);
  fill(255);
  text("bars = " + num,20,270);
}

