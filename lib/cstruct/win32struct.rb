require "cstruct/cstruct"
class Win32Struct< CStruct  
  class << self             
    # Handle
    alias HANDLE    uint32
    alias HMODULE   uint32
    alias HINSTANCE uint32       
    alias HRGN      uint32
    alias HTASK     uint32
    alias HKEY      uint32
    alias HDESK     uint32
    alias HMF       uint32
    alias HEMF      uint32
    alias HRSRC     uint32
    alias HSTR      uint32
    alias HWINSTA   uint32
    alias HKL       uint32
    alias HGDIOBJ   uint32 
    alias HICON     uint32  
    alias HPEN      uint32
    alias HACCEL    uint32
    alias HBITMAP   uint32
    alias HBRUSH    uint32
    alias HCOLORSPACE   uint32
    alias HDC           uint32
    alias HGLRC         uint32
    alias HENHMETAFILE  uint32
    alias HFONT         uint32
    alias HMENU         uint32
    alias HMETAFILE     uint32
    alias HPALETTE      uint32
    alias HCURSOR       uint32
    
    # Data Type
    alias WPARAM    uint32
    alias LPARAM    uint32
    alias LRESULT   uint32
    alias ATOM      uint32
    
    alias BOOL      uint32
    alias DWORD     uint32
    alias WORD      uint16
    alias BYTE      uint8
    
    alias ULONG     uint32
    alias UINT      uint32
    alias USHORT    uint16
    alias UCHAR     uchar
    
    alias LONG      int32
    alias INT       int32
    alias SHORT     int16
    alias CHAR      char   
    alias WCHAR     uint16

    # Pointer
    alias DWORD_PTR uint32
    alias ULONG_PTR uint32
    alias UINT_PTR  uint32
    alias PHANDLE   uint32
    
    alias PBOOL     uint32
    alias LPBOOL    uint32
    alias PBYTE     uint32
    alias LPBYTE    uint32
    alias PINT      uint32
    alias LPINT     uint32
    alias PWORD     uint32
    alias LPWORD    uint32
    alias LPLONG    uint32
    alias PDWORD    uint32
    alias LPDWORD   uint32
    alias LPVOID    uint32
    alias LPCVOID   uint32
    alias LPCSTR    uint32
    
  end
end
