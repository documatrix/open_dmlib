using Posix;
using Windows;

namespace OpenDMLib
{
  /**
   * This errordomain contains the OpenDMLib errors.
   */
  public errordomain OpenDMLibError
  {
    PROCESS_SPAWN_ERROR,
    OTHER;
  }

  /**
   * This namespace contains some compare methods.
   */
  namespace Compare
  {
    /**
      * public static int std_cmp_int64 ( int64? item_1, int64? item_2 )
      *
      * Default compare Function for int64 values
      *
      * @param item_1 First value that is compared with the second value
      * @param item_2 Second value that is compared with the first value
      *
      * @return -1 if item_1 is lower than item_2, 0 if the items are equal, 1 if item_1 is greater than item_2
      */
    public static int std_cmp_int64( int64? item_1, int64? item_2 )
    {
      return (int) ( item_1 - item_2 );
    }

    /**
     * This method checks if two given int16 values are equal.
     * @param v1 A int16 value.
     * @param v2 A second int16 value.
     * @return true if v1 == v2.
     */
    public static bool int16_equal( int16? v1, int16? v2 )
    {
      return *( (int16*)v1 ) == *( (int16*)v2 );
    }

    /**
     * This method builds a hash value for a given int16 value.
     * @param v A int16 value to build a hash value for.
     * @return A hash value for the given int16 value.
     */
    public static uint int16_hash( int16? v )
    {
      return (uint)( *( (int16*)v ) );
    }
  }

  /**
   * This method can be used to print out a log message including
   * the ID of the current process and thread.
   * @param text The log message which should be printed out.
   */
  public void mklog( string text )
  {
    GLib.stdout.printf( "%d - %g:%s [%d]: %s\n", OpenDMLib.getpid( ), OpenDMLib.gettid( ), Log.FILE, Log.LINE, text );
  }

  /**
   * This method returns the ID of the current process.
   * @return The process ID.
   */
  public int getpid( )
  {
    return (int)Posix.getpid( );
  }

  /**
   * This method gets the return code of a Posix.system command
   * and returns it as normal exit status value.
   * @param status The return code of a Posix.system command.
   * @return The exit status.
   */
  public int32 get_exit_status( int status )
  {
    return ( ( status & 0xff00 ) >> 8 );
  }

  /**
   * This method tries to determine the current running operating system using some
   * environment variables.
   * @return linx, MSWin32 or unknown.
   */
  public string get_os_type( )
  {
    string v = Environment.get_variable( "OSTYPE" ) ?? "";
    if ( v != "" && /linux/i.match( v ) )
    {
      return "linux";
    }
    v = Environment.get_variable( "OS" ) ?? "";
    if ( v != "" && /windows/i.match( v ) )
    {
      return "MSWin32";
    }
    if ( Path.DIR_SEPARATOR == '\\' )
    {
      return "MSWin32";
    }
    if ( Path.DIR_SEPARATOR == '/' )
    {
      return "linux";
    }
    return "unknown";
  }

  /**
   * This method checks if the current operating system is windows.
   * @return true if the current operating system is windows, false else.
   */
  public bool windows( )
  {
    return /mswin/i.match( OpenDMLib.get_os_type( ) );
  }

  /**
   * This method checks if the current operating system is linux.
   * @return true if the current operating system is linux, false else.
   */
  public bool linux( )
  {
    return /linux/i.match( OpenDMLib.get_os_type( ) );
  }


  /**
   * This method appends "%" at the beginning and end of the string if OpenDMLib.windows( ) is true
   * or "$" at the beginning of the string if OpenDMLib.windows( ) is false. e.g.: ( %PATH% or $PATH )
   * @param text The text
   * @return "%" + text + "%" or "$" + text
   */
  public string add_environment_variable_prefix( string text )
  {
    if ( OpenDMLib.windows( ) )
    {
      return "%".concat( text, "%" );
    }
    return "$".concat( text );
  }

