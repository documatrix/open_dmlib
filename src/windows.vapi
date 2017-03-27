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

  [CCode (cname="SECURITY_ATTRIBUTES")]
  public struct SecurityAttributes
  {
    public uint32 nLength;
    public void *lpSecurityDescriptor;
    public bool bInheritHandle;
  }

  [CCode (cname="FORMAT_MESSAGE_FROM_SYSTEM")]
  public static uint32 FORMAT_MESSAGE_FROM_SYSTEM;

  [CCode (cname="FORMAT_MESSAGE_ALLOCATE_BUFFER")]
  public static uint32 FORMAT_MESSAGE_ALLOCATE_BUFFER;

  [CCode (cname="FORMAT_MESSAGE_IGNORE_INSERTS")]
  public static uint32 FORMAT_MESSAGE_IGNORE_INSERTS;

  [CCode (cname="INVALID_HANDLE_VALUE")]
  public static void* INVALID_HANDLE_VALUE;

  [CCode (cname="FormatMessage")]
  public DWORD FormatMessage( DWORD dwFlags, void* lpSource, DWORD dwMessageId, DWORD dwLanguageId, char ** lpBuffer, DWORD nSize, void* arguments );

  [CCode (cname="GetLastError")]
  public uint32 GetLastError( );

  [CCode (cheader_filename="windows.h,fileapi.h,winnt.h")]
  namespace FileApi
  {
    [CCode (cname="INVALID_HANDLE_VALUE")]
    public static void* INVALID_HANDLE_VALUE;

    [CCode (cname="FILE_ATTRIBUTE_NORMAL")]
    public static uint32 FILE_ATTRIBUTE_NORMAL;

    [CCode (cname="OPEN_ALWAYS")]
    public static uint32 OPEN_ALWAYS;

    [CCode (cname="CREATE_ALWAYS")]
    public static uint32 CREATE_ALWAYS;

    [CCode (cname="FILE_WRITE_DATA")]
    public static uint32 FILE_WRITE_DATA;

    [CCode (cname="FILE_SHARE_WRITE")]
    public static uint32 FILE_SHARE_WRITE;

    [CCode (cname="FILE_SHARE_READ")]
    public static uint32 FILE_SHARE_READ;

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

    [CCode (cname="CreateFile")]
    public void* CreateFile( char* lpFileName, DWORD dwDesiredAccess, DWORD dwShareMode, SecurityAttributes* lpSecurityAttributes, DWORD dwCreationDisposition, DWORD dwFlagsAndAttributes, void* hTemplateFile );

    [CCode (cname="FindFirstFileEx")]
    public void* FindFirstFileEx( char* lpFileName, FIndex_Info_Levels fInfoLevelId, FindData* lpFindFileData, FIndex_Search_Ops fSearchOp, void* lpSearchFilter, DWORD dwAdditionalFlags );

    [CCode (cname="FindNextFile")]
    public bool FindNextFile( void* hFindFile, FindData* lpFindFileData );

    [CCode (cname="FindClose")]
    public bool FindClose( void* hFindFile );

    [CCode (cname="GetVolumeInformation")]
    public bool GetVolumeInformation( char* lpRootPathName, char* lpVolumeNameBuffer, DWORD nVolumeNameSize, DWORD* lpVolumeSerialNumber, DWORD* lpMaximumComponentLength, DWORD* lpFileSystemFlags, char* lpFileSystemNameBuffer, DWORD nFileSystemNameSize );
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

  [CCode (cheader_filename="processthreadsapi.h,errhandlingapi.h,winerror.h,ntdef.h,windef.h,winbase.h,synchapi.h")]
  namespace ThreadsAPI
  {
    [CCode (cname="INFINITE")]
    public static uint32 INFINITE;

    [CCode (cname="CREATE_NO_WINDOW")]
    public static uint32 CREATE_NO_WINDOW;

    [CCode (cname="SW_HIDE")]
    public static uint16 SW_HIDE;

    [CCode (cname="STARTF_USESTDHANDLES")]
    public static uint32 STARTF_USESTDHANDLES;

    [CCode (cname="WAIT_FAILED")]
    public static const uint32 WAIT_FAILED;

    [CCode (cname="WAIT_ABANDONED")]
    public static const uint32 WAIT_ABANDONED;

    [CCode (cname="WAIT_OBJECT_0")]
    public static const uint32 WAIT_OBJECT_0;

    [CCode (cname="WAIT_TIMEOUT")]
    public static const uint32 WAIT_TIMEOUT;

    [CCode (cname="CloseHandle")]
    public bool CloseHandle( void * hObject );

    [CCode (cname="CreateProcess")]
    public bool CreateProcess( char* lpApplicationName, char* lpCommandLine, SecurityAttributes? lpProcessAttributes, SecurityAttributes? lpThreadAttributes, bool bInheritHandles, DWORD dwCreationFlags, void *lpEnvironment, char* lpCurrentDirectory, StartupInfo* lpStartupInfo, ProcessInformation* lpProcessInformation );

    [CCode (cname="WinExec")]
    public uint WinExec( string cmdline, uint uCmdShow );

    [CCode (cname="WaitForSingleObject")]
    public DWORD WaitForSingleObject( void* hProcess, DWORD dwMilliseconds );

    [CCode (cname="GetExitCodeProcess")]
    public bool GetExitCodeProcess( void* hProcess, DWORD** lpExitCode );

    [CCode (cname="STARTUPINFO")]
    public struct StartupInfo
    {
      public uint32  cb;
      public char *lpReserved;
      public char *lpDesktop;
      public char *lpTitle;
      public uint32 dwX;
      public uint32 dwY;
      public uint32 dwXSize;
      public uint32 dwYSize;
      public uint32 dwXCountChars;
      public uint32 dwYCountChars;
      public uint32 dwFillAttribute;
      public uint32 dwFlags;
      public uint16 wShowWindow;
      public uint16 cbReserved2;
      public uint8 lpReserved2;
      public void *hStdInput;
      public void *hStdOutput;
      public void *hStdError;
    }

    [CCode (cname="PROCESS_INFORMATION")]
    public struct ProcessInformation
    {
      public void *hProcess;
      public void *hThread;
      public uint32 dwProcessId;
      public uint32 dwThreadId;
    }
  }

}
