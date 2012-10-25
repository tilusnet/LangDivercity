class Cities {
  private ArrayList<City> cities;
  private String dbgMyName;
  
  Cities() {
    int bs = 0;
    cities = new ArrayList<City>();
    cities.add(new City("London", new LatLong(51.5002, -0.1262),         #FFFFFF, bs, 400)); 
    //cities.add(new City("Berlin", new LatLong(52, 13),         #990000, bs, 400)); 
    //cities.add(new City("Sydney", new LatLong(-33.86, 151.21), #009900, bs, 200)); 
    //cities.add(new City("San Francisco", new LatLong(37.8, -122.4),   #000099, bs, 300)); 
    dbgMyName = this.getClass().getName() + "::";
  }
  
  void display(MercatorMap mm) {
    PVector cityXY;
    noStroke();
    fill(255, 0, 0, 100);
    translate(0, 0, 0.01);
    
    for (City cdata: cities) {
      LatLong cityLL = cdata.getLocation();
      cityXY = mm.getScreenLocation(new PVector(cityLL.getLat(), cityLL.getLong()));

      pushMatrix();
      translate(cityXY.x, cityXY.y, cdata.getBS()/2);
      fill(cdata.getColour(), 100);
      box(1,1,cdata.getBS());
      cdata.incBS();
      popMatrix();

      // dbgPrintCityLocation(cityLL, cityXY);
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
