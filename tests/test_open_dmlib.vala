using OpenDMLib;
using Testlib;

public class TestDMlib
{
  public static int main( string[] args )
  {
    GLib.Test.init( ref args );

    GLib.TestSuite ts_open_dmlib = new GLib.TestSuite( "OpenDMLib" );
    GLib.TestSuite.get_root( ).add_suite( ts_open_dmlib );


    /* Namespace Compare */
    GLib.TestSuite ts_compare = new GLib.TestSuite( "Compare" );
    ts_compare.add( new GLib.TestCase( "test_f_int16_hash", default_setup, test_compare_f_int16_hash, default_teardown ) );
    ts_compare.add( new GLib.TestCase( "test_f_int16_equal", default_setup, test_compare_f_int16_equal, default_teardown ) );
    ts_open_dmlib.add_suite( ts_compare );


    /* DMArray */
    GLib.TestSuite ts_dmarray = new GLib.TestSuite( "DMArray" );
    ts_dmarray.add( new GLib.TestCase( "test_n", default_setup, test_dmarray_n, default_teardown ) );
    ts_dmarray.add( new GLib.TestCase( "test_n_sized", default_setup, test_dmarray_n_sized, default_teardown ) );
    ts_dmarray.add( new GLib.TestCase( "test_n_with_data", default_setup, test_dmarray_n_with_data, default_teardown ) );
    ts_dmarray.add( new GLib.TestCase( "test_s_data_access", default_setup, test_dmarray_s_data_access, default_teardown ) );
    ts_dmarray.add( new GLib.TestCase( "test_s_foreach", default_setup, test_dm_array_s_foreach, Testlib.default_teardown ) );
    ts_dmarray.add( new GLib.TestCase( "test_f_clear", default_setup, test_dm_array_f_clear, default_teardown ) );
    ts_dmarray.add( new GLib.TestCase( "test_f_sort", default_setup, test_dm_array_f_sort, default_teardown ) );
    ts_open_dmlib.add_suite( ts_dmarray );

    /* Equal Functions */
    ts_open_dmlib.add( new GLib.TestCase( "test_f_uint8_equal", default_setup, test_f_uint8_equal, default_teardown ) );
    ts_open_dmlib.add( new GLib.TestCase( "test_f_uint16_equal", default_setup, test_f_uint16_equal, default_teardown ) );
    ts_open_dmlib.add( new GLib.TestCase( "test_f_uint32_equal", default_setup, test_f_uint32_equal, default_teardown ) );
    ts_open_dmlib.add( new GLib.TestCase( "test_f_int32_equal", default_setup, test_f_int32_equal, default_teardown ) );
    ts_open_dmlib.add( new GLib.TestCase( "test_f_unichar_equal", default_setup, test_f_unichar_equal, default_teardown ) );

    /* Hash Functions */
    ts_open_dmlib.add( new GLib.TestCase( "test_f_uint8_hash", default_setup, test_f_uint8_hash, default_teardown ) );
    ts_open_dmlib.add( new GLib.TestCase( "test_f_uint16_hash", default_setup, test_f_uint16_hash, default_teardown ) );
    ts_open_dmlib.add( new GLib.TestCase( "test_f_uint32_hash", default_setup, test_f_uint32_hash, default_teardown ) );
    ts_open_dmlib.add( new GLib.TestCase( "test_f_int32_hash", default_setup, test_f_int32_hash, default_teardown ) );
    ts_open_dmlib.add( new GLib.TestCase( "test_f_unichar_hash", default_setup, test_f_unichar_hash, default_teardown ) );

    GLib.TestSuite ts_color_type = new GLib.TestSuite( "ColorType" );
    ts_color_type.add(
      new GLib.TestCase(
        "test_f_to_uint8",
        default_setup,
        test_color_type_f_to_uint8,
        default_teardown
      )
    );

    ts_color_type.add(
      new GLib.TestCase(
        "test_f_from_uint8",
        default_setup,
        test_color_type_f_from_uint8,
        default_teardown
      )
    );
    ts_open_dmlib.add_suite( ts_color_type );

    GLib.TestSuite ts_color = new GLib.TestSuite( "Color" );
    ts_color.add(
      new GLib.TestCase(
        "test_n_rgb",
        default_setup,
        test_color_n_rgb,
        default_teardown
      )
    );

    ts_color.add(
      new GLib.TestCase(
        "test_n_black",
        default_setup,
        test_color_n_black,
        default_teardown
      )
    );

    ts_color.add(
      new GLib.TestCase(
        "test_n_cmyk",
        default_setup,
        test_color_n_cmyk,
        default_teardown
      )
    );

    ts_color.add(
      new GLib.TestCase(
        "test_n_high",
        default_setup,
        test_color_n_high,
        default_teardown
      )
    );

    ts_color.add(
      new GLib.TestCase(
        "test_n_grayscale",
        default_setup,
        test_color_n_grayscale,
        default_teardown
      )
    );

    ts_color.add(
      new GLib.TestCase(
        "test_n_ink",
        default_setup,
        test_color_n_ink,
        default_teardown
      )
    );

    ts_color.add(
      new GLib.TestCase(
        "test_f_equal",
        default_setup,
        test_color_f_equal,
        default_teardown
      )
    );

    ts_color.add(
      new GLib.TestCase(
        "test_f_copy",
        default_setup,
        test_color_f_copy,
        default_teardown
      )
    );

    ts_color.add(
      new GLib.TestCase(
        "test_f_get_html_color",
        default_setup,
        test_color_f_get_html_color,
        default_teardown
      )
    );
    ts_open_dmlib.add_suite( ts_color );

    /*
     * Stack
     */
    GLib.TestSuite ts_stack = new GLib.TestSuite( "Stack" );
    ts_stack.add(
      new GLib.TestCase(
        "test_f_push",
        default_setup,
        test_stack_f_push,
        default_teardown
      )
    );
    ts_stack.add(
      new GLib.TestCase(
        "test_f_pop",
        default_setup,
        test_stack_f_pop,
        default_teardown
      )
    );
    ts_open_dmlib.add_suite( ts_stack );


    ts_open_dmlib.add( new GLib.TestCase( "test_f_get_trailing_utf8_byte_count", default_setup, test_f_get_trailing_utf8_byte_count, default_teardown ) );

    GLib.Test.run( );
    return 0;
  }


