class City {
    private String name;
    private LatLong locGeo;
    private PVector locXY;
    String country;
    Map<String,Integer> langCount;
    Map<String,Integer> langCountSorted;
    
    private color col;
    private int bs;
    private int maxBs;
    
    class ValueComparator implements Comparator<String> {
    
        Map<String, Integer> base;
        public ValueComparator(Map<String, Integer> base) {
            this.base = base;
        }
    
        // Note: this comparator imposes orderings that are inconsistent with equals.    
        public int compare(String a, String b) {
            if (base.get(a) >= base.get(b)) {
                return -1;
            } else {
                return 1;
            } // returning 0 would merge keys
        }
    }    
    
    
    City(String name, LatLong loc, String country, MercatorMap mm) {
      this.name = name;
      this.locGeo = loc;
      this.locXY = new PVector(mm.getScreenX(locGeo.getLong()), mm.getScreenY(locGeo.getLat()));
      this.country = country;
      this.langCount = new HashMap<String,Integer>();
      this.langCountSorted = new TreeMap<String,Integer>(new ValueComparator(this.langCount));

      this.col = #999900;
      this.bs = 2;
      this.maxBs = 400;
    }

    
    String getCityName() {
      return name;
    }

    LatLong getGeoLocation() {
      return locGeo;
    }
    
    PVector getXYLocation() {
      return locXY;
    }
      
    String getCountry() {
      return country;
    }
    
    // Other stuff vvv
    
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
    
    public void addLangOccurr(String langId, int count) {
      int currOccurr;
      try {
        currOccurr = (Integer) langCount.get(langId);
      } catch(Exception e) {
        currOccurr = 0; 
      }
      langCount.put(langId, currOccurr + count);
      langCountSorted.clear();
      langCountSorted.putAll(langCount);
    }
    
    public Map<String,Integer> getLangCountsSorted() {
      return langCountSorted;
    }

}
