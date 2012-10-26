

boolean debug = false;
int datactr = 0;
int drawctr = 0;
boolean datadone = false;

UIManager   myUim;
WorldMap3D  myMap;
MercatorMap mercMap;
// Cities      myCities;
Map<String,City>      myCities;
skDB        mySkDB;
LangID      myLangId;
PFont       myFont;

int screenSizeX = 1600;
int screenSizeY = 900;
int drawAreaSizeX = 1000;
int drawAreaSizeY = drawAreaSizeX; 


void setup() {
  size(screenSizeX, screenSizeY, OPENGL);
  colorMode(HSB, 360, 100, 100);
  myFont = createFont("CharterBT-Bold-48",48,true);
  smooth();
  
  hint(ENABLE_STROKE_PERSPECTIVE);
  
  myUim = new UIManager(drawAreaSizeX, drawAreaSizeY);
  myMap = new WorldMap3D(drawAreaSizeX, drawAreaSizeY, 4000);
  myCities = new HashMap<String,City>();
  myLangId = new LangID(this);
  
  // myUim.positionOnEurope(myMap.getMapSizeX());
  myUim.positionOnLondon();
  myMap.setTint(255, 150);
  
  mercMap = myMap.getMercatorMap();

  println("Loading data...");  
  mySkDB = new skDB(this, "skdownl-ip.sqlite");
  mySkDB.query("SELECT ts,lang_id,country_code,country_name,city,latitude,longitude FROM combo WHERE city <> ''");
  // mySkDB.query("SELECT * from sk_data as s LEFT JOIN ip_group_city as i ON s.ip_start=i.ip_start WHERE city <> ''"); 
  println("Data loaded.");
  
  // println(myLangId.getColourHue("da_DK"));
  
  // draw_once();
  
}




void readdata() {
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
        City city = new City(cCityName, cityLatLong, mySkDB.getString("country_code"));
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
  
  while (entries.hasNext()) {
  // for (Map.Entry<String,City> entry : myCities.entrySet()) {
    Map.Entry entry = (Map.Entry) entries.next();
    String cityName = (String)entry.getKey();
    // TODO print city
    City city = (City)entry.getValue();
    
    renderCityBar(city);
    
  }
}

void draw() {
  background(0);
  noStroke();
/*
  fill(0,0,99);
  textFont(myFont,16);        
  textAlign(LEFT);
  text("Dummy",100,180);
 */ 

  long st, el;
  st = System.currentTimeMillis();    
  
  myUim.update();
  readdata();
  // println("@@ " + drawctr);
  if (++drawctr % 1 == 0) render();
  // if (datadone) render();
  myMap.update();
  
  el = System.currentTimeMillis() - st;
  // println(String.format("Draw runtime = %d min %02d.%03d sec", el/1000/60, (el / 1000) % 60 , el % 1000));    
}

void mouseDragged() {
  myUim.mouseDragged();
}


void renderCityBar(City city) {
  
  int barBase = 0;
  int iStop = 20000, oStop = 500;
  boolean b = false; // = city.getCityName().equals("London");

  Iterator entries = city.getLangCountsSorted().entrySet().iterator();
  
  if (b)       println("~~~");
  while (entries.hasNext()) {
  // for (Map.Entry<String,Integer> entry : city.getLangCountsSorted().entrySet()) {
    Map.Entry entry = (Map.Entry) entries.next();
    String langId = (String)entry.getKey();
    int langCount = (Integer)entry.getValue();
    if (b) {
      println(langId + ':' + langCount);
    }
  
    LatLong cityLL = city.getLocation();
    PVector cityXY = mercMap.getScreenLocation(new PVector(cityLL.getLat(), cityLL.getLong()));
    
    pushMatrix();
    int barHeightCentre = barBase + langCount/2;
    
    translate(cityXY.x, cityXY.y, map(barHeightCentre, 0, iStop, 0, oStop));
    if (city.getCountry().equals(langId.substring(3,4))) {
      fill(0, 0, 99); // white
    } else {
      int colHue = myLangId.getColourHue(langId);
      fill(colHue, 50, 50);
    }

    box(1,1,map(langCount, 0, iStop, 0, oStop));
    // cdata.incBS();
    popMatrix();

    barBase += langCount;
  }

  

  
}

void dbgPrintMem() {
  long freeMem = Runtime.getRuntime().freeMemory() / 1024 / 1024;
  long maxMem = Runtime.getRuntime().maxMemory() / 1024 / 1024;
  long allocated = Runtime.getRuntime().totalMemory() / 1024 / 1024;
  println(freeMem + "M / " + maxMem + "M (allocated = " + allocated + "M)");
}


  
  