  /**
   * This testcase tests the int16_hash method
   */
  public static void test_compare_f_int16_hash( )
  {
    int16 u1 = int16.MIN;
    int16 u2 = int16.MIN;
    for( ; u1 < int16.MAX; u1++, u2++ )
    {
      GLib.assert( Compare.int16_hash( u1 ) == Compare.int16_hash( u2 ) );
    }

    u1 = int16.MIN;
    u2 = int16.MIN + 1;
    for( ; u1 < int16.MAX; u1++, u2++ )
    {
      GLib.assert( Compare.int16_hash( u1 ) != Compare.int16_hash( u2 ) );
    }
  }

  /**
   * This testcase tests the int16_equal method
   */
  public static void test_compare_f_int16_equal( )
  {
    int16 u1 = int16.MIN;
    int16 u2 = int16.MIN;
    for( ; u1 < int16.MAX; u1++, u2++ )
    {
      GLib.assert( Compare.int16_equal( u1, u2 ) );
    }

    u1 = int16.MIN;
    u2 = int16.MIN + 1;
    for( ; u1 < int16.MAX; u1++, u2++ )
    {
      GLib.assert( !Compare.int16_equal( u1, u2 ) );
    }

    u1 = int16.MIN + 1;
    u2 = int16.MIN;
    for( ; u1 < int16.MAX - 1; u1++, u2++ )
    {
      GLib.assert( !Compare.int16_equal( u1, u2 ) );
    }
  }


  /**
   * This test-case tests the to_uint8 method of the ColorType enum.
   */
  public static void test_color_type_f_to_uint8( )
  {
    assert( ColorType.BLACK.to_uint8( ) == 0 );
    assert( ColorType.HIGH.to_uint8( ) == 1 );
    assert( ColorType.INK.to_uint8( ) == 2 );
    assert( ColorType.RGB.to_uint8( ) == 3 );
    assert( ColorType.CMYK.to_uint8( ) == 4 );
    assert( ColorType.GRAY.to_uint8( ) == 5 );
  }

