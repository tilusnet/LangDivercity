import de.bezier.data.sql.*;


class skDB {
  
  skDB(PApplet pa, String database) {
    
    SQLite db = new SQLite( pa, database );  // open database file

    if ( db.connect() )
    {
        // list table names
        db.query( "SELECT name as \"Name\" FROM SQLITE_MASTER where type=\"table\"" );
        
        while (db.next())
        {
            println( db.getString("Name") );
        }
        
        // read all in table "table_one"
        db.query( "SELECT * FROM table_one" );
        
        while (db.next())
        {
            println( db.getString("field_one") );
            println( db.getInt("field_two") );
        }
    }
    
    
  }
}
