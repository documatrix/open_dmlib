using Testlib;

public class TestDBLib
{
  public static int main( string[] args )
  {
    GLib.Test.init( ref args );

    GLib.TestSuite ts_dblib = new GLib.TestSuite( "DBLib" );
    GLib.TestSuite.get_root( ).add_suite( ts_dblib );

    GLib.TestSuite ts_data_source_name = new GLib.TestSuite( "DataSourceName" );
    ts_data_source_name.add(
      new GLib.TestCase(
        "test_n",
        TestDBLib.default_setup,
        TestDBLib.test_data_source_name_n,
        TestDBLib.default_teardown
      )
    );
    ts_dblib.add_suite( ts_data_source_name );
    
    GLib.TestSuite ts_connection = new GLib.TestSuite( "Connection" );
    
    ts_connection.add(
      new GLib.TestCase(
        "test_f_connect",
        TestDBLib.default_setup,
        TestDBLib.test_connection_f_connect,
        TestDBLib.default_teardown
      )
    );
    
    ts_dblib.add_suite( ts_connection );

    GLib.TestSuite ts_mysql = new GLib.TestSuite( "MySQL" );

    GLib.TestSuite ts_mysql_connection = new GLib.TestSuite( "Connection" );
    ts_mysql_connection.add(
      new GLib.TestCase(
        "test_f_connect",
        TestDBLib.default_setup,
        TestDBLib.test_mysql_connection_f_connect,
        TestDBLib.default_teardown
      )
    );
    ts_mysql.add_suite( ts_mysql_connection );

    ts_dblib.add_suite( ts_mysql );
    
    GLib.Test.run( );
    return 0;
  }

  /**
   * This testcase tests the constructor of the DataSourceName class.
   */
  public static void test_data_source_name_n( )
  {
    DBLib.DataSourceName dsn = new DBLib.DataSourceName( "var1=val1;var2=val2;var3;var2=val2.1" );
    assert( dsn != null );
    assert( dsn[ "var1" ] == "val1" );
    assert( dsn[ "var2" ] == "val2.1" );
    assert( dsn[ "var3" ] == null );
  }
  
  /**
   * This testcase tests the connection to a database.
   */
  public static void test_connection_f_connect( )
  {
    try
    {
      DBLib.Connection c = DBLib.Connection.connect( DBLib.DBType.MYSQL, "hostname=not_existing;database=none", null, null );
      assert_not_reached( );
    }
    catch ( DBLib.DBError.CONNECTION_ERROR e )
    {
      assert( true );
    }
  }

  /**
   * This testcase tests the connection to a MySQL database.
   */
  public static void test_mysql_connection_f_connect( )
  {
    try
    {
      DBLib.Connection c = DBLib.Connection.connect( DBLib.DBType.MYSQL, "hostname=localhost", "root", null );
      assert( c != null );
      assert( c.dsn != null );
    }
    catch ( DBLib.DBError.CONNECTION_ERROR e )
    {
      assert_not_reached( );
    }
  }

  /**
   * This is the default setup method for the DBLib tests.
   * It will setup a DMLogger.Logger object and then invoke the default_setup method from Testlib.
   */
  public static void default_setup( )
  {
    DMLogger.log = new DMLogger.Logger( null );
    DMLogger.log.set_config( true, "../log/messages.mdb" );
    DMLogger.log.start_threaded( );
    Testlib.default_setup( );
  }

  /**
   * This is the default teardown method for the DBLib tests.
   * It will stop the DMLogger.Logger and then invoke the default_teardown method from Testlib.
   */
  public static void default_teardown( )
  {
    if ( DMLogger.log != null )
    {
      DMLogger.log.stop( );
    }
    Testlib.default_teardown( );
  }
}