  /**
   * This method replaces environment variables ( ${...} or %...% ) in the given text.
   * @param text The environment variables in this string will be replaced.
   * @param replace_if_exists If true, only environment variables which are currently set, will be replaced.
   * @return The substituted text.
   */
  public string subst_vars( string text, bool replace_if_exists = false )
  {
    try
    {
      Regex _r1_substVars = /\$\{([^\}]+)\}/;
      Regex _r2_substVars = /%([^%]+)%/;

      string s_text = "";
      s_text = _r1_substVars.replace_eval( text, -1, 0, 0, ( match_info, result ) =>
      {
        subst_var( match_info, result, replace_if_exists );
        return false;
      } );

      s_text = _r2_substVars.replace_eval( s_text, -1, 0, 0, ( match_info, result ) =>
      {
        subst_var( match_info, result, replace_if_exists );
        return false;
      } );

      return s_text;
    }
    catch( RegexError re )
    {
      return text;
    }
  }

  /**
   * This method replaces the environment variable name specified in match_info by its content.
   * @param match_info The MatchInfo object containing the environment variable.
   * @param result The environment variable content will be appended to this StringBuilder.
   * @param replace_if_exists If true, only environment variables which are currently set, will be replaced.
   */
  private void subst_var( MatchInfo match_info, StringBuilder result, bool replace_if_exists )
  {
    string? var_name = match_info.fetch( 1 );
    if ( var_name != null )
    {
      unowned string? var_content = Environment.get_variable( (!)var_name );
      if ( var_content != null )
      {
        result.append( (!)var_content );
      }
      else if ( replace_if_exists )
      {
        result.append( match_info.fetch( 0 ) );
      }
    }
  }

  /**
   * This method determines the ID of the current running thread.
   * @return The thread id.
   */
  public uint64 gettid()
  {
    unowned Thread<void*> t = Thread.self<void*>();
    return (uint64)((void*)t);
  }

  /**
   * Compresses a given uint8 array using ZLib.
   * @param data A uint8 array containing data which should be compressed.
   * @param level The compression level which should be used to compress the given data (@see ZLib.Level).
   * @return The compressed data or null if an error occured.
   */
  public uint8[]? compress( uint8[] data, int level = ZLib.Level.DEFAULT_COMPRESSION )
  {
    ulong compr_length = (ulong)(data.length * 1.001) + 12;
    uint8[] compr = new uint8[ compr_length ];
    uint res = ZLib.Utility.compress( compr, ref compr_length, data, level );
    if ( res == ZLib.Status.OK )
    {
      return compr[ 0:compr_length ];
    }
    else
    {
      return null;
    }
  }

  /**
   * Uncompresses a given uint8 array using ZLib.
   * @param data A uint8 array containing data which should be uncompressed.
   * @param uncompressed_size The size of the uncompressed data.
   * @return The uncompressed data or null if an error occured.
   */
  public uint8[]? uncompress( uint8[] data, uint64 uncompressed_size )
  {
    uint8[] decompressed = new uint8[ uncompressed_size ];
    ulong real_size = (ulong)uncompressed_size;
    uint res = ZLib.Utility.uncompress( decompressed, ref real_size, data );
    if ( res == ZLib.Status.OK )
    {
      return decompressed[ 0:real_size ];
    }
    else
    {
      return null;
    }
  }

  /**
   * This method checks if two given uint16 values are equal.
   * @param v1 A uint16 value
   * @param v2 A second uint16 value
   * @return true if v1 == v2.
   */
  public static bool uint16_equal( uint16? v1, uint16? v2 )
  {
    return *( (uint16*)v1 ) == *( (uint16*)v2 );
  }

  /**
   * This method builds a hash value for a given uint16 value.
   * @param v A uint16 value to build a hash value for.
   * @return A hash value for the given uint16 value.
   */
  public static uint uint16_hash( uint16? v )
  {
    return (uint)( *( (uint16*)v ) );
  }

  /**
   * This method checks if two given uint8 values are equal.
   * @param v1 A uint8 value
   * @param v2 A second uint8 value
   * @return true if v1 == v2.
   */
  public static bool uint8_equal( uint8? v1, uint8? v2 )
  {
    return *( (uint8*)v1 ) == *( (uint8*)v2 );
  }

  /**
   * This method builds a hash value for a given uint8 value.
   * @param v A uint8 value to build a hash value for.
   * @return A hash value for the given uint8 value.
   */
  public static uint uint8_hash( uint8? v )
  {
    return (uint)( *( (uint8*)v ) );
  }

  /**
   * This method checks if two given uint32 values are equal.
   * @param v1 A uint32 value
   * @param v2 A second uint32 value
   * @return true if v1 == v2.
   */
  public static bool uint32_equal( uint32? v1, uint32? v2 )
  {
    return *( (uint32*)v1 ) == *( (uint32*)v2 );
  }

  /**
   * This method builds a hash value for a given uint32 value.
   * @param v A uint32 value to build a hash value for.
   * @return A hash value for the given uint32 value.
   */
  public static uint uint32_hash( uint32? v )
  {
    return (uint)( *( (uint32*)v ) % 65521 );
  }

  /**
   * This method checks if two given uint64 values are equal.
   * @param v1 A uint64 value
   * @param v2 A second uint64 value
   * @return true if v1 == v2.
   */
  public static bool uint64_equal( uint64? v1, uint64? v2 )
  {
    return *( (uint64*)v1 ) == *( (uint64*)v2 );
  }

  /**
   * This method builds a hash value for a given uint64 value.
   * @param v A uint64 value to build a hash value for.
   * @return A hash value for the given uint64 value.
   */
  public static uint uint64_hash( uint64? v )
  {
    return (uint)( *( (uint64*)v ) % 65521 );
  }

  /**
   * Checks if the two given int32-values are equal.
   * This method can be used to create a HashTable with int32-keys.
   * @param v1 The first value to check.
   * @param v2 The second value to check.
   * @return true if v1 == v2, otherwise false.
   */
  public static bool int32_equal( int32? v1, int32? v2 )
  {
    return *( (int32*)v1 ) == *( (int32*)v2 );
  }

  /**
   * This method creates a hash-key for a given int32 value.
   * This method can be used to create a HashTable with int32-keys.
   * @param v The int32 value for which a hash-key should be generated.
   * @return A hash-key for the given value.
   */
  public static uint int32_hash( int32? v )
  {
    return (uint)( *( (int32*)v ) % 65521 );
  }

  /**
   * This method creates a hash-key for a given unichar value.
   * This method can be used to create a HashTable with unichar-keys.
   * @param v The unichar value for which a hash-key should be generated.
   * @return A hash-key for the given value.
   */
  public uint unichar_hash( unichar? v )
  {
    return (uint)((uint64)(*((unichar*)v)) % 65521);
  }

  /**
   * This method checks if two given unichar values are equal.
   * @param v1 A unichar value
   * @param v2 A second unichar value
   * @return true if v1 == v2.
   */
  public bool unichar_equal( unichar? v1, unichar? v2 )
  {
    return *((unichar*)v1) == *((unichar*)v2);
  }

  /**
   * This method can be used to find a given executable.
   * It will return an executable filename (inclusive extension and path).
   * The method will try to find the given exe file in the path and the executable directory.
   * @param exe_file The executable to be searched.
   * @param prefer_exe_dir States if an executable in the executable directory should be prefered.
   * @return The executable filename (inclusive extension and path).
   */
  public string find_exe( string exe_file, bool prefer_exe_dir = false )
  {
    string? path_exe = Environment.find_program_in_path( exe_file );

    string final_exe = exe_file;
    #if OS_WINDOWS
      final_exe += ".exe";
    #endif

    string? exe_dir_exe = null;
    if ( OpenDMLib.IO.file_exists( OpenDMLib.get_dir( OpenDMLib.get_exe_dir( ) ) + final_exe ) )
    {
      exe_dir_exe = OpenDMLib.get_dir( OpenDMLib.get_exe_dir( ) ) + final_exe;
    }

    if ( exe_dir_exe != null && ( prefer_exe_dir || path_exe == null ) )
    {
      return exe_dir_exe;
    }
    if ( path_exe != null )
    {
      return path_exe;
    }

    return final_exe;
  }

  /**
   * This method will return the directory where the executable is running.
   * @return The path where the current running executable is located.
   * @throws OpenDMLibError.OTHER when an error occured while determining the executable dir.
   */
  public string get_exe_dir( ) throws OpenDMLibError.OTHER
  {
    string? exe_directory = null;
    BinReloc.InitError init_error = 0;
    if ( BinReloc.init( ref init_error ) != 1 )
    {
      throw new OpenDMLibError.OTHER( "Error initializing the BinReloc library!" );
    }
    else
    {
      exe_directory = BinReloc.find_exe_dir( null );
    }

    if ( exe_directory != null && !OpenDMLib.IO.is_directory( exe_directory ) )
    {
      /* I did not get the directory - I got the exe file itself... */
      exe_directory = Path.get_dirname( (!)exe_directory );
    }

    if ( exe_directory == null )
    {
      throw new OpenDMLibError.OTHER( "Could not get the executable directory!" );
    }

    return (!)exe_directory;
  }

  /**
   * Some useful io methods...
   */
  namespace IO
  {
    /**
     * The buffer size of some buffers...
     */
    public static size_t BUFFER_SIZE = 1024 * 4;

    /**
     * The different Posix.DirEnt.d_type types.
     */
    public enum DirType
    {
      DT_UNKNOWN = 0,
      DT_FIFO = 1,
      DT_CHR = 2,
      DT_DIR = 4,
      DT_BLK = 6,
      DT_REG = 8,
      DT_LNK = 10,
      DT_SOCK = 12,
      DT_WHT = 14;
    }

    /**
     * Some errors which may occur using methods of OpenDMLib.IO.
     */
    public errordomain OpenDMLibIOErrors {
      FILE_ERROR,
      NOT_EXISTS,
      END_OF_DATA
    }

    /**
     * This method builds the checksum of the given file.
     *
     * @param name Name of the file to build the chechsum for.
     * @param type Type of the checksum to build. Default MD5.
     *
     * @return Checksum of the given file.
     */
    public string? get_checksum_of_file( string name, GLib.ChecksumType type = GLib.ChecksumType.MD5 )
    {
      if ( !GLib.FileUtils.test( name, GLib.FileTest.IS_REGULAR ) )
      {
        return null;
      }

      GLib.Checksum checksum = new GLib.Checksum( type );
      DMFileStream stream = OpenDMLib.IO.open( name, "rb" );
      uint8 buffer[ 1024 ];
      size_t size;

      while ( ( size = stream.read( buffer ) ) > 0 )
      {
        checksum.update( buffer, size );
      }

      stream = null;

      return checksum.get_string( );
    }

    /**
     * Removes trailing path separators (/ or \) of a value.
     * @param val The value with optional path separator at the end.
     * @return Value without trailing path separators.
     */
    public string remove_trailing_path_sep( string val )
    {
      string ret = val;
      while ( ret.has_suffix( Path.DIR_SEPARATOR_S ) )
      {
        ret = ret[ 0:-1 ];
      }

      return ret;
    }

    /**
     * Deletes a directory recursively.
     * @param path The directory which should be removed (the directory will also be removed!)
     * @return 0 if the removal was successful any other value if an error occured.
     */
    public int rm_r( string path )
    {
      GLib.Dir d = GLib.Dir.open( path );
      string? entry;
      string _path = OpenDMLib.get_dir( path );
      while ( ( entry = d.read_name( ) ) != null )
      {
        if ( entry == "." || entry == ".." )
        {
          continue;
        }

        string _entry = _path + entry;
        int res = 0;
        if ( OpenDMLib.IO.is_directory( _entry ) )
        {
          res = OpenDMLib.IO.rm_r( _entry );
        }
        else
        {
          res = FileUtils.unlink( _entry );
        }
        if ( res != 0 )
        {
          return res;
        }
      }

      d = null;
      return DirUtils.remove( path );
    }

    /**
     * This method checks if the given path is a directory
     * @param path A path which should be checked if it is a directory.
     * @return true if the given path is a directory.
     */
    public bool is_directory( string path )
    {
      return FileUtils.test( path, FileTest.IS_DIR );
    }

    /**
     * This method determines the size of the given path.
     * @param path The path (directory or file) whichs size should be returned.
     * @return The size of the given path or -1 if an error occured.
     */
    public int64 get_size( string path )
    {
      File f = File.new_for_path( path );
      try
      {
        FileInfo info = f.query_info( "standard::size,time::modified", FileQueryInfoFlags.NONE, null );
        return info.get_size( );
      }
      catch ( Error e )
      {
        return -1;
      }
    }

    /**
     * This method checks if a given file or directory exists.
     * @param path The path of a directory or a file which should be checked if it exists.
     * @return true if the given path exists.
     */
    public bool file_exists( string path )
    {
      return FileUtils.test( path, FileTest.EXISTS );
    }

    /**
     * This method can be used to copy an existing file to a destination.
     * If the given destination file exists the copy method will overwrite it.
     * @param src The name of the file which should be copied.
     * @param dst The destination of the copy method.
     * @throws Error if an error occurs while copying.
     */
    public void copy( string src, string dst ) throws Error
    {
      File f_src = File.new_for_path( src );
      File f_dst = File.new_for_path( dst );
      f_src.copy( f_dst, FileCopyFlags.OVERWRITE );
    }

    /**
     * You can use this method to copy a folder from src to dst recursively.
     * If the given destination exists the copy_r method will overwrite it.
     * @param src The name of the file or folder which should be copied.
     * @param dst The destination of the copy_r method.
     * @param flags The @see GLib.FileCopyFlags which should be used for copying.
     * @throws Error if an error occurs while copying.
     */
    public void copy_r( string src, string dst, FileCopyFlags flags = GLib.FileCopyFlags.OVERWRITE ) throws Error
    {
      File f_src = File.new_for_path( src );
      File f_dst = File.new_for_path( dst );

      GLib.FileType src_type = f_src.query_file_type( GLib.FileQueryInfoFlags.NONE, null );
      if ( src_type == GLib.FileType.DIRECTORY )
      {
        f_dst.make_directory( null );
        f_src.copy_attributes( f_dst, flags, null );

        string src_path = f_src.get_path( );
        string dest_path = f_dst.get_path( );

        FileEnumerator enumerator = f_src.enumerate_children(
          GLib.FileAttribute.STANDARD_NAME,
          GLib.FileQueryInfoFlags.NONE,
          null
        );

        for ( FileInfo? info = enumerator.next_file( null ); info != null; info = enumerator.next_file( null ) )
        {
          OpenDMLib.IO.copy_r(
            Path.build_filename( src_path, info.get_name( ) ),
            Path.build_filename( dest_path, info.get_name( ) ),
            flags
          );
        }
      }
      else if ( src_type == GLib.FileType.REGULAR )
      {
        f_src.copy( f_dst, flags, null );
      }
    }

    /**
     * This method can be used to move an existing file to a destination.
     * If the given destination file exists the move method will overwrite it.
     * @param src The name of the file which should be moved.
     * @param dst The destination of the move method.
     * @throws Error if an error occurs while moving.
     */
    public void move( string src, string dst ) throws Error
    {
      File f_src = File.new_for_path( src );
      File f_dst = File.new_for_path( dst );
      f_src.move( f_dst, FileCopyFlags.OVERWRITE );
    }

    public string? get_mime_type( string filename ) throws Error
    {
      GLib.File f = GLib.File.new_for_path( filename );
      FileInfo fi = f.query_info( "standard::*", FileQueryInfoFlags.NONE );
      string content_type = fi.get_content_type( );
      return ContentType.get_mime_type( content_type );
    }

    public DMFileStream open( string filename, string mode ) throws OpenDMLibIOErrors
    {
      DMFileStream? f = DMFileStream.open( filename, mode );
      if ( f == null )
      {
        throw new OpenDMLibIOErrors.FILE_ERROR( "ERROR " + GLib.errno.to_string() + ": " + GLib.strerror( GLib.errno ) );
      }
      return f;
    }

    /**
     * This class can read a file with a buffer
     */
    public class BufferedFileReader : BufferedReader
    {
      /**
       * A owned DMFileStream if this class should open the File Stream.
       */
      private DMFileStream? owned_file;

      /**
       * A unowned DMFileStream if this class should not open the File Stream.
       */
      public unowned DMFileStream? file;

      /**
       * The path to the File which should be read.
       */
      string file_path;

      /**
       * Use this constructor to open a File.
       * @param file_path The path to the file.
       * @throws Error if the file could not be read.
       */
      public BufferedFileReader.with_filename( string file_path ) throws OpenDMLib.IO.OpenDMLibIOErrors
      {
        this.file_path = file_path;
        this.owned_file = OpenDMLib.IO.open( file_path, "rb" );
        this.file = this.owned_file;
        this.buffer = new uchar[ BUFFER_SIZE ];
      }

      /**
       * Use this constructor if you already have a DMFileStream opened.
       * @param file_path The path to the file.
       * @throws Error if the file could not be read.
       */
      public BufferedFileReader.with_filestream( DMFileStream file )
      {
        this.file = file;
        this.buffer = new uchar[ BUFFER_SIZE ];
      }

      /**
       * This method can be used to close the DMFileStream.
       */
      public void close( )
      {
        this.file = null;
        this.owned_file = null;
      }

      /**
       * @see BufferedReader.next_data
       */
      public override size_t next_data( uchar[] data ) throws Error
      {
        return this.file.read( data );
      }
    }

    /**
     * This class can read a file into the memory.
     */
    public class MemoryReader : BufferedReader
    {
      /**
       * Use this constructor to read a File into the memory.
       * @param file_name The path to the file.
       * @throws Error if the file could not be read.
       */
      public MemoryReader.from_file( string file_path ) throws Error
      {
        FileUtils.get_data( file_path, out this.buffer );
        this.buffer_bytes = this.buffer.length;
      }

      /**
       * Use this constructor to read from memory.
       * @param data The array which should be read.
       */
      public MemoryReader.from_data( uint8[] data )
      {
        this.buffer = data;
        this.buffer_bytes = this.buffer.length;
      }

      /**
       * The MemoryReader has already all data in the memory.
       * @see BufferedReader.next_data
       */
      public override size_t next_data( uchar[] data ) throws OpenDMLibIOErrors
      {
        throw new OpenDMLibIOErrors.END_OF_DATA( "Could not read data! End of Array" );
      }
    }

    public abstract class BufferedReader : GLib.Object
    {
      /**
       * The size which should be read in one go.
       */
      protected size_t buffer_size = BUFFER_SIZE;

      /**
       * The current buffer with the data.
       */
      protected uchar[] buffer;

      /**
       * The position in the current buffer.
       */
      protected size_t buffer_index = 0;

      /**
       * The number of bytes which were read into the current buffer.
       */
      public size_t buffer_bytes = 0;

      /**
       * This method can be used to copy data from the buffer
       * If there is not enough data in the buffer it request more data @see next_data
       * @param data The pointer to data which should be filled
       * @param size The size which is needed
       * @throws Error if an error occurs while requesting new data.
       */
      public void get_from_buffer( void* data, size_t size ) throws Error
      {
        if ( this.buffer_index + size > this.buffer_bytes )
        {
          int64 first_delta = this.buffer_bytes - this.buffer_index;

          if ( first_delta > 0 )
          {
            Memory.copy( data, &this.buffer[ this.buffer_index ], (size_t)first_delta );
          }
          else
          {
            first_delta = 0;
          }

          int64 second_delta = size - first_delta;
          if ( second_delta > this.buffer_size )
          {
            size_t read_data = this.next_data( ( (uchar[])data)[ first_delta : size ] );

            if ( read_data > second_delta )
            {
              throw new OpenDMLibIOErrors.END_OF_DATA( "Could not read data! End of Data over buffer size" );
            }
            this.buffer_bytes = 0;
            this.buffer_index = 0;
            return;
          }

          this.buffer_bytes = this.next_data( this.buffer );
          if ( second_delta <= this.buffer_bytes )
          {
            Memory.copy( &data[ first_delta ], this.buffer, (size_t)second_delta );
            this.buffer_index = (size_t)second_delta;
          }
          else
          {
            throw new OpenDMLibIOErrors.END_OF_DATA( "Could not read data! End of Data" );
          }
        }
        else
        {
          Memory.copy( data, &this.buffer[ this.buffer_index ], size );
          this.buffer_index += size;
        }
      }

      /**
       * This method can be used to read a string form the buffer.
       * @return A new string read from the buffer.
       * @throws Error if an error occurs while requesting new data. @see get_from_buffer
       */
      public string read_string( ) throws Error
      {
        uint32 length = this.read_uint32( );
        char[] tmp = new char[ length + 1 ];
        this.get_from_buffer( tmp, (size_t)length );
        tmp[ length ] = 0;
        return (string)tmp;
      }

      /**
       * This method can be used to read a uint8 form the buffer.
       * @return A new uint8 read from the buffer.
       * @throws Error if an error occurs while requesting new data. @see get_from_buffer
       */
      public uint8 read_uint8( ) throws Error
      {
        uint8 val = 0;
        this.get_from_buffer( &val, sizeof( uint8 ) );
        return val;
      }

      /**
       * This method can be used to read a uint32 form the buffer.
       * @return A new uint32 read from the buffer.
       * @throws Error if an error occurs while requesting new data. @see get_from_buffer
       */
      public uint32 read_uint32( ) throws Error
      {
        uint32 val = 0;
        this.get_from_buffer( &val, sizeof( uint32 ) );
        return val;
      }

      /**
       * This method can be used to read a int32 form the buffer.
       * @return A new int32 read from the buffer.
       * @throws Error if an error occurs while requesting new data. @see get_from_buffer
       */
      public int32 read_int32( ) throws Error
      {
        int32 val = 0;
        this.get_from_buffer( &val, sizeof( int32 ) );
        return val;
      }

      /**
       * This method can be used to read a uint64 form the buffer.
       * @return A new uint64 read from the buffer.
       * @throws Error if an error occurs while requesting new data. @see get_from_buffer
       */
      public uint64 read_uint64( ) throws Error
      {
        uint64 val = 0;
        this.get_from_buffer( &val, sizeof( uint64 ) );
        return val;
      }

      /**
       * This method can be used to read a int64 form the buffer.
       * @return A new int64 read from the buffer.
       * @throws Error if an error occurs while requesting new data. @see get_from_buffer
       */
      public int64 read_int64( ) throws Error
      {
        int64 val = 0;
        this.get_from_buffer( &val, sizeof( int64 ) );
        return val;
      }

      /**
       * This method can be used to read a double form the buffer.
       * @return A new double read from the buffer.
       * @throws Error if an error occurs while requesting new data. @see get_from_buffer
       */
      public double read_double( ) throws Error
      {
        double val = 0;
        this.get_from_buffer( &val, sizeof( double ) );
        return val;
      }

      /**
       * This method can be used to read a unichar form the buffer.
       * @return A new unichar read from the buffer.
       * @throws Error if an error occurs while requesting new data. @see get_from_buffer
       */
      public unichar read_unichar( ) throws Error
      {
        unichar val = 0;
        this.get_from_buffer( &val, sizeof( unichar ) );
        return val;
      }

      /**
       * This method may be called to get new data for the buffer.
       * @param data An array where the data should be inserted.
       * @return The number of bytes which could be read.
       * @throws Error No data could be read.
       */
      public abstract size_t next_data( uchar[] data ) throws Error;
    }

    public class BufferedFile : GLib.Object
    {
      private string? filename;
      private DMFileStream? owned_file;
      public unowned DMFileStream? file;
      private uchar[] buffer;
      private size_t buffer_index;

      /* Wenn im Buffer noch was steht, wird es hier raus geschrieben */
      public void write_out_buffer( )
      {
        if ( this.buffer_index > 0 )
        {
          this.file.write( this.buffer[ 0:this.buffer_index ] );
          this.buffer_index = 0;
        }
      }

      public void add_to_buffer(void * data, size_t size) throws Error
      {
        try
        {
          if ( this.buffer_index + size > BUFFER_SIZE )
          {
            /* Das geht sich nicht mehr aus! */
            this.file.write( this.buffer[ 0:this.buffer_index ] );
            this.buffer_index = 0;
          }
          if ( size > BUFFER_SIZE )
          {
            /* Data is bigger than one buffer -> write the whole data out... */
            uint8[] tmp_buf = new uint8[ size ];
            Memory.copy( &tmp_buf[ 0 ], data, size );
            this.file.write( tmp_buf );
          }
          else
          {
            Memory.copy( &this.buffer[ this.buffer_index ], data, size );
            this.buffer_index += size;
          }
        }
        catch (Error e)
        {
          GLib.stderr.printf( "Error writing to file: %s\n", e.message );
        }
      }

      public void write_string( string s ) throws Error
      {
        char[] tmp = s.to_utf8( );
        uint32 l = tmp.length;
        this.add_to_buffer( &l, sizeof(uint32) );
        this.add_to_buffer( tmp, (size_t)l );
      }

      public BufferedFile.with_filename( string filename ) throws OpenDMLib.IO.OpenDMLibIOErrors
      {
        this.filename = filename;
        this.owned_file = OpenDMLib.IO.open( filename, "wb" );
        this.file = this.owned_file;
        this.buffer = new uchar[BUFFER_SIZE];
        this.buffer_index = 0;
      }

      public BufferedFile.with_filestream( DMFileStream file )
      {
        this.file = file;
        this.buffer = new uchar[BUFFER_SIZE];
        this.buffer_index = 0;
      }

      public void close( )
      {
        this.write_out_buffer( );
        this.file = null;
        this.owned_file = null;
      }
    }

    /**
     * This class represents an object in the filesystem (can be a directory or file)
     */
    public class FileSystemObject : GLib.Object
    {
      /* Gibt an ob das Objekt ein Verzeichnis ist oder nicht. */
      public bool directory = false;

      /* Wenn das Objekt ein Verzeichnis ist, dann werden in diesem Array die Unter-Objekte gespeichert */
      public FileSystemObject[]? children = null;

      /* Der Name des Objekts (ohne Pfad) */
      public string name;

      /* Der Name des OBjekts + Pfad */
      public string path;

      /**
       * Use this constructor to create a FileSystemObject and load its structure.
       * The constructor will recursively walk down the directory structure and create the needed FileSystemObject's.
       * @param path The path for the FileSystemObject
       * @param is_dir States if the given path is a directory, a file or unknown.
       */
      public FileSystemObject( string path, bool? is_dir = null ) throws OpenDMLibIOErrors
      {
        this.path = path;
        this.name = Path.get_basename( path );

        if ( ( is_dir == null && OpenDMLib.IO.is_directory( path ) ) || is_dir == true )
        {
          this.directory = true;
#if OS_WINDOWS
          string real_dir = OpenDMLib.get_dir( path );
          string find_dir = real_dir + "*.*";

          Windows.FileApi.FindData data = Windows.FileApi.FindData( );
          void* handle = Windows.FileApi.FindFirstFileEx( Win32.locale_filename_from_utf8( find_dir ), Windows.FileApi.FIndex_Info_Levels.Standard, &data, Windows.FileApi.FIndex_Search_Ops.NameMatch, null, 0 );
          if ( handle == Windows.INVALID_HANDLE_VALUE )
          {
            throw new OpenDMLibIOErrors.NOT_EXISTS( "Could not create FileSystemObject for path %s! The path does not exist!", path );
          }

          try
          {
            FileSystemObject[] children = { };
            do
            {
              string name = (string)data.cFileName;
              if ( name == "." || name == ".." )
              {
                continue;
              }
              name = name.locale_to_utf8( -1, null, null, null );
              children += new FileSystemObject( real_dir + name, ( data.dwFileAttributes & Windows.FileApi.FileAttribute.DIRECTORY ) != 0 ? true : false );
            }
            while ( Windows.FileApi.FindNextFile( handle, &data ) );
            this.children = children;
          }
          catch ( OpenDMLibIOErrors e )
          {
            GLib.stderr.printf( "Error while opening directory %s! %s", path, e.message );
          }

          Windows.FileApi.FindClose( handle );
#else
          Posix.Dir? dir = Posix.opendir( path );
          if ( dir == null )
          {
            throw new OpenDMLibIOErrors.NOT_EXISTS( "Could not create FileSystemObject for path %s! %s", path, Posix.strerror( Posix.errno ) );
          }
          unowned Posix.DirEnt? entry = null;
          FileSystemObject[] children = { };

          try
          {
            while ( ( entry = Posix.readdir( (!)dir ) ) != null )
            {
              string name = (string)entry.d_name;

              if ( name == "." || name == ".." )
              {
                continue;
              }
              if ( entry.d_type != DirType.DT_UNKNOWN )
              {
                children += new FileSystemObject( OpenDMLib.get_dir( this.path ) + name, entry.d_type == DirType.DT_DIR ? true : false );
              }
              else
              {
                children += new FileSystemObject( OpenDMLib.get_dir( this.path ) + name );
              }
            }
            this.children = children;
          }
          catch ( OpenDMLibIOErrors e )
          {
            GLib.stderr.printf( "Error while opening directory %s! %s", path, e.message );
          }
#endif
        }
      }
    }
  }

  /**
   * This method ensures, that the path separators of a given path are correct for the current running
   * operating system.
   * @param val A string containing a path.
   * @return The given path with correct path separators of the current running operating system.
   */
  public string ensure_ps( string val )
  {
    string _val = val;
    if ( OpenDMLib.windows( ) )
    {
      if ( _val.has_prefix( "\\\\" ) )
      {
        int i = 2;
        for ( ; i < _val.length; i ++ )
        {
          if ( _val[ i ] != '\\' )
          {
            break;
          }
        }
        _val = _val.replace( "/", "\\" );
        _val = "\\\\" + _val[ i : _val.length ].replace( "\\\\", "\\" );
      }
      else
      {
        _val = _val.replace( "/", "\\" );
        _val = _val.replace( "\\\\", "\\" );
      }
    }
    else
    {
      /* TODO A directory with a backslash in its name will not be handled correct */
      _val = _val.replace( "\\", "/" );
      _val = _val.replace( "//", "/" );
    }
    return _val;
  }

  /**
   * This method will check if the given directory name ends with a dir separator and will add one if necassery.
   * It will also ensure, that the path separators are correct for the current running operating system.
   * @param dirname A string containing a directory name.
   * @return The given dirname with correct path separators and a path separator at the end.
   */
  public string get_dir( string dirname )
  {
    if ( dirname[ dirname.length - 1 ] == Path.DIR_SEPARATOR )
    {
      return OpenDMLib.ensure_ps( dirname );
    }
    else
    {
      return OpenDMLib.ensure_ps( dirname + Path.DIR_SEPARATOR_S );
    }
  }

  /* Einige Funktionen zum Ascii85 codieren */
  public class Ascii85 : GLib.Object
  {
    private ulong width;
    private uint32 pos;
    private uint32 tuple;
    private uint32 count;
    private unowned DMFileStream os;
    uint8[] buffer;
    uint32 buffer_index;
    uint16 buffer_size;

    public void encode_data(uint8[] data) throws Error
    {
      uint32 i;
      this.tuple = 0;
      this.width = 72;
      this.pos = 0;
      this.count = 0;
      this.buffer_size = 4096;
      this.buffer = new uint8[this.buffer_size];
      this.buffer_index = 0;
      for (i = 0; i < data.length; i++)
      {
        this.put85(data[i]);
      }
      finish();
      //return this.encoded;
    }

    /* Wenn im Buffer noch was steht, wird es hier raus geschrieben */
    public void write_out_buffer() throws Error
    {
      if (this.buffer_index > 0)
      {
        //debug("writing image buffer from %lu to %lu (buffer-length: %lu)", 0, buffer_index + 1, buffer.length);
        this.os.write(buffer[0:buffer_index] );
        this.buffer_index = 0;
      }
    }

    public void add_to_buffer(uint8 data) throws Error
    {
      if (this.buffer_index + 1 > this.buffer_size)
      {
        /* Das geht sich nicht mehr aus! */
        this.os.write(buffer[0:buffer_index] );
        this.buffer_index = 0;
      }
      buffer[this.buffer_index] = data;
      this.buffer_index ++;
    }

    private void encode() throws Error
    {
      uint32 i;
      char buf[5];
      char* s = buf;
      i = 5;
      do
      {
        *s++ = tuple % 85;
        tuple /= 85;
      } while (--i > 0);
      i = count;
      do
      {
        s = s -1;
        //this.encoded += (*s + '!').to_string();
        //this.os.put_byte(*s + '!');
        this.add_to_buffer(*s + '!');
        if (pos++ >= width)
        {
          pos = 0;
          //this.encoded += "\n";
          //this.os.put_byte('\n');
          this.add_to_buffer('\n');
        }
      } while (i-- > 0);
    }

    private void put85(uint8 c) throws Error
    {
      switch (count++)
      {
        case 0:  tuple |= (c << 24); break;
        case 1: tuple |= (c << 16); break;
        case 2:  tuple |= (c <<  8); break;
        case 3:
          tuple |= c;
          if (tuple == 0)
          {
            //encoded += "z";
            //this.os.put_byte('z');
            this.add_to_buffer('z');
            if (pos++ >= width)
            {
              pos = 0;
              //encoded += "\n";
              //this.os.put_byte('\n');
              this.add_to_buffer('\n');
            }
          }
          else
          {
            encode();
          }
          tuple = 0;
          count = 0;
          break;
      }
    }

    private void finish() throws Error
    {
      if (count > 0)
      {
        encode();
      }
      if (pos + 2 > width)
      {
        //encoded += "\n";
        //this.os.put_byte('\n');
        this.add_to_buffer('\n');
      }
      //os.put_string("~>\n");
      this.add_to_buffer('~');
      this.add_to_buffer('>');
      this.add_to_buffer('\n');
      this.buffer_index--;
      //encoded += "~>\n";
      this.write_out_buffer();
    }

    public Ascii85(DMFileStream os)
    {
      this.os = os;
    }
  }

  /**
   * This class can be used to store an array of values to a collection
   */
  public class DMArray<G> : GLib.Object
  {
    private G[] data;

    /**
     * The element-count of this array.
     * size is a synonym for length and exists to support the foreach-syntax for DMArrays
     */
    public int size {
      get
      {
        return this.length;
      }
    }

    public int length;

    public DMArray( )
    {
      this.data = { };
      this.length = 0;
    }

    public DMArray.sized( int size )
    {
      this.data = new G[ size ];
      this.length = size;
    }

    public DMArray.with_data( G[] data )
    {
      this.data = new G[ data.length ];
      this.length = data.length;
      for ( int i = 0; i < this.length; i ++ )
      {
        this.data[ i ] = data[ i ];
      }
    }

    public void add( G element )
    {
      this.push( element );
    }

    public void push( G element )
    {
      this.data += element;
      this.length ++;
    }

    public void push_array( DMArray<G> elements )
    {
      for ( int i = 0; i < elements.length; i ++ )
      {
        this.push( elements[ i ] );
      }
    }

    public G pop( )
    {
      if ( this.length == 0 )
      {
        return null;
      }

      G last = this.data[ this.length - 1 ];
      this.data = this.data[ 0 : this.length - 1 ];
      this.length --;

      return last;
    }

    public new void set( int index, owned G val )
    {
      this.data[ index ] = val;
    }

    public new unowned G get( int index )
    {
      return this.data[ index ];
    }

    public G[] get_data( )
    {
      return this.data;
    }

    /**
     * Clears the DMArray and removes every element in the array.
     * The length of the DMArray will be zero after clear.
     */
    public void clear( )
    {
      this.data = { };
      this.length = 0;
    }

    public void sort( CompareDataFunc<G> compare_func )
    {
      GLib.qsort_with_data<G>( this.data, sizeof( G ), compare_func );
    }
  }

  /**
   * This method returns a name for a temporary file.
   * The returned filename should be unique.
   * @param include_tmp_dir This flag specifies if the method should just
   *        return the filename (false) or also the tmp directory (true).
   * @return A temporary filename.
   */
  public string get_temp_file( bool include_tmp_dir = true )
  {
    if ( include_tmp_dir )
    {
      return OpenDMLib.get_dir( Environment.get_tmp_dir( ) ) + OpenDMLib.getpid( ).to_string( ) + "_" + Random.next_int( ).to_string( ) + ".tmp";
    }
    else
    {
      return OpenDMLib.getpid( ).to_string( ) + "_" + Random.next_int( ).to_string( ) + ".tmp";
    }
  }

  /*
   * Eine Art HashSet mit string als Key-Typ.
   * Im Hintergrund verwendet diese Implementierung die HashTable und sollte daher schneller als die Gee-Implementierung sein.
   */
  public class HashSet : GLib.Object
  {
    private HashTable<string?,bool?> data;

    public HashSet( )
    {
      this.data = new HashTable<string?,bool?>( str_hash, str_equal );
    }

    public void set( string key )
    {
      this.data.insert( key, true );
    }

    public bool get( string key )
    {
      return this.data.lookup( key ) != null;
    }

    public string[] get_keys( )
    {
      string[] keys = { };

      foreach ( string key in this.data.get_keys( ) )
      {
        keys += key;
      }

      return keys;
    }

    public void clear( )
    {
      this.data.remove_all( );
    }
  }

