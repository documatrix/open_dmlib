using Posix;

namespace OpenDMLib
{
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
   * @return true of v1 == v2.
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
   * @return true of v1 == v2.
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
   * @return true of v1 == v2.
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
   * @return true of v1 == v2.
   */
  public bool unichar_equal( unichar? v1, unichar? v2 )
  {
    return *((unichar*)v1) == *((unichar*)v2);
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
     * Some errors which may occur using methods of OpenDMLib.IO.
     */
    public errordomain OpenDMLibIOErrors {
      FILE_ERROR,
      NOT_EXISTS
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

    public string? get_mime_type( string filename ) throws Error
    {
      GLib.File f = GLib.File.new_for_path( filename );
      FileInfo fi = f.query_info( "standard::*", FileQueryInfoFlags.NONE );
      string content_type = fi.get_content_type( );
      return ContentType.get_mime_type( content_type );
    }

    public FileStream open( string filename, string mode ) throws OpenDMLibIOErrors
    {
      FileStream? f = FileStream.open( filename, mode );
      if ( f == null )
      {
        throw new OpenDMLibIOErrors.FILE_ERROR( "ERROR " + GLib.errno.to_string() + ": " + GLib.strerror( GLib.errno ) );
      }
      return f;
    }

    public class BufferedFileReader : GLib.Object
    {
      private FileStream? owned_file;
      public unowned FileStream? file;

      string filename;

      /* Diese beiden Buffer-Variablen betreffen den Buffer für das Auslesen aus dem File */
      uchar[] buffer;
      size_t buffer_index;

      public BufferedFileReader.with_filename( string filename )
      {
        this.filename = filename;
        this.owned_file = OpenDMLib.IO.open( filename, "rb" );
        this.file = this.owned_file;
        this.buffer = new uchar[BUFFER_SIZE];
        this.buffer_index = BUFFER_SIZE;
      }

      public BufferedFileReader.with_filestream( FileStream file )
      {
        this.file = file;
        this.buffer = new uchar[BUFFER_SIZE];
        this.buffer_index = BUFFER_SIZE;
      }

      public void close( )
      {
        this.file = null;
        this.owned_file = null;
      }

      public string read_string() throws Error
      {
        int64 l = 0;
        this.get_from_buffer(&l, sizeof(int64));
        char[] tmp = new char[l + 1];
        this.get_from_buffer(tmp, (size_t)l);
        tmp[l] = 0;
        return (string)tmp;
      }

      public void get_from_buffer(void * data, size_t size)
      {
        try
        {
          size_t delta = 0;
          uchar[] tmp_buffer = null;
          if (this.buffer_index + size > BUFFER_SIZE)
          {
            tmp_buffer = new uchar[size];
            /* Das geht sich nicht mehr aus! */
            /* Muss ich stückeln (kommt vor, wenn sich die Daten noch zum Teil im alten Buffer stehen)? */
            delta = BUFFER_SIZE - this.buffer_index;

            if ( delta > 0 && delta < size )
            {
              /* Das Delta ist leider nicht genau die größe => ich muss das Stück aus dem alten Buffer wegsichern ... */
              Memory.copy(tmp_buffer, &this.buffer[this.buffer_index], delta);
            }

            /* Die nächsten Daten lesen */
            this.file.read( this.buffer );
            if (delta != 0)
            {
              /* Stückeln is angesagt => den zweiten Teil aus dem neuen Buffer lesen */
              Memory.copy(&tmp_buffer[delta], buffer, size - delta);
              this.buffer_index = size - delta;
            }
            else
            {
              this.buffer_index = 0;
            }
          }
          if (delta == 0 || delta == size)
          {
            /* Da war keine Stückelung */
            Memory.copy(data, &this.buffer[this.buffer_index], size);
            this.buffer_index += size;
          }
          else
          {
            /* Ich habe gestückelt */
            Memory.copy(data, tmp_buffer, size);
          }
        }
        catch (Error e)
        {
          GLib.stderr.printf( "Error while reading from buffer! %s\n", e.message );
        }
      }
    }

    public class BufferedFile : GLib.Object
    {
      private string? filename;
      private FileStream? owned_file;
      public unowned FileStream? file;
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
          Memory.copy( &this.buffer[ this.buffer_index ], data, size );
          this.buffer_index += size;
        }
        catch (Error e)
        {
          GLib.stderr.printf( "Error writing to file: %s\n", e.message );
        }
      }

      public void write_string( string s ) throws Error
      {
        char[] tmp = s.to_utf8();
        int64 l = tmp.length;
        this.add_to_buffer( &l, sizeof(int64) );
        this.add_to_buffer( tmp, (size_t)l );
      }

      public BufferedFile.with_filename( string filename )
      {
        this.filename = filename;
        this.owned_file = OpenDMLib.IO.open( filename, "wb" );
        this.file = this.owned_file;
        this.buffer = new uchar[BUFFER_SIZE];
        this.buffer_index = 0;
      }

      public BufferedFile.with_filestream( FileStream file )
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
       */
      public FileSystemObject( string path ) throws OpenDMLibIOErrors
      {
        if ( !OpenDMLib.IO.file_exists( path ) )
        {
          throw new OpenDMLibIOErrors.NOT_EXISTS( "Could not create FileSystemObject for path %s! The path does not exist!", path );
        }

        this.path = path;
        this.name = Path.get_basename( path );

        if ( OpenDMLib.IO.is_directory( path ) )
        {
          this.directory = true;

          GLib.Dir d;
          try
          {
            d = GLib.Dir.open( path );

            unowned string entry;
            FileSystemObject[] children = { };
            while ( ( entry = d.read_name( ) ) != null )
            {
              if ( entry == "." || entry == ".." )
              {
                continue;
              }
              children += new FileSystemObject( OpenDMLib.get_dir( this.path ) + entry );
            }
            this.children = children;
          }
          catch ( Error e )
          {
            GLib.stderr.printf( "Error while opening directory %s! %s", path, e.message );
          }
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
      _val = _val.replace( "/", "\\" );
      _val = _val.replace( "\\\\", "\\" );
    }
    else
    {
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
    private unowned FileStream os;
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

    public Ascii85(FileStream os)
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

    public new void set( int index, G val )
    {
      this.data[ index ] = val;
    }

    public new G get( int index )
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
  }

  /**
   * This method returns a name for a temporary file.
   * The returned filename should be unique.
   * @return A temporary filename.
   */
  public string get_temp_file( )
  {
    string fnam = OpenDMLib.get_dir( Environment.get_tmp_dir( ) ) + OpenDMLib.getpid( ).to_string( ) + "_" + Random.next_int( ).to_string( ) + ".tmp";
    return fnam;
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
      this.time.year = year;
      this.time.month = month;
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
}