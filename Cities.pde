class Cities {
  private ArrayList<LatLong> cities;
  private String dbgMyName;
  
  
  Cities() {
    cities = new ArrayList<LatLong>();
    cities.add(new LatLong(52, 13));         // Berlin
    cities.add(new LatLong(-33.86, 151.21)); // Sydney
    cities.add(new LatLong(37.8, -122.4));   // San Francisco
    dbgMyName = this.getClass().getName() + "::";
  }
  
  void display(MercatorMap mm) {
    PVector cityXY;
    noStroke();
    fill(255, 0, 0, 200);
    translate(0, 0, 0.01);
    
    for (LatLong cityLL: cities) {
      cityXY = mm.getScreenLocation(new PVector(cityLL.getLat(), cityLL.getLong()));
      ellipse(cityXY.x, cityXY.y, 2, 2);
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