#if GLIB_2_32
  [CCode (type_id="G_TYPE_DATE_TIME")]
  public class DMDateTime : DateTime
  {
    public DMDateTime.now( TimeZone tz )
    {
      base.now( tz );
    }

    public DMDateTime.now_local( )
    {
      base.now_local( );
    }

    public DMDateTime.now_utc( )
    {
      base.now_utc( );
    }

    public DMDateTime.from_unix_local( int64 t )
    {
      base.from_unix_local( t );
    }

    public DMDateTime.from_unix_utc( int64 t )
    {
      base.from_unix_utc( t );
    }

    public DMDateTime.from_timeval_local( TimeVal tv )
    {
      base.from_timeval_local( tv );
    }

    public DMDateTime.from_timeval_utc( TimeVal tv )
    {
      base.from_timeval_utc( tv );
    }

    public DMDateTime( TimeZone tz, int year, int month, int day, int hour, int minute, double seconds )
    {
      base( tz, year, month, day, hour, minute, seconds );
    }

    public DMDateTime.local( int year, int month, int day, int hour, int minute, double seconds )
    {
      base.local( year, month, day, hour, minute, seconds );
    }

    public DMDateTime.utc( int year, int month, int day, int hour, int minute, double seconds )
    {
      base.utc( year, month, day, hour, minute, seconds );
    }
  }
