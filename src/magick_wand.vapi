
[CCode (cheader_filename = "wand/MagickWand.h")]

namespace MagickWand
{
  [CCode (cname = "MagickWandGenesis")]
  public static void MagickWandGenesis();

  [CCode (cname = "MagickWandTerminus")]
  public static void MagickWandTerminus( );

  [CCode (cname="MagickRelinquishMemory")]
  public static void* relinquishMemory( void* data );

  [CCode (cname="GetMagickModule")]
  public static unowned string getModule( );

  [CCode (free_function = "DestroyMagickWand", cname = "MagickWand")]
  [Compact]
  public class MagickWand
  {
    [CCode (cname="NewMagickWand")]
    public MagickWand();

    [CCode (cname="MagickReadImage", instance_pos = 0)]
    public bool readImage( string filename );

    [CCode (cname="MagickGetException", instance_pos = 0)]
    public unowned string getException( out ExceptionType severity );

    [CCode (cname="MagickWriteImage", instance_pos = 0)]
    public bool writeImage( string filename );

    [CCode (cname="MagickSetImageFormat", instance_pos = 0)]
    public bool setFormat( string format );

    [CCode (cname="MagickSetImageColor", instance_pos = 0)]
    public bool setColor( Pixel color );

    [CCode (cname="MagickGetImageHeight")]
    public ulong getHeight();

    [CCode (cname="MagickGetImageWidth")]
    public ulong getWidth();

    [CCode (cname="MagickGetImageDepth")]
    public ulong getDepth();

    [CCode (cname="MagickGetImageChannelDepth")]
    public ulong getChannelDepth(ChannelType channel);

    [CCode (cname="MagickGetImageColorspace")]
    public Colorspace getColorspace();

    [CCode (cname="MagickSetImageColorspace")]
    public bool setColorspace( Colorspace cspace );

    [CCode (cname="MagickGetImageResolution")]
    public bool getResolution(out double X, out double Y);

    [CCode (cname="MagickSetImageResolution")]
    public bool setResolution( double X, double Y );

    [CCode (cname="MagickGetImageAlphaChannel")]
    public bool hasAlphaChannel();

    [CCode (cname="MagickGetImageType")]
    public ImageType getImageType();

    [CCode (cname="MagickGetImageUnits")]
    public ResolutionType getResolutionType();

    [CCode (cname="MagickSetImageUnits")]
    public bool setResolutionType( ResolutionType resolution_type );

    [CCode (cname="MagickGetImageBlob", array_length_pos = -1)]
    public uint8[] getImageBlob();

    [CCode (cname="MagickExportImagePixels")]
    public bool exportImagePixels(ssize_t x, ssize_t y, size_t columns, size_t rows, string map, StorageType storage, void *pixels);

//    [CCode (cname="MagickGetException")]
//    public string getException(ref int severty);

    [CCode (cname="MagickGetImageCompression")]
    public CompressionType getImageCompression( );

    [CCode (cname="MagickSetImageCompression")]
    public void setImageCompression( CompressionType compression );

    [CCode (cname="MagickGetResolution")]
    public bool getMagickResolution( out double x, out double y );

    [CCode (cname="MagickSetResolution")]
    public bool setMagickResolution( double x, double y );

    [CCode (cname="MagickSetImageColormapColor")]
    public bool setColormapColor( size_t index, Pixel color );

    [CCode (cname="MagickSetImageBorderColor")]
    public bool setBorderColor( Pixel color );

    [CCode (cname="MagickSetImageMatteColor")]
    public bool setMatteColor( Pixel color );

    [CCode (cname="MagickFloodfillPaintImage")]
    public bool floodfillPaint( ChannelType channel_type, Pixel fill, double fuzz, Pixel bordercolor, ssize_t x, ssize_t y, bool invert );

    [CCode (cname="MagickSetImageChannelDepth")]
    public bool setChannelDepth( ChannelType channel_type, size_t depth );

    [CCode (cname="MagickOpaquePaintImage")]
    public bool opaquePaint( Pixel target, Pixel fill, double fuzz, bool invert );

    [CCode (cname="MagickTransparentPaintImage")]
    public bool transparentPaint( Pixel target, double alpha, double fuzz, bool invert );

