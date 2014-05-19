/*
 * This file contains the MySQL driver of the DBLib.
 * (c) 2014 by DocuMatrix GmbH
 */

namespace DBLib
{
  namespace MySQL
  {
    public class Connection : DBLib.Connection
    {
      /**
       * The MySQL database handle.
       */
      public Mysql.Database dbh;
   
      /**
       * This constructor will create a new database connection to a MySQL database.
       * @param dsn A DataSourceName object containing the informations which will be passed to the MySQL library.
       * @param user A user which should be used to connect to the database.
       * @param password A password which should be used to connect to the database.
       * @throws DBLib.DBError if an error occurs while connecting to the MySQL database.
       */
      public Connection( DataSourceName dsn, string? user, string? password ) throws DBLib.DBError
      {
        this.dsn = dsn;
        
        this.dbh = new Mysql.Database( );

        uint port = 0;
        if ( dsn[ "port" ] != null )
        {
          port = (uint)uint64.parse( dsn[ "port" ] );
        }
        if ( !this.dbh.real_connect( dsn[ "host" ], user, password, dsn[ "database" ], port, dsn[ "unix_socket" ] ) )
        {
          throw new DBLib.DBError.CONNECTION_ERROR( "Could not connect to MySQL database! %u: %s", this.dbh.errno( ), this.dbh.error( ) );
        }
      }
    }
  }
}