#else
  public class DMDateTime : GLib.Object
  {
    private Time time;

    public DMDateTime.local( int year, int month, int day, int hour, int minute, double seconds )
    {
      this.time = Time.local( time_t( ) );
      this.time.year = year - 1900;
      this.time.month = month - 1;
      this.time.day = day;
      this.time.hour = hour;
      this.time.minute = minute;
      this.time.second = (int)seconds;
      this.time = Time.local( this.time.mktime( ) );
    }

    public DMDateTime.now_local( )
    {
      this.time = Time.local( time_t( ) );
    }

    public DMDateTime.from_unix_local( int64 time )
    {
      this.time = Time.local( (time_t)time );
    }

    /**
     * @see DateTime.format
     */
    public string format( string format )
    {
      return this.time.format( format );
    }

    public int get_hour( )
    {
      return this.time.hour;
    }

    public int get_minute( )
    {
      return this.time.minute;
    }

    public int get_second( )
    {
      return this.time.second;
    }

    public int get_year( )
    {
      return this.time.year + 1900;
    }

    public int get_month( )
    {
      return this.time.month + 1;
    }

    public int get_day_of_month( )
    {
      return this.time.day;
    }

    /**
     * @see DateTime.get_day_of_week
     */
    public int get_day_of_week( )
    {
      return this.time.weekday;
    }

    public int64 to_unix( )
    {
      return (int64)this.time.mktime( );
    }

    /**
     * @see DateTime.to_string
     */
    public string to_string( )
    {
      return this.time.format( "%FT%H:%M:%S%z" );
    }
  }