    [CCode (cname="MagickSetAntialias")]
    public bool setAntialias( bool antialias );
  }

  [CCode (cname="ColorspaceType")]
  public enum Colorspace
  {
    [CCode (cname="UndefinedColorspace")]
    UndefinedColorspace,
    [CCode (cname="RGBColorspace")]
    RGBColorspace,
    [CCode (cname="GRAYColorspace")]
    GRAYColorspace,
    [CCode (cname="TransparentColorspace")]
    TransparentColorspace,
    [CCode (cname="OHTAColorspace")]
    OHTAColorspace,
    [CCode (cname="LabColorspace")]
    LabColorspace,
    [CCode (cname="XYZColorspace")]
    XYZColorspace,
    [CCode (cname="YCbCrColorspace")]
    YCbCrColorspace,
    [CCode (cname="YCCColorspace")]
    YCCColorspace,
    [CCode (cname="VIQColorspace")]
    YIQColorspace,
    [CCode (cname="YPbPrColorspace")]
    YPbPrColorspace,
    [CCode (cname="YUVColorspace")]
    YUVColorspace,
    [CCode (cname="CMYKColorspace")]
    CMYKColorspace,
    [CCode (cname="sRGBColorspace")]
    sRGBColorspace,
    [CCode (cname="HSBColorspace")]
    HSBColorspace,
    [CCode (cname="HSLColorspace")]
    HSLColorspace,
    [CCode (cname="HWBColorspace")]
    HWBColorspace,
    [CCode (cname="Rec601LumaColorspace")]
    Rec601LumaColorspace,
    [CCode (cname="Rec601YCbCrColorspace")]
    Rec601YCbCrColorspace,
    [CCode (cname="Rec709LumaColorspace")]
    Rec709LumaColorspace,
    [CCode (cname="Rec709YCbCrColorspace")]
    Rec709YCbCrColorspace,
    [CCode (cname="LogColorspace")]
    LogColorspace,
    [CCode (cname="CMYColorspace")]
    CMYColorspace
  }

  [CCode (cname="ImageType")]
  public enum ImageType
  {
    [CCode (cname="UndefinedType")]
    UndefinedType,
    [CCode (cname="BilevelType")]
    BilevelType,
    [CCode (cname="GrayscaleType")]
    GrayscaleType,
    [CCode (cname="GrayscaleMatteType")]
    GrayscaleMatteType,
    [CCode (cname="PaletteType")]
    PaletteType,
    [CCode (cname="PaletteMatteType")]
    PaletteMatteType,
    [CCode (cname="TrueColorType")]
    TrueColorType,
    [CCode (cname="TrueColorMatteType")]
    TrueColorMatteType,
    [CCode (cname="ColorSeparationType")]
    ColorSeparationType,
    [CCode (cname="ColorSeparationMatteType")]
    ColorSeparationMatteType,
    [CCode (cname="OptimizeType")]
    OptimizeType,
    [CCode (cname="PaletteBilevelMatteType")]
    PaletteBilevelMatteType
  }

  [CCode (cname="ChannelType")]
  public enum ChannelType
  {
    [CCode (cname="UndefinedChannel")]
    UndefinedChannel,
    [CCode (cname="RedChannel")]
    RedChannel,
    [CCode (cname="GrayChannel")]
    GrayChannel,
    [CCode (cname="CyanChannel")]
    CyanChannel,
    [CCode (cname="GreenChannel")]
    GreenChannel,
    [CCode (cname="MagentaChannel")]
    MagentaChannel,
    [CCode (cname="BlueChannel")]
    BlueChannel,
    [CCode (cname="YellowChannel")]
    YellowChannel,
    [CCode (cname="AlphaChannel")]
    AlphaChannel,
    [CCode (cname="OpacityChannel")]
    OpacityChannel,
    [CCode (cname="MatteChannel")]
    MatteChannel,  /* deprecated */
    [CCode (cname="BlackChannel")]
    BlackChannel,
    [CCode (cname="IndexChannel")]
    IndexChannel,
    [CCode (cname="AllChannels")]
    AllChannels,
    /* special channel types */
    [CCode (cname="TrueAlphaChannel")]
    TrueAlphaChannel, /* extract actual alpha channel from opacity */
    [CCode (cname="RGBChannels")]
    RGBChannels,      /* set alpha from  grayscale mask in RGB */
    [CCode (cname="GrayChannels")]
    GrayChannels,
    [CCode (cname="SyncChannels")]
    SyncChannels,     /* channels should be modified equally */
    [CCode (cname="DefaultChannels")]
    DefaultChannels
  }

