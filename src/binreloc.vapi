[CCode (cheader_filename="binreloc.h")]
namespace BinReloc
{
  [CCode (cname="BrInitError")]
  public enum InitError
  {
	  BR_INIT_ERROR_NOMEM,
	  BR_INIT_ERROR_OPEN_MAPS,
	  BR_INIT_ERROR_READ_MAPS,
	  BR_INIT_ERROR_INVALID_MAPS,
	  BR_INIT_ERROR_DISABLED;
  }

  [CCode (cname="br_init")]
  public int init( ref InitError error );

  [CCode (cname="br_find_exe_dir")]
  public string? find_exe_dir( string? default_exe );
}