#endif


  /**
   * This enum defines the possible color types for Color-objects.
   */
  public enum ColorType
  {
    BLACK,
    RGB,
    CMYK,
    HIGH,
    INK,
    GRAY;

    /**
     * This method will convert a ColorType to an uint8 value.
     * @return The type represented by an uint8 value.
     */
    public uint8 to_uint8( )
    {
      switch( this )
      {
        case ColorType.BLACK:
          return 0;
        case ColorType.RGB:
          return 3;
        case ColorType.CMYK:
          return 4;
        case ColorType.HIGH:
          return 1;
        case ColorType.INK:
          return 2;
        case ColorType.GRAY:
          return 5;
        default:
          return 0;
      }
    }

    /**
     * This method will convert an uint8 value into a ColorType.
     * @param type A uint8 value (which should contain a value generated by the ColorType.to_uint8-method).
     * @return The given uint8 value represented by a ColorType.
     */
    public static ColorType from_uint8( uint8 type )
    {
      switch ( type )
      {
        case 1:
          return ColorType.HIGH;
        case 2:
          return ColorType.INK;
        case 3:
          return ColorType.RGB;
        case 4:
          return ColorType.CMYK;
        case 5:
          return ColorType.GRAY;
        default:
          return ColorType.BLACK;
      }
    }
  }

  /**
   * Objects of this class represent a color.
   * The color can be one of the types defined in the ColorType enum.
   */
  public class Color : GLib.Object
  {
    /* Der Farbtyp dieses Objekts */
    public ColorType type;

    /* RGB */
    /* Rot-Anteil */
    public uint8 r;

    /* Blau-Anteil */
    public uint8 g;

    /* Grün-Anteil */
    public uint8 b;

    /* CMYK */
    /* Cyan Anteil */
    public uint8 c;

    /* Magenta Anteil */
    public uint8 m;

    /* Yellow Anteil */
    public uint8 y;

    /* K (Black) Anteil */
    public uint8 k;

    /* Numbered Ink */
    /* Nummer der Farbe */
    public uint16 ink_color_nr;

    /* Grayscale */
    /* Grauanteil */
    public uint8 gray;

    /**
     * Creates a Color object with RGB-Values.
     * @param r The red value
     * @param g The green value
     * @param b The blue value
     */
    public Color.rgb( uint8 r, uint8 g, uint8 b )
    {
      this.r = r;
      this.g = g;
      this.b = b;
      this.type = ColorType.RGB;
    }

    /**
     * Creates a black Color object.
     */
    public Color.black( )
    {
      this.type = ColorType.BLACK;
    }

    /**
     * Creates a Color object with CMYK-Values.
     * @param c The cyan value
     * @param m The magenta value
     * @param y The yellow value
     * @param k The black value
     */
    public Color.cmyk( uint8 c, uint8 m, uint8 y, uint8 k )
    {
      this.c = c;
      this.m = m;
      this.y = y;
      this.k = k;
      this.type = ColorType.CMYK;
    }

    /**
     * Creates a highlight Color object.
     */
    public Color.high( )
    {
      this.type = ColorType.HIGH;
    }

    /**
     * Creates a Color object with a gray scale value.
     * @param gray The gray scale value
     */
    public Color.grayscale( uint8 gray )
    {
      this.gray = gray;
      this.type = ColorType.GRAY;
    }

    /**
     * Creates a Color object with a numbered ink.
     * @param ink_color_nr The ink number
     */
    public Color.ink( uint16 ink_color_nr )
    {
      this.ink_color_nr = ink_color_nr;
      this.type = ColorType.INK;
    }

    /**
     * Compares this Color object with the given Color object c.
     * @param c The Color object to be compared with this Color object.
     * @return True if the two Color objects are equal.
     */
    public bool equal( Color? c )
    {
      if ( c == null || c.type != this.type )
      {
        return false;
      }
      if (
           this.type == ColorType.RGB &&
           (
             this.r != c.r || this.g != c.g || this.b != c.b
           )
         )
      {
        return false;
      }
      if (
           this.type == ColorType.CMYK &&
           (
             this.c != c.c || this.m != c.m || this.y != c.y || this.k != c.k
           )
         )
      {
        return false;
      }
      if (
           this.type == ColorType.GRAY &&
           (
             this.gray != c.gray
           )
         )
      {
        return false;
      }
      if (
           this.type == ColorType.INK &&
           (
             this.ink_color_nr != c.ink_color_nr
           )
         )
      {
        return false;
      }
      return true;
    }

    /**
     * Copies this Color object.
     * @return A copy of this Color object with the same values.
     */
    public Color copy( )
    {
      Color c;
      switch ( this.type )
      {
        case ColorType.CMYK:
          c = new Color.cmyk( this.c, this.m, this.y, this.k );
          break;
        case ColorType.HIGH:
          c = new Color.high( );
          break;
        case ColorType.BLACK:
          c = new Color.black( );
          break;
        case ColorType.INK:
          c = new Color.ink( this.ink_color_nr );
          break;
        case ColorType.GRAY:
          c = new Color.grayscale( this.gray );
          break;
        case ColorType.RGB:
        default:
          c = new Color.rgb( this.r, this.g, this.b );
          break;
      }
      return c;
    }

    /**
     * This method will return CSS code for use in HTML files which represents the Color.
     * @return The CSS code which represents the color.
     */
    public string get_html_color( )
    {
      if ( this.type == ColorType.RGB )
      {
        return "rgb(%s,%s,%s)".printf( ( (float)this.r ).to_string( ), ( (float)this.g ).to_string( ), ( (float)this.b ).to_string( ) );
      }
      if ( this.type == ColorType.CMYK )
      {
        return "cmyk(%s,%s,%s,%s)".printf( ( (float)this.c ).to_string( ), ( (float)this.m ).to_string( ), ( (float)this.y ).to_string( ), ( (float)this.k ).to_string( ) );
      }
      return "black";
    }
  }

  /**
   * Checks if the given byte is the first byte of a UTF-8 multi byte character
   * and returns the count of trailing bytes.
   * @param byte The first byte of a UTF-8 character.
   * @return The count of trailing bytes for this UTF-8 character.
   */
  public uint8 get_trailing_utf8_byte_count( uint8 byte )
  {
    /* Überprüfen ob das Byte mit 11** **** beginnt */
    if ( ( byte & 192 ) == 192 )
    {
      /* Überprüfen ob das Byte mit 111* **** beginnt */
      if ( ( byte & 224 ) == 224 )
      {
        /* Überprüfen ob das Byte mit 1111 **** beginnt */
        if ( ( byte & 240 ) == 240 )
        {
          return 3;
        }
        else
        {
          return 2;
        }
      }
      else
      {
        return 1;
      }
    }
    /* Byte ist nicht das 1. Byte eines UTF-8 multi Byte Characters */
    return 0;
  }

  public abstract class StackEntry : GLib.Object
  {
    public StackEntry? next_entry = null;
  }

  public class Stack<G> : GLib.Object
  {
    public StackEntry? tos = null;
    public uint16 size = 0;

    public void push( StackEntry se )
    {
      se.next_entry = this.tos;
      this.tos = se;
      this.size ++;
    }

    public G? pop( )
    {
      StackEntry? se = this.tos;
      if ( se != null )
      {
        this.tos = se.next_entry;
        se.next_entry = null;
        this.size --;
      }
      return (G)se;
    }

    public StackIterator<G> iterator( )
    {
      return new StackIterator<G>( this );
    }
  }

  public class StackIterator<G> : GLib.Object
  {
    public StackEntry? next_entry;

    public StackIterator( Stack s )
    {
      this.next_entry = s.tos;
    }

    public bool next( )
    {
      return this.next_entry != null;
    }

    public G get( )
    {
      StackEntry? e = this.next_entry;
      if ( e != null )
      {
        this.next_entry = e.next_entry;
        return (G)(!)e;
      }
      else
      {
        return null;
      }
    }
  }