  /**
   * This test-case tests the from_uint8 method of the ColorType enum.
   */
  public static void test_color_type_f_from_uint8( )
  {
    assert( ColorType.from_uint8( 0 ) == ColorType.BLACK );
    assert( ColorType.from_uint8( 1 ) == ColorType.HIGH );
    assert( ColorType.from_uint8( 2 ) == ColorType.INK );
    assert( ColorType.from_uint8( 3 ) == ColorType.RGB );
    assert( ColorType.from_uint8( 4 ) == ColorType.CMYK );
    assert( ColorType.from_uint8( 5 ) == ColorType.GRAY );
  }

  /**
   * This test-case tests the RGB constructor of the Color class.
   */
  public static void test_color_n_rgb( )
  {
    Color c = new Color.rgb( 10, 20, 30 );
    assert( c != null );
    assert( c.type == ColorType.RGB );
    assert( c.r == 10 );
    assert( c.g == 20 );
    assert( c.b == 30 );
  }

  /**
   * This test-case tests the black constructor of the Color class.
   */
  public static void test_color_n_black( )
  {
    Color c = new Color.black( );
    assert( c != null );
    assert( c.type == ColorType.BLACK );
  }

  /**
   * This test-case tests the CMYK constructor of the Color class.
   */
  public static void test_color_n_cmyk( )
  {
    Color c = new Color.cmyk( 10, 20, 30, 40 );
    assert( c != null );
    assert( c.type == ColorType.CMYK );
    assert( c.c == 10 );
    assert( c.m == 20 );
    assert( c.y == 30 );
    assert( c.k == 40 );
  }

  /**
   * This test-case tests the high(light) constructor of the Color class.
   */
  public static void test_color_n_high( )
  {
    Color c = new Color.high( );
    assert( c != null );
    assert( c.type == ColorType.HIGH );
  }

/**
   * This test-case tests the grayscale constructor of the Color class.
   */
  public static void test_color_n_grayscale( )
  {
    Color c = new Color.grayscale( 10 );
    assert( c != null );
    assert( c.type == ColorType.GRAY );
    assert( c.gray == 10 );
  }

  /**
   * This test-case tests the ink constructor of the Color class.
   */
  public static void test_color_n_ink( )
  {
    Color c = new Color.ink( 10 );
    assert( c != null );
    assert( c.type == ColorType.INK );
    assert( c.ink_color_nr == 10 );
  }

  /**
   * This test-case tests the equal method of the Color class.
   */
  public static void test_color_f_equal( )
  {
    Color c1 = new Color.rgb( 10, 20, 30 );
    assert( c1.equal( null ) == false );

    Color c2 = new Color.black( );
    assert( c1.equal( c2 ) == false );

    c2 = new Color.rgb( 11, 20, 30 );
    assert( c1.equal( c2 ) == false );

    c2 = new Color.rgb( 10, 21, 30 );
    assert( c1.equal( c2 ) == false );

    c2 = new Color.rgb( 10, 20, 31 );
    assert( c1.equal( c2 ) == false );

    c2 = new Color.rgb( 10, 20, 30 );
    assert( c1.equal( c2 ) == true );

    c1 = new Color.cmyk( 10, 20, 30, 40 );
    c2 = new Color.cmyk( 11, 20, 30, 40 );
    assert( c1.equal( c2 ) == false );

    c2 = new Color.cmyk( 10, 21, 30, 40 );
    assert( c1.equal( c2 ) == false );

    c2 = new Color.cmyk( 10, 20, 31, 40 );
    assert( c1.equal( c2 ) == false );

    c2 = new Color.cmyk( 10, 20, 30, 41 );
    assert( c1.equal( c2 ) == false );

    c2 = new Color.cmyk( 10, 20, 30, 40 );
    assert( c1.equal( c2 ) == true );

    c1 = new Color.grayscale( 10 );
    c2 = new Color.grayscale( 11 );
    assert( c1.equal( c2 ) == false );

    c2 = new Color.grayscale( 10 );
    assert( c1.equal( c2 ) == true );

    c1 = new Color.ink( 10 );
    c2 = new Color.ink( 11 );
    assert( c1.equal( c2 ) == false );

    c2 = new Color.ink( 10 );
    assert( c1.equal( c2 ) == true );
  }