  [CCode (cname="CompressionType")]
  public enum CompressionType
  {
    [CCode (cname="UndefinedCompression")]
    UndefinedCompression,
    [CCode (cname="NoCompression")]
    NoCompression,
    [CCode (cname="BZipCompression")]
    BZipCompression,
    [CCode (cname="DXT1Compression")]
    DXT1Compression,
    [CCode (cname="DXT3Compression")]
    DXT3Compression,
    [CCode (cname="DXT5Compression")]
    DXT5Compression,
    [CCode (cname="FaxCompression")]
    FaxCompression,
    [CCode (cname="Group4Compression")]
    Group4Compression,
    [CCode (cname="JPEGCompression")]
    JPEGCompression,
    [CCode (cname="JPEG2000Compression")]
    JPEG2000Compression,
    [CCode (cname="LosslessJPEGCompression")]
    LosslessJPEGCompression,
    [CCode (cname="LZWCompression")]
    LZWCompression,
    [CCode (cname="RLECompression")]
    RLECompression,
    [CCode (cname="ZipCompression")]
    ZipCompression,
    [CCode (cname="ZipSCompression")]
    ZipSCompression,
    [CCode (cname="PizCompression")]
    PizCompression,
    [CCode (cname="Pxr24Compression")]
    Pxr24Compression,
    [CCode (cname="B44Compression")]
    B44Compression,
    [CCode (cname="B44ACompression")]
    B44ACompression,
    [CCode (cname="LZMACompression")]
    LZMACompression,
    [CCode (cname="JBIG1Compression")]
    JBIG1Compression,
    [CCode (cname="JBIG2Compression")]
    JBIG2Compression
  }

  [CCode (cname="ResolutionType")]
  public enum ResolutionType
  {
    [CCode (cname="UndefinedResolution")]
    UndefinedResolution,
    [CCode (cname="PixelsPerInchResolution")]
    PixelsPerInchResolution,
    [CCode (cname="PixelsPerCentimeterResolution")]
    PixelsPerCentimeterResolution
  }

