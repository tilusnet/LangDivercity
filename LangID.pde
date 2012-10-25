import de.bezier.data.sql.*;

class LangID {
  /*
  String langId;
  LatLong langLocation;
  int colhue;
 */ 
  SQLite db;
  
  LangID(PApplet pa) {
    db = new SQLite(pa, "skdownl-ip.sqlite");
    db.connect();
  }
  
  public LatLong getLangLocation(String langId) {
    db.query("SELECT latitude,longitude FROM languages WHERE lang_id=\"" + langId + "\"");
    if (db.next()) {
      return new LatLong(db.getFloat("latitude"), db.getFloat("longitude")); 
    } else
      return null;
  }
  
  public int getColourHue(String langId) {
    db.query("SELECT hue FROM languages WHERE lang_id=\"" + langId + "\"");
    if (db.next()) {
      return db.getInt("hue"); 
    } else
      return -1;
  }
  
}
