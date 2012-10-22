import de.bezier.data.sql.*;
import java.sql.SQLException;


class skDB {
  
  private SQLite db;
  
  skDB(PApplet pa, String database) {
    
    db = new SQLite( pa, database );  // open database file

    if ( db.connect() )
    {
      
        try {
          
          db.statement = db.connection.createStatement();
          db.statement.setQueryTimeout(1);
          
          //printListTables();
          // printTimestamps();
          //printTimestampsLondon();
          
          
        } catch(SQLException e) {
          println(e.getMessage());
        }
    }
  }
  
  void query(String q) {
    db.query(q);
  }
  
  private void printListTables() {
    // list table names
    db.query( "SELECT name as \"Name\" FROM SQLITE_MASTER where type=\"table\"" );
    
    while (db.next()) {
        println( db.getString("Name") );
    }
  }
  
  private void printTimestamps() {
    long cnt = 0;
    
    db.query( "SELECT ts FROM sk_data AS s LIMIT 10000" );
    
    while (db.next())
    {
      println(getTimestamp("ts"));
      cnt++;
    }
    println(cnt + " records.");
  }

  private void printTimestampsLondon() {
    long cnt = 0, st, el;
    
    
    st = System.currentTimeMillis();    
    db.query( "SELECT * from sk_data as s LEFT JOIN ip_group_city as i ON s.ip_start=i.ip_start WHERE i.city LIKE 'London'" );
    el = System.currentTimeMillis() - st;
    println(String.format("Query runtime = %d min %02d.%03d sec", el/1000/60, (el / 1000) % 60 , el % 1000));    
    
    st = System.currentTimeMillis();    
    while (db.next())
    {
      // println(getTimestamp("ts"));
      cnt++;
      //if (cnt % 1000 == 0) println(cnt + "...");
    }
    println(cnt + " records.");
    el = System.currentTimeMillis() - st;
    println(String.format("Loop through runtime = %d min %02d.%03d sec", el/1000/60, (el / 1000) % 60 , el % 1000));    
  }

  Date getTimestamp(String field) {
    return new Date(db.getLong("ts") * 1000);
  }
}
