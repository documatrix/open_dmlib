/**
 * 64 bit version of ftell method.
 */
uint64 ftello64( GLib.FileStream stream );

/**
 * 64 bit version of fseek method.
 */
int fseeko64( GLib.FileStream stream, uint64 offset, GLib.FileSeek whence );


[Compact]
  [CCode (cname = "FILE", free_function = "fclose", cheader_filename = "stdio.h")]
  public class DMFileStream
  {
    [CCode (cname = "EOF", cheader_filename = "stdio.h")]
    public const int EOF;

    [CCode (cname = "g_fopen", cheader_filename = "glib/gstdio.h")]
    public static DMFileStream? open (string path, string mode);
    [CCode (cname = "fdopen")]
    public static DMFileStream? fdopen (int fildes, string mode);
    [CCode (cname = "fprintf")]
    [PrintfFormat ()]
    public void printf (string format, ...);
    [CCode (cname = "vfprintf")]
    public void vprintf (string format, va_list args);
    [CCode (cname = "fputc", instance_pos = -1)]
    public void putc (char c);
    [CCode (cname = "fputs", instance_pos = -1)]
    public void puts (string s);
    [CCode (cname = "fgetc")]
    public int getc ();
    [CCode (cname = "ungetc", instance_pos = -1)]
    public int ungetc (int c);
    [CCode (cname = "fgets", instance_pos = -1)]
    public unowned string? gets (char[] s);
    [CCode (cname = "feof")]
    public bool eof ();
    [CCode (cname = "fscanf"), ScanfFormat]
    public int scanf (string format, ...);
    [CCode (cname = "fflush")]
    public int flush ();

#if OS_WINDOWS

    [CCode (cname = "fseeko64")]
    public int seek( uint64 offset, GLib.FileSeek whence );

    [CCode (cname = "ftello64")]
    public uint64 tell( );

#else

    [CCode (cname = "fseek")]
    public int seek (long offset, FileSeek whence);

    [CCode (cname = "ftell")]
    public long tell( );

#endif

    [CCode (cname = "rewind")]
    public void rewind ();
    [CCode (cname = "fileno")]
    public int fileno ();
    [CCode (cname = "ferror")]
    public int error ();
    [CCode (cname = "clearerr")]
    public void clearerr ();
    [CCode (cname = "fread", instance_pos = -1)]
    public size_t read ([CCode (array_length_pos = 2.1)] uint8[] buf, size_t size = 1);
    [CCode (cname = "fwrite", instance_pos = -1)]
    public size_t write ([CCode (array_length_pos = 2.1)] uint8[] buf, size_t size = 1);

    public string? read_line ()
    {
      int c;
      StringBuilder? ret = null;
      while ((c = getc ()) != EOF) {
        if (ret == null) {
          ret = new StringBuilder ();
        }
        if (c == '\n') {
          break;
        }
        ((!)(ret)).append_c ((char) c);
      }
      if (ret == null) {
        return null;
      } else {
        return ((!)(ret)).str;
      }
    }
  }