  [CCode (cname="ExceptionType")]
  public enum ExceptionType
  {
    [CCode (cname="UndefinedException")]
    UndefinedException,
    [CCode (cname="WarningException")]
    WarningException,
    [CCode (cname="ResourceLimitWarning")]
    ResourceLimitWarning,
    [CCode (cname="TypeWarning")]
    TypeWarning,
    [CCode (cname="OptionWarning")]
    OptionWarning,
    [CCode (cname="DelegateWarning")]
    DelegateWarning,
    [CCode (cname="MissingDelegateWarning")]
    MissingDelegateWarning,
    [CCode (cname="CorruptImageWarning")]
    CorruptImageWarning,
    [CCode (cname="FileOpenWarning")]
    FileOpenWarning,
    [CCode (cname="BlobWarning")]
    BlobWarning,
    [CCode (cname="StreamWarning")]
    StreamWarning,
    [CCode (cname="CacheWarning")]
    CacheWarning,
    [CCode (cname="CoderWarning")]
    CoderWarning,
    [CCode (cname="ModuleWarning")]
    ModuleWarning,
    [CCode (cname="DrawWarning")]
    DrawWarning,
    [CCode (cname="ImageWarning")]
    ImageWarning,
    [CCode (cname="WandWarning")]
    WandWarning,
    [CCode (cname="RandomWarning")]
    RandomWarning,
    [CCode (cname="XServerWarning")]
    XServerWarning,
    [CCode (cname="MonitorWarning")]
    MonitorWarning,
    [CCode (cname="RegistryWarning")]
    RegistryWarning,
    [CCode (cname="ConfigureWarning")]
    ConfigureWarning,
    [CCode (cname="PolicyWarning")]
    PolicyWarning,
    [CCode (cname="ErrorException")]
    ErrorException,
    [CCode (cname="ResourceLimitError")]
    ResourceLimitError,
    [CCode (cname="TypeError")]
    TypeError,
    [CCode (cname="OptionError")]
    OptionError,
    [CCode (cname="DelegateError")]
    DelegateError,
    [CCode (cname="MissingDelegateError")]
    MissingDelegateError,
    [CCode (cname="CorruptImageError")]
    CorruptImageError,
    [CCode (cname="FileOpenError")]
    FileOpenError,
    [CCode (cname="BlobError")]
    BlobError,
    [CCode (cname="StreamError")]
    StreamError,
    [CCode (cname="CacheError")]
    CacheError,
    [CCode (cname="CoderError")]
    CoderError,
    [CCode (cname="ModuleError")]
    ModuleError,
    [CCode (cname="DrawError")]
    DrawError,
    [CCode (cname="ImageError")]
    ImageError,
    [CCode (cname="WandError")]
    WandError,
    [CCode (cname="RandomError")]
    RandomError,
    [CCode (cname="XServerError")]
    XServerError,
    [CCode (cname="MonitorError")]
    MonitorError,
    [CCode (cname="RegistryError")]
    RegistryError,
    [CCode (cname="ConfigureError")]
    ConfigureError,
    [CCode (cname="PolicyError")]
    PolicyError,
    [CCode (cname="FatalErrorException")]
    FatalErrorException,
    [CCode (cname="ResourceLimitFatalError")]
    ResourceLimitFatalError,
    [CCode (cname="TypeFatalError")]
    TypeFatalError,
    [CCode (cname="OptionFatalError")]
    OptionFatalError,
    [CCode (cname="DelegateFatalError")]
    DelegateFatalError,
    [CCode (cname="MissingDelegateFatalError")]
    MissingDelegateFatalError,
    [CCode (cname="CorruptImageFatalError")]
    CorruptImageFatalError,
    [CCode (cname="FileOpenFatalError")]
    FileOpenFatalError,
    [CCode (cname="BlobFatalError")]
    BlobFatalError,
    [CCode (cname="StreamFatalError")]
    StreamFatalError,
    [CCode (cname="CacheFatalError")]
    CacheFatalError,
    [CCode (cname="CoderFatalError")]
    CoderFatalError,
    [CCode (cname="ModuleFatalError")]
    ModuleFatalError,
    [CCode (cname="DrawFatalError")]
    DrawFatalError,
    [CCode (cname="ImageFatalError")]
    ImageFatalError,
    [CCode (cname="WandFatalError")]
    WandFatalError,
    [CCode (cname="RandomFatalError")]
    RandomFatalError,
    [CCode (cname="XServerFatalError")]
    XServerFatalError,
    [CCode (cname="MonitorFatalError")]
    MonitorFatalError,
    [CCode (cname="RegistryFatalError")]
    RegistryFatalError,
    [CCode (cname="ConfigureFatalError")]
    ConfigureFatalError,
    [CCode (cname="PolicyFatalError")]
    PolicyFatalError
  }

  [CCode (cname="StorageType")]
  public enum StorageType
  {
    [CCode (cname="UndefinedPixel")]
    UndefinedPixel,
    [CCode (cname="CharPixel")]
    CharPixel,
    [CCode (cname="DoublePixel")]
    DoublePixel,
    [CCode (cname="FloatPixel")]
    FloatPixel,
    [CCode (cname="IntegerPixel")]
    IntegerPixel,
    [CCode (cname="LongPixel")]
    LongPixel,
    [CCode (cname="QuantumPixel")]
    QuantumPixel,
    [CCode (cname="ShortPixel")]
    ShortPixel
  }

  [CCode (free_function = "DestroyPixelWand", cname = "PixelWand")]
  [Compact]
  public class Pixel
  {
    [CCode (cname = "NewPixelWand")]
    public Pixel( );

    [CCode (cname="PixelSetColor", instance_pos = 0)]
    public bool setColor( string color );
  }
}