  /**
   * This test-case tests the copy method of the Color class.
   */
  public static void test_color_f_copy( )
  {
    Color c1 = new Color.rgb( 10, 20, 30 );
    assert( c1.equal( c1.copy( ) ) == true );

    c1 = new Color.black( );
    assert( c1.equal( c1.copy( ) ) == true );

    c1 = new Color.cmyk( 10, 20, 30, 40 );
    assert( c1.equal( c1.copy( ) ) == true );

    c1 = new Color.grayscale( 10 );
    assert( c1.equal( c1.copy( ) ) == true );

    c1 = new Color.high( );
    assert( c1.equal( c1.copy( ) ) == true );

    c1 = new Color.ink( 10 );
    assert( c1.equal( c1.copy( ) ) == true );
  }

  /**
   * This test-case tests the get_html_color method of the Color class.
   */
  public static void test_color_f_get_html_color( )
  {
    Color c1 = new Color.rgb( 10, 20, 30 );
    assert( c1.get_html_color( ) == "rgb(10,20,30)" );

    c1 = new Color.black( );
    assert( c1.get_html_color( ) == "black" );

    c1 = new Color.cmyk( 10, 20, 30, 40 );
    assert( c1.get_html_color( ) == "cmyk(10,20,30,40)" );
  }

  /**
   * This test-case tests the default constructor of the DMArray Class.
   */
  public static void test_dmarray_n( )
  {
    try
    {
      DMArray<string> dm_array = new DMArray<string>( );

      GLib.assert( dm_array.length == 0 );
    }
    catch( Error e )
    {
      GLib.assert( false );
    }
  }

  /**
   * This test-case tests the .sized constructor of the DMArray Class.
   */
  public static void test_dmarray_n_sized( )
  {
    try
    {
      int size = 5;

      DMArray<string> dm_array = new DMArray<string>.sized( size );

      GLib.assert( dm_array.length == size );
    }
    catch( Error e )
    {
      GLib.assert( false );
    }
  }

  /**
   * This test-case tests the .with_data constructor of the DMArray Class.
   */
  public static void test_dmarray_n_with_data( )
  {
    try
    {
      string[] test_data = { "test1", "test2", "test3", "test4" };

      DMArray<string> dm_array = new DMArray<string>.with_data( test_data );

      GLib.assert( dm_array.length == 4 );

      GLib.assert( Testlib.string_array_equals( test_data, dm_array.get_data( ) ) );
    }
    catch( Error e )
    {
      GLib.assert( false );
    }
  }

  /**
   * This test-case tests the data access functions of the DMArray Class.
   */
  public static void test_dmarray_s_data_access( )
  {
    try
    {
      string[] test_data = { "test1", "test2", "test3", "test4" };

      DMArray<string> dm_array = new DMArray<string>.with_data( test_data );

      dm_array.push( "test5" );
      GLib.assert( dm_array.length == 5 );
      GLib.assert( dm_array.pop( ) == "test5" );

      GLib.assert( Testlib.string_array_equals( test_data, dm_array.get_data( ) ) );

      dm_array.set( 3, "test5" );
      GLib.assert( dm_array.length == 4 );

      GLib.assert( dm_array.get( 3 ) == "test5" );

      DMArray<string> next_array = new DMArray<string>( );
      next_array.push( "test6" );
      next_array.push( "test7" );
      GLib.assert( next_array.length == 2 );

      dm_array.push_array( next_array );
      GLib.assert( dm_array.length == 6 );
      GLib.assert( dm_array.pop( ) == "test7" );
      GLib.assert( dm_array.length == 5 );
      GLib.assert( dm_array.get( 4 ) == "test6" );

      next_array = new DMArray<string>( );
      dm_array = new DMArray<string>( );
      GLib.assert( next_array.pop( ) == null );

      next_array.add( "test" );
      dm_array.push( "test" );

      GLib.assert( next_array.pop( ) == dm_array.pop( ) );
    }
    catch( Error e )
    {
      GLib.assert( false );
    }
  }

  /**
   * This test-case tests the foreach-loop for DMArrays.
   */
  public static void test_dm_array_s_foreach( )
  {
    DMArray<string> dm_array = new DMArray<string>( );

    dm_array.push( "one" );
    dm_array.push( "two" );

    int index = 0;
    foreach ( string val in dm_array )
    {
      assert( val == dm_array[ index ] );
      index ++;
    }
  }

