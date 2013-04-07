import de.bezier.data.sql.*;
import java.sql.SQLException;
import java.util.Date;


class skDB extends SQLite {
  
 
  skDB(PApplet pa, String database) {
    super(pa, database);
    // db = new SQLite( pa, database );  // open database file

    if ( connect() )
    {
      
        try {
          
          statement = connection.createStatement();
          statement.setQueryTimeout(1);
          
          //printListTables();
          // printTimestamps();
          // printTimestampsLondon();
          
          
        } catch(SQLException e) {
          println(e.getMessage());
        }
    }
  }
  
  
  private void printListTables() {
    // list table names
    query( "SELECT name as \"Name\" FROM SQLITE_MASTER where type=\"table\"" );
    
    while (next()) {
        println( getString("Name") );
    }
  }
  
  private void printTimestamps() {
    long cnt = 0;
    
    query( "SELECT ts FROM sk_data AS s LIMIT 10000" );
    
    while (next())
    {
      println(getDateTimestamp("ts"));
      cnt++;
    }
    println(cnt + " records.");
  }

  private void printTimestampsLondon() {
    long cnt = 0, st, el;
    
    
    st = System.currentTimeMillis();    
    query( "SELECT * from sk_data as s LEFT JOIN ip_group_city as i ON s.ip_start=i.ip_start WHERE i.city LIKE 'London'" );
    el = System.currentTimeMillis() - st;
    println(String.format("Query runtime = %d min %02d.%03d sec", el/1000/60, (el / 1000) % 60 , el % 1000));    
    
    st = System.currentTimeMillis();    
    while (next())
    {
      // println(getTimestamp("ts"));
      cnt++;
      //if (cnt % 1000 == 0) println(cnt + "...");
    }
    println(cnt + " records.");
    el = System.currentTimeMillis() - st;
    println(String.format("Loop through runtime = %d min %02d.%03d sec", el/1000/60, (el / 1000) % 60 , el % 1000));    
  }

  Date getDateTimestamp(String field) {
    return new Date(getLong(field) * 1000);
  }
}
