/*
 * DBLib
 * (c) by DocuMatrix GmbH
 */

namespace DBLib
{
  /**
   * This errordomain contains different errors which may occur using
   * the DBLib.
   */
  public errordomain DBError
  {
    CONNECTION_ERROR;
  }

  /**
   * This enum contains the possible database connection types.
   */
  public enum DBType
  {
    MYSQL;
  }

  /**
   * This class represents a database connection and provides methods
   * which have to be implemented by the database specific classes.
   */
  public abstract class Connection
  {
    /**
     * The DataSourceName object which was used to connect to the MySQL database.
     */
    public DataSourceName dsn;

    /**
     * Use this method to connect to a specific database using given connection
     * parameters.
     * @param db_type The type of the database connection. Depending on that value
     *                the specific class will be selected.
     * @param connection_string The connection string which should be passed to the driver.
     * @param user The username which should be used to connect to the database.
     * @param password The password which should be used to connect to the database.
     * @return A connection object which represents the database connection.
     * @throws DBError This error will be thrown if an error occurs while connecting to the database.
     */
    public static Connection connect( DBType db_type, string connection_string, string? user, string? password ) throws DBError.CONNECTION_ERROR
    {
      DMLogger.log.debug( 0, false, "Connecting to database." );

      DataSourceName dsn = new DataSourceName( connection_string );
      
      switch ( db_type )
      {
        case DBType.MYSQL:
          DMLogger.log.debug( 0, false, "Connecting to a MySQL database using connection string ${1}, user ${2} and password ${3}", connection_string, user ?? "(null)", password ?? "(null)" );
          return new DBLib.MySQL.Connection( dsn, user, password );
          break;

        default:
          throw new DBError.CONNECTION_ERROR( "Undefined database type passed!" );
      }
      return null;
    }

    /**
     * This method can be used to create (prepare) a statement using this connection.
     * @param stmt A string which will be used as statement code.
     * @return A new created statement object.
     */
    public Statement prepare( string stmt )
    {
      return new Statement( this, stmt );
    }
  }

  /**
   * This class can be used to parse and use data source names.
   */ 
  public class DataSourceName : GLib.Object
  {
    /**
     * Every value in the given dsn-string will be inserted into this hash.
     */
    public HashTable<string?,string?> values;

    /**
     * Create a new DataSourceName object using a given dsn string.
     * @param dsn A data source name string which will be parsed.
     */
    public DataSourceName( string dsn )
    {
      this.values = new HashTable<string?,string?>( str_hash, str_equal );

      string[] parts = dsn.split( ";" );
      for ( int i = 0; i < parts.length; i ++ )
      {
        string[] kv = parts[ i ].split( "=" );

        if ( kv.length == 2 )
        {
          this.values[ kv[ 0 ] ] = kv[ 1 ];
        }
        else
        {
          DMLogger.log.warning( 0, false, "Invalid token '${1}' in data source name '${2}'!", parts[ i ], dsn );
        }
      }
    }

    /**
     * This method will return the value for the given key.
     * @param key A key whichs value should be returned.
     * @return The value for the given key.
     */
    public string get( string key )
    {
      return this.values[ key ];
    }
  }

  /**
   * Objects of this class represent a statement which can be executed using a DBLib.Connection.
   */
  public class Statement : GLib.Object
  {
    /**
     * This connection will be used to execute the statement.
     */
    public Connection conn;

    /**
     * This is the code of the statement.
     */
    public string code;
    
    /**
     * This constructor creates a new Statement object which will be executed on the given connection.
     * @param conn A connection object which will be used to execute the statement.
     * @param code The statement code.
     */
    public Statement( Connection conn, string code )
    {
      this.conn = conn;
      this.code = code;
    }
  }
}
