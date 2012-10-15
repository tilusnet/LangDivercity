class Cities {
  private ArrayList<CityData> cities;
  private String dbgMyName;
  private 
  
  class CityData {
    private String name;
    private LatLong loc;
    private color col;
    private int bs;
    private int maxBs;
    CityData(String name, LatLong loc, color col, int barSize, int maxBarSize) {
      this.name = name;
      this.loc = loc;
      this.col = col;
      this.bs = barSize;
      this.maxBs = maxBarSize;
    }
    LatLong getLocation() {
      return loc;
    }
    color getColour() {
      return col;
    } 
    void incBS() {
      if (bs < maxBs)
        bs++;
    }
    void incBS(int increment) {
      if (bs + increment < maxBs)
        bs += increment;
      else
        bs = maxBs; 
    }
    int getBS() {
      return bs;
    }
  }
  
  Cities() {
    int bs = 2;
    cities = new ArrayList<CityData>();
    cities.add(new CityData("Berlin", new LatLong(52, 13),         #990000, bs, 400)); // Berlin
    cities.add(new CityData("Sydney", new LatLong(-33.86, 151.21), #009900, bs, 200)); // Sydney
    cities.add(new CityData("San Francisco", new LatLong(37.8, -122.4),   #000099, bs, 300)); // San Francisco
    dbgMyName = this.getClass().getName() + "::";
  }
  
  void display(MercatorMap mm) {
    PVector cityXY;
    noStroke();
    fill(255, 0, 0, 200);
    translate(0, 0, 0.01);
    
    for (CityData cdata: cities) {
      LatLong cityLL = cdata.getLocation();
      cityXY = mm.getScreenLocation(new PVector(cityLL.getLat(), cityLL.getLong()));

      pushMatrix();
      translate(cityXY.x, cityXY.y, cdata.getBS()/2);
      fill(cdata.getColour());
      box(1,1,cdata.getBS());
      cdata.incBS();
      popMatrix();

      dbgPrintCityLocation(cityLL, cityXY);
    }
    
  }
  
  void dbgPrintCityLocation(LatLong cityLL, PVector cityXY) {
    if (debug) {
      println(dbgMyName + "city.lat = " + cityLL.getLat());
      println(dbgMyName + "city.long = " + cityLL.getLong());
      println(dbgMyName + "cityXY.x = " + cityXY.x);
      println(dbgMyName + "cityXY.y = " + cityXY.y);
    }
    
  }
}
