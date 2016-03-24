/**
 * This vapi file contains some binding informations for the windows.h file.
 */
namespace Windows
{
  [CCode (cheader_filename="windef.h", cname="MAX_PATH")]
  public static const uint32 MAX_PATH;

  [SimpleType]
  [CCode (cname="DWORD", has_type_id=false)]
  public struct DWORD : uint32
  {
  }

  [SimpleType]
  [CCode (cname="HRESULT", has_type_id=false)]
  public struct HRESULT : uint32
  {
  }


  [CCode (cheader_filename="windows.h,fileapi.h")]
  namespace FileApi
  {
    [CCode (cname="INVALID_HANDLE_VALUE")]
    public static void* INVALID_HANDLE_VALUE;

    [CCode (cname="FINDEX_INFO_LEVELS", cprefix="FindExInfo", has_type_id=false)]
    public enum FIndex_Info_Levels
    {
      Standard,
      Basic,
      MaxInfoLevel;
    }

    [CCode (cname="FINDEX_SEARCH_OPS", cprefix="FindExSearch", has_type_id=false)]
    public enum FIndex_Search_Ops
    {
      NameMatch,
      LimitToDirectories,
      LimitToDevices,
      MaxSearchOp;
    }

    [CCode (cname="DWORD", cprefix="FIND_FIRST_EX_", has_type_id=false)]
    public enum FindFlags
    {
      CASE_SENSITIVE,
      LARGE_FETCH;
    }

    [CCode (cname="DWORD", cprefix="FILE_ATTRIBUTE_", has_type_id=false)]
    public enum FileAttribute
    {
      READONLY,
      HIDDEN,
      SYSTEM,
      DIRECTORY,
      ARCHIVE,
      DEVICE,
      NORMAL,
      TEMPORARY,
      SPARSE_FILE,
      REPARSE_POINT,
      COMPRESSED,
      OFFLINE,
      NOT_CONTENT_INDEXED,
      ENCRYPTED,
      VIRTUAL;
    }

    [CCode (cname="WIN32_FIND_DATA", has_type_id=false)]
    public struct FindData
    {
      FileAttribute dwFileAttributes;
      FileTime ftCreationTime;
      FileTime ftLastAccessTime;
      FileTime ftLastWriteTime;
      DWORD nFileSizeHigh;
      DWORD nFileSizeLow;
      DWORD dwReserved0;
      DWORD dwReserved1;
      char* cFileName;
      char* cAlternateFileName;
    }

    [CCode (cname="FILETIME", has_type_id=false)]
    public struct FileTime
    {
      DWORD dwLowDateTime;
      DWORD dwHighDateTime;
    }

    [CCode (cname="FindFirstFileEx")]
    public void* FindFirstFileEx( char* lpFileName, FIndex_Info_Levels fInfoLevelId, FindData* lpFindFileData, FIndex_Search_Ops fSearchOp, void* lpSearchFilter, DWORD dwAdditionalFlags );

    [CCode (cname="FindNextFile")]
    public bool FindNextFile( void* hFindFile, FindData* lpFindFileData );

    [CCode (cname="FindClose")]
    public bool FindClose( void* hFindFile );
  }

  [CCode (cheader_filename="windows.h,commdlg.h")]
  namespace CommonDialog
  {
    [CCode (cname="DWORD", cprefix="OFN_", has_type_id=false)]
    public enum DialogFlags
    {
      READONLY,
      OVERWRITEPROMPT,
      HIDEREADONLY,
      NOCHANGEDIR,
      SHOWHELP,
      ENABLEHOOK,
      ENABLETEMPLATE,
      ENABLETEMPLATEHANDLE,
      NOVALIDATE,
      ALLOWMULTISELECT,
      EXTENSIONDIFFERENT,
      PATHMUSTEXIST,
      FILEMUSTEXIST,
      CREATEPROMPT,
      SHAREAWARE,
      NOREADONLYRETURN,
      NOTESTFILECREATE,
      NONETWORKBUTTON,
      NOLONGNAMES,
      EXPLORER,
      NODEREFERENCELINKS,
      LONGNAME,
      ENABLEINCLUDENOTIFY,
      ENABLESIZING,
      DONTADDTORECENT,
      FORCESHOWHIDDEN,
      EX_NOPLACESBAR,
      SHAREFALLTHROUGH,
      SHARENOWARN,
      SHAREWARN;
    }

    [CCode (cname="OPENFILENAME")]
    public struct OpenFilename
    {
      public DWORD lStructSize;

      public DWORD nMaxFile;

      public char* lpstrFile;

      public char* lpstrFilter;

      public char* lpstrTitle;

      public DWORD nFilterIndex;

      public DWORD Flags;

      public DWORD nMaxFileTitle;

      public char* lpstrInitialDir;

      /**
       * This method displays the Windows filechooser.
       * @param save Determines if the OpenFilename or SaveFilename dialog should be displayed.
       * @return The chosen filename or null if the dialog was canceled.
       */
      public string? show( bool save = false )
      {
        char[] file;
        this.lStructSize = (uint32)sizeof( OpenFilename );

        if ( this.lpstrFile == null )
        {
          file = new char[ MAX_PATH ];
          this.lpstrFile = file;
          this.lpstrFile[ 0 ] = 0;
        }

        this.nMaxFile = MAX_PATH;
        this.nFilterIndex = 1;
        this.nMaxFileTitle = 0;
        this.Flags = DialogFlags.PATHMUSTEXIST | DialogFlags.FILEMUSTEXIST | DialogFlags.DONTADDTORECENT;

        if ( save )
        {
          if ( GetSaveFileName( &this ) )
          {
            return (string)this.lpstrFile;
          }
        }
        else
        {
          if ( GetOpenFileName( &this ) )
          {
            return (string)this.lpstrFile;
          }
        }

        return null;
      }
    }

    [CCode (cname="GetOpenFileName")]
    private bool GetOpenFileName( OpenFilename* ofn );

    [CCode (cname="GetSaveFileName")]
    private bool GetSaveFileName( OpenFilename* ofn );
  }
}