  /**
   * This test-case tests the clear-method of a DMArray.
   */
  public static void test_dm_array_f_clear( )
  {
    DMArray<string> dm_array = new DMArray<string>( );

    dm_array.push( "one" );
    dm_array.push( "two" );

    assert( dm_array.length == 2 );

    dm_array.clear( );

    assert( dm_array.length == 0 );
    assert( dm_array.get_data( ).length == 0 );
  }

  /**
   * This test-case tests the sort method of a DMArray.
   */
  public static void test_dm_array_f_sort( )
  {
    DMArray<string> dm_array = new DMArray<string>( );
    dm_array.push( "x" );
    dm_array.push( "a" );
    dm_array.push( "i" );

    assert( dm_array.length == 3 );
    assert( dm_array[ 0 ] == "x" );
    assert( dm_array[ 1 ] == "a" );
    assert( dm_array[ 2 ] == "i" );

    dm_array.sort( ( a, b ) =>
    {
      return strcmp( a, b );
    } );

    assert( dm_array[ 0 ] == "a" );
    assert( dm_array[ 1 ] == "i" );
    assert( dm_array[ 2 ] == "x" );
  }

  /**
   * This test-case tests the uint8_equal function.
   */
  public static void test_f_uint8_equal( )
  {
    try
    {
      uint8 u1 = 0;
      uint8 u2 = 0;
      for( ; u1 < uint8.MAX; u1++, u2++ )
      {
        GLib.assert( uint8_equal( u1, u2 ) );
      }

      u1 = 0;
      u2 = 1;
      for( ; u1 < uint8.MAX; u1++, u2++ )
      {
        GLib.assert( !uint8_equal( u1, u2 ) );
      }

      u1 = 1;
      u2 = 0;
      for( ; u1 < uint8.MAX; u1++, u2++ )
      {
        GLib.assert( !uint8_equal( u1, u2 ) );
      }
    }
    catch( Error e )
    {
      GLib.assert( false );
    }
  }

  /**
   * This test-case tests the uint16_equal function.
   */
  public static void test_f_uint16_equal( )
  {
    try
    {
      uint16 u1 = 0;
      uint16 u2 = 0;
      for( ; u1 < uint16.MAX; u1++, u2++ )
      {
        GLib.assert( uint16_equal( u1, u2 ) );
      }

      u1 = 0;
      u2 = 1;
      for( ; u1 < uint16.MAX; u1++, u2++ )
      {
        GLib.assert( !uint16_equal( u1, u2 ) );
      }

      u1 = 1;
      u2 = 0;
      for( ; u1 < uint16.MAX; u1++, u2++ )
      {
        GLib.assert( !uint16_equal( u1, u2 ) );
      }
    }
    catch( Error e )
    {
      GLib.assert( false );
    }
  }

  /**
   * This test-case tests the uint32_equal function.
   */
  public static void test_f_uint32_equal( )
  {
    try
    {
      uint32 u1 = 0;
      uint32 u2 = 0;
      for( ; u1 < uint16.MAX + 1000; u1++, u2++ )
      {
        GLib.assert( uint32_equal( u1, u2 ) );
      }

      u1 = 0;
      u2 = 1;
      for( ; u1 < uint16.MAX + 1000; u1++, u2++ )
      {
        GLib.assert( !uint32_equal( u1, u2 ) );
      }

      u1 = 1;
      u2 = 0;
      for( ; u1 < uint16.MAX + 1000; u1++, u2++ )
      {
        GLib.assert( !uint32_equal( u1, u2 ) );
      }
    }
    catch( Error e )
    {
      GLib.assert( false );
    }
  }

  /**
   * This test-case tests the int32_equal function.
   */
  public static void test_f_int32_equal( )
  {
    try
    {
      int32 u1 = 0;
      int32 u2 = 0;
      for( ; u1 < uint16.MAX + 1000; u1++, u2++ )
      {
        GLib.assert( int32_equal( u1, u2 ) );
      }

      u1 = 0;
      u2 = 1;
      for( ; u1 < uint16.MAX + 1000; u1++, u2++ )
      {
        GLib.assert( !int32_equal( u1, u2 ) );
      }

      u1 = 1;
      u2 = 0;
      for( ; u1 < uint16.MAX + 1000; u1++, u2++ )
      {
        GLib.assert( !int32_equal( u1, u2 ) );
      }
    }
    catch( Error e )
    {
      GLib.assert( false );
    }
  }