#if OS_WINDOWS
  /**
   * This class can spawn and wait for a new process.
   */
  public class ProcessSpawner
  {
    /**
     * The Windows.ThreadsAPI.ProcessInformation that contains the information about the newly created process and its primary thread.
     */
    private Windows.ThreadsAPI.ProcessInformation pi = Windows.ThreadsAPI.ProcessInformation( );

    /**
     * The Windows.ThreadsAPI.StartupInfo that specifies standard handles and appearance of the main window for the process at creation time.
     */
    private Windows.ThreadsAPI.StartupInfo si = Windows.ThreadsAPI.StartupInfo( );

    /**
     * The file (stdout & stderr) handle that is used in the Windows.ThreadsAPI.StartupInfo if an log file is specified.
     */
    private void* file_handle;

    /**
     * This method spawns a process with the given parameters. Call either wait_for_process( ) to wait for the spawned process or close_process_handles( ) to do the cleanup.
     * See https://msdn.microsoft.com/en-us/library/windows/desktop/ms682425(v=vs.85).aspx for more informations about the CreateProcess method.
     * See https://msdn.microsoft.com/en-us/library/windows/desktop/aa363858(v=vs.85).aspx for more informations about the CreateFile method.
     * @param commandline The command to execute. Win32.locale_filename_from_utf8( ) will be called for you in this method.
     * @param hide_window Specifies if the method should hide the command prompt.
     * @param logfile The full path of the logfile you want to use. Use the wait_for_process( ) Method to wait for the process (and the I/O Operations) to finish.
     *        Win32.locale_filename_from_utf8( ) will be called for you in this method.
     * @param current_directory The directory where the command should be executed.
     * @throws An OpenDMLibError.PROCESS_SPAWN_ERROR error with an error message in it.
     */
    public void spawn_process( string commandline, bool hide_window = false, string? logfile = null, string? current_directory = null ) throws OpenDMLibError.PROCESS_SPAWN_ERROR
    {
      bool executed = false;
      uint32 create_no_window = 0;

      if ( logfile != null && logfile != "" )
      {
        Windows.SecurityAttributes sa = Windows.SecurityAttributes( );
        sa.lpSecurityDescriptor = null;
        sa.bInheritHandle = true;

        this.file_handle = FileApi.CreateFile(
          Win32.locale_filename_from_utf8( logfile ),
          FileApi.FILE_WRITE_DATA,
          FileApi.FILE_SHARE_WRITE | FileApi.FILE_SHARE_READ,
          &sa,
          FileApi.CREATE_ALWAYS,
          FileApi.FILE_ATTRIBUTE_NORMAL,
          null
        );

        if ( this.file_handle == Windows.INVALID_HANDLE_VALUE )
        {
          throw new OpenDMLibError.PROCESS_SPAWN_ERROR( "An error occured while generating the log file %s! %s!", logfile, OpenDMLib.get_error_message( GetLastError( ) ) );
        }

        si.dwFlags = Windows.ThreadsAPI.STARTF_USESTDHANDLES;
        si.hStdError = this.file_handle;
        si.hStdOutput = this.file_handle;
      }
      else
      {
        file_handle = Windows.INVALID_HANDLE_VALUE;
      }

      if ( hide_window )
      {
        si.wShowWindow = Windows.ThreadsAPI.SW_HIDE;
        create_no_window = Windows.ThreadsAPI.CREATE_NO_WINDOW;
      }
      string? current_win_directory = null;
      if ( current_directory != null )
      {
        current_win_directory = Win32.locale_filename_from_utf8( current_directory );
      }

      executed = Windows.ThreadsAPI.CreateProcess( null, Win32.locale_filename_from_utf8( commandline ), null, null, true, create_no_window, null, current_win_directory, &si, &pi );

      if ( !executed )
      {
        throw new OpenDMLibError.PROCESS_SPAWN_ERROR( "An error occured while spawning a new process with the command %s! %s!", commandline, OpenDMLib.get_error_message( GetLastError( ) ) );
      }
    }

    /**
     * This method waits for the spawned process.
     * See https://msdn.microsoft.com/en-us/library/windows/desktop/ms687032(v=vs.85).aspx for more informations about the WaitForSingleObject method.
     * @param The time-out interval, in milliseconds. If you use Windows.ThreadsAPI.INFINITE the function will return only when the process has finished.
     * @throws An OpenDMLibError.PROCESS_SPAWN_ERROR error with an error message and the return status.
     */
    public uint32 wait_for_process( uint32 time_to_wait ) throws OpenDMLibError.PROCESS_SPAWN_ERROR
    {
      uint32 wait_rc = Windows.ThreadsAPI.WaitForSingleObject( pi.hProcess, time_to_wait );

      if ( this.file_handle != Windows.INVALID_HANDLE_VALUE && Windows.ThreadsAPI.CloseHandle( this.file_handle ) == false )
      {
        throw new OpenDMLibError.PROCESS_SPAWN_ERROR( "An error occured while closing the file handle! %s!".printf( OpenDMLib.get_error_message( GetLastError( ) ) ) );
      }

      DWORD* process_rc = null;
      if ( wait_rc == Windows.ThreadsAPI.WAIT_OBJECT_0 ) // SUCCESS
      {
        if ( Windows.ThreadsAPI.GetExitCodeProcess( pi.hProcess, &process_rc ) == false )
        {
          throw new OpenDMLibError.PROCESS_SPAWN_ERROR( "An error occured while getting the RC of the process! %s", OpenDMLib.get_error_message( GetLastError( ) ) );
        }
      }

      try
      {
        this.close_process_handles( );
      }
      catch( OpenDMLibError.PROCESS_SPAWN_ERROR e )
      {
        throw e;
      }

      switch ( wait_rc )
      {
        case Windows.ThreadsAPI.WAIT_OBJECT_0:
          return (uint32)process_rc;

        case Windows.ThreadsAPI.WAIT_ABANDONED:
          throw new OpenDMLibError.PROCESS_SPAWN_ERROR( "An error occured while waiting for the process to finish! WAIT_ABANDONED!" );

        case Windows.ThreadsAPI.WAIT_TIMEOUT:
          throw new OpenDMLibError.PROCESS_SPAWN_ERROR( "An error occured while waiting for the process to finish! WAIT_TIMEOUT!" );

        case Windows.ThreadsAPI.WAIT_FAILED:
          throw new OpenDMLibError.PROCESS_SPAWN_ERROR( "An error occured while waiting for the process to finish! WAIT_FAILED! %s", OpenDMLib.get_error_message( GetLastError( ) ) );

        default:
          throw new OpenDMLibError.PROCESS_SPAWN_ERROR( "An error occured while waiting for the process to finish! Unknown Error!" );
      }
    }

    /**
     * This methods closes the process handles.
     * See https://msdn.microsoft.com/en-us/library/windows/desktop/ms724211(v=vs.85).aspx for more informations about the CloseHandle method.
     * @throws An OpenDMLibError.PROCESS_SPAWN_ERROR error with an error message and the return status.
     */
    public void close_process_handles( ) throws OpenDMLibError.PROCESS_SPAWN_ERROR
    {
      if ( pi.hProcess != Windows.INVALID_HANDLE_VALUE && Windows.ThreadsAPI.CloseHandle( pi.hProcess ) == false )
      {
        throw new OpenDMLibError.PROCESS_SPAWN_ERROR( "An error occured while closing the process handle! %s!".printf( OpenDMLib.get_error_message( GetLastError( ) ) ) );
      }
      if ( pi.hThread != Windows.INVALID_HANDLE_VALUE && Windows.ThreadsAPI.CloseHandle( pi.hThread ) == false )
      {
        throw new OpenDMLibError.PROCESS_SPAWN_ERROR( "An error occured while closing the process' thread handle! %s!".printf( OpenDMLib.get_error_message( GetLastError( ) ) ) );
      }
    }
  }

  /**
   * With this method you can obtain an error string for system error codes ( form GetLastError( ) ).
   * See https://msdn.microsoft.com/en-us/library/windows/desktop/ms679351(v=vs.85).aspx for more informations about the FormatMessage method.
   * See https://msdn.microsoft.com/en-us/library/windows/desktop/ms679360(v=vs.85).aspx for more informations about the GetLastError method.
   * See https://msdn.microsoft.com/en-us/library/windows/desktop/ms681381(v=vs.85).aspx for more informations about the System Error Codes.
   * @param error_number The error number you received from GetLastError( ).
   * @return The system error message
   */
  public string get_error_message( uint32 error_number )
  {
    char * errorText = null;

    uint32 rc = Windows.FormatMessage(
      Windows.FORMAT_MESSAGE_FROM_SYSTEM        // use system message tables to retrieve error text
      | Windows.FORMAT_MESSAGE_ALLOCATE_BUFFER  // allocate buffer on local heap for error text
      | Windows.FORMAT_MESSAGE_IGNORE_INSERTS,  // Important! Will fail otherwise, since we're not (and CANNOT) pass insertion parameters
      null,                                     // unused with FORMAT_MESSAGE_FROM_SYSTEM
      error_number,                             // input
      0,                                        // language, 0 for system language
      &errorText,                               // output
      0,                                        // minimum size for output buffer
      null
    );

    if ( rc == 0 || errorText == null )
    {
      return "Could not generate error message from error number %ld. RC = %ld".printf( error_number, GetLastError( ) );
    }
    return (string)errorText;
  }
#endif
}
