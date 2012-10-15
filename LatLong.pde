class LatLong {
  PVector ll;
  
  LatLong(float lat, float lng) {
    ll = new PVector(lng, lat);
  }
  
  float getLong() {
    return ll.x;
  }
  
  float getLat() {
    return ll.y;
  }
  
  void setLong(float lng) {
   ll.x = lng;
  }
  
  void setLat(float lat) {
    ll.y = lat;
  }
  
  
}