  /**
   * This test-case tests the unichar_equal function.
   */
  public static void test_f_unichar_equal( )
  {
    try
    {
      unichar u1 = 0;
      unichar u2 = 0;
      for( ; u1 < uint16.MAX + 1000; u1++, u2++ )
      {
        GLib.assert( unichar_equal( u1, u2 ) );
      }

      u1 = 0;
      u2 = 1;
      for( ; u1 < uint16.MAX + 1000; u1++, u2++ )
      {
        GLib.assert( !unichar_equal( u1, u2 ) );
      }

      u1 = 1;
      u2 = 0;
      for( ; u1 < uint16.MAX + 1000; u1++, u2++ )
      {
        GLib.assert( !unichar_equal( u1, u2 ) );
      }
    }
    catch( Error e )
    {
      GLib.assert( false );
    }
  }

  /**
   * This test-case tests the uint8_hash function.
   */
  public static void test_f_uint8_hash( )
  {
    try
    {
      uint8 u1 = 0;
      uint8 u2 = 0;
      for( ; u1 < uint8.MAX; u1++, u2++ )
      {
        GLib.assert( uint8_hash( u1 ) == uint8_hash( u2 ) );
      }

      u1 = 0;
      u2 = 1;
      for( ; u1 < uint8.MAX; u1++, u2++ )
      {
        GLib.assert( uint8_hash( u1 ) != uint8_hash( u2 ) );
      }
    }
    catch( Error e )
    {
      GLib.assert( false );
    }
  }

  /**
   * This test-case tests the uint16_hash function.
   */
  public static void test_f_uint16_hash( )
  {
    try
    {
      uint16 u1 = 0;
      uint16 u2 = 0;
      for( ; u1 < uint16.MAX; u1++, u2++ )
      {
        GLib.assert( uint16_hash( u1 ) == uint16_hash( u2 ) );
      }

      u1 = 0;
      u2 = 1;
      for( ; u1 < uint16.MAX; u1++, u2++ )
      {
        GLib.assert( uint16_hash( u1 ) != uint16_hash( u2 ) );
      }
    }
    catch( Error e )
    {
      GLib.assert( false );
    }
  }

  /**
   * This test-case tests the uint32_hash function.
   */
  public static void test_f_uint32_hash( )
  {
    try
    {
      uint32 u1 = 0;
      uint32 u2 = 0;
      for( ; u1 < uint16.MAX + 1000; u1++, u2++ )
      {
        GLib.assert( uint32_hash( u1 ) == uint32_hash( u2 ) );
      }

      u1 = 0;
      u2 = 1;
      for( ; u1 < uint16.MAX + 1000; u1++, u2++ )
      {
        GLib.assert( uint32_hash( u1 ) != uint32_hash( u2 ) );
      }
    }
    catch( Error e )
    {
      GLib.assert( false );
    }
  }

  /**
   * This test-case tests the int32_hash function.
   */
  public static void test_f_int32_hash( )
  {
    try
    {
      int32 u1 = 0;
      int32 u2 = 0;
      for( ; u1 < uint16.MAX + 1000; u1++, u2++ )
      {
        GLib.assert( int32_hash( u1 ) == int32_hash( u2 ) );
      }

      u1 = 0;
      u2 = 1;
      for( ; u1 < uint16.MAX + 1000; u1++, u2++ )
      {
        GLib.assert( int32_hash( u1 ) != int32_hash( u2 ) );
      }
    }
    catch( Error e )
    {
      GLib.assert( false );
    }
  }

  /**
   * This test-case tests the unichar_hash function.
   */
  public static void test_f_unichar_hash( )
  {
    try
    {
      unichar u1 = 0;
      unichar u2 = 0;
      for( ; u1 < uint16.MAX + 1000; u1++, u2++ )
      {
        GLib.assert( unichar_hash( u1 ) == unichar_hash( u2 ) );
      }

      u1 = 0;
      u2 = 1;
      for( ; u1 < uint16.MAX + 1000; u1++, u2++ )
      {
        GLib.assert( unichar_hash( u1 ) != unichar_hash( u2 ) );
      }
    }
    catch( Error e )
    {
      GLib.assert( false );
    }
  }

