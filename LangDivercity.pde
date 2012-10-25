

boolean debug = false;
int count = 0;

UIManager   myUim;
WorldMap3D  myMap;
MercatorMap mercMap;
// Cities      myCities;
Map<String,City>      myCities;
skDB        mySkDB;
LangID      myLangId;

int screenSizeX = 800;
int screenSizeY = 600;
int drawAreaSizeX = 1000;
int drawAreaSizeY = drawAreaSizeX; 


void setup() {
  size(screenSizeX, screenSizeY, OPENGL);
  colorMode(HSB, 360, 100, 100);
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
  
  println(myLangId.getColourHue("da_DK"));
  
  draw_once();
  
}


void draw_once() {
  
  // println(frameRate);
  
  
  // println("Doing...");
  if (mySkDB.next()) {
    if (++count % 1000 == 0) println(count);
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
    
    
    // Render 
    Iterator entries = myCities.entrySet().iterator();
    
    while (entries.hasNext()) {
    // for (Map.Entry<String,City> entry : myCities.entrySet()) {
      Map.Entry entry = (Map.Entry) entries.next();
      String cityName = (String)entry.getKey();
      // TODO print city
      City city = (City)entry.getValue();
      
      renderCityBar(city);
    }
    
  } else
  println("Done.");
    
    
    

  // myMap.update();
  // myCities.display(mercMap);
  
  // dbgPrintMem();

}

void draw() {
  background(0);
  noStroke();
  myUim.update();
  draw_once();
  myMap.update();
  
}

void mouseDragged() {
  myUim.mouseDragged();
}


void renderCityBar(City city) {
  
  int barBase = 0;
  int iStop = 20000, oStop = 500;

  Iterator entries = city.getLangCountsSorted().entrySet().iterator();
  
  while (entries.hasNext()) {
  // for (Map.Entry<String,Integer> entry : city.getLangCountsSorted().entrySet()) {
    Map.Entry entry = (Map.Entry) entries.next();
    String langId = (String)entry.getKey();
    int langCount = (Integer)entry.getValue();
  
    LatLong cityLL = city.getLocation();
    PVector cityXY = mercMap.getScreenLocation(new PVector(cityLL.getLat(), cityLL.getLong()));
    
    pushMatrix();
    int barHeightCentre = barBase + langCount/2;
    
    translate(cityXY.x, cityXY.y, map(barHeightCentre, 0, iStop, 0, oStop));
    int colHue = myLangId.getColourHue(langId);
    fill(colHue, 50, 50);

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


  
  