  /**
   * This test-case tests the get_trailing_utf8_byte_count function.
   */
  public static void test_f_get_trailing_utf8_byte_count( )
  {
    // 1 Byte Zeichen
    GLib.assert( get_trailing_utf8_byte_count( 'a' ) == 0 );

    // 2 Byte Zeichen
    string multi_byte = "ä";
    GLib.assert( get_trailing_utf8_byte_count( multi_byte.get( 0 ) ) == 1 );
    GLib.assert( get_trailing_utf8_byte_count( multi_byte.get( 1 ) ) == 0 );

    // 3 Byte Zeichen
    multi_byte = "”";
    GLib.assert( get_trailing_utf8_byte_count( multi_byte.get( 0 ) ) == 2 );
    GLib.assert( get_trailing_utf8_byte_count( multi_byte.get( 1 ) ) == 0 );
    GLib.assert( get_trailing_utf8_byte_count( multi_byte.get( 2 ) ) == 0 );

    // 4 Byte Zeichen
    StringBuilder sb = new StringBuilder( );
    sb.append_unichar( 0x1F680 );
    multi_byte = sb.str;
    GLib.assert( get_trailing_utf8_byte_count( multi_byte.get( 0 ) ) == 3 );
    GLib.assert( get_trailing_utf8_byte_count( multi_byte.get( 1 ) ) == 0 );
    GLib.assert( get_trailing_utf8_byte_count( multi_byte.get( 2 ) ) == 0 );
    GLib.assert( get_trailing_utf8_byte_count( multi_byte.get( 3 ) ) == 0 );
  }

  /**
   * A test stack-entry class.
   */
  public class TestStackEntry : OpenDMLib.StackEntry
  {
    public uint16 data;

    public TestStackEntry( uint16 data )
    {
      this.data = data;
    }
  }

  /**
   * This method tests the push method of the Stack class.
   */
  public static void test_stack_f_push( )
  {
    Stack<TestStackEntry> s = new Stack<TestStackEntry>( );
    assert( s != null );
    assert( s.tos == null );
    assert( s.size == 0 );

    s.push( new TestStackEntry( 1 ) );
    assert( s.tos != null );
    assert( ( (TestStackEntry)s.tos ).data == 1 );
    assert( s.size == 1 );

    s.push( new TestStackEntry( 2 ) );
    assert( ( (TestStackEntry)s.tos ).data == 2 );
    assert( s.size == 2 );

    s.push( new TestStackEntry( 3 ) );
    assert( ( (TestStackEntry)s.tos ).data == 3 );
    assert( s.size == 3 );
  }

  /**
   * This method tests the pop method of the Stack class.
   */
  public static void test_stack_f_pop( )
  {
    Stack<TestStackEntry> s = new Stack<TestStackEntry>( );
    assert( s != null );
    assert( s.tos == null );
    assert( s.size == 0 );

    s.push( new TestStackEntry( 1 ) );
    s.push( new TestStackEntry( 2 ) );
    s.push( new TestStackEntry( 3 ) );
    assert( s.tos != null );
    assert( ( (TestStackEntry)s.tos ).data == 3 );
    assert( s.size == 3 );

    TestStackEntry? tse = s.pop( );
    assert( tse != null );
    assert( tse.data == 3 );
    assert( s.tos != null );
    assert( ( (TestStackEntry)s.tos ).data == 2 );
    assert( s.size == 2 );

    tse = s.pop( );
    assert( tse != null );
    assert( tse.data == 2 );
    assert( s.tos != null );
    assert( ( (TestStackEntry)s.tos ).data == 1 );
    assert( s.size == 1 );

    tse = s.pop( );
    assert( tse != null );
    assert( tse.data == 1 );
    assert( s.tos == null );
    assert( s.size == 0 );

    tse = s.pop( );
    assert( tse == null );
    assert( s.tos == null );
    assert( s.size == 0 );
  }
}
