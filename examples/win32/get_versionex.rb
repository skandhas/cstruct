# CStruct Examples
require 'windows/system_info'
require 'cstruct/win32struct'
include Windows::SystemInfo


# OSVERSIONINFOEXA in VC6 's SDK
#typedef struct _OSVERSIONINFOEXA {
#    DWORD dwOSVersionInfoSize;
#    DWORD dwMajorVersion;
#    DWORD dwMinorVersion;
#    DWORD dwBuildNumber;
#    DWORD dwPlatformId;
#    CHAR   szCSDVersion[ 128 ];     // Maintenance string for PSS usage
#    WORD wServicePackMajor;
#    WORD wServicePackMinor;
#    WORD wReserved[2];
#} OSVERSIONINFOEXA;


class OSVERSIONINFOEXA < Win32Struct
  DWORD :dwOSVersionInfoSize
  DWORD :dwMajorVersion
  DWORD :dwMinorVersion
  DWORD :dwBuildNumber
  DWORD :dwPlatformId
  CHAR  :szCSDVersion,[ 128 ]
  WORD  :wServicePackMajor
  WORD  :wServicePackMinor
  WORD  :wReserved,[2]    
end

ver_info_ex = OSVERSIONINFOEXA.new do |st| 
  st.dwOSVersionInfoSize = OSVERSIONINFOEXA.__size__  # __size__ is an alias for method 'size'
end

#ANSI Version: GetVersionExA
GetVersionExA(ver_info_ex.__data__) # __data__ is an alias for method 'data'

puts "<OS Version Infomation>"
puts "Major Version:#{ver_info_ex.dwMajorVersion}"
puts "Minor Version:#{ver_info_ex.dwMinorVersion}"
puts "Build Number:#{ver_info_ex.dwBuildNumber}"
puts "Platform Id:#{ver_info_ex.dwPlatformId}"
puts "CSD Version:#{ver_info_ex.szCSDVersion.to_cstr}"      # to_cstr return a string(C Style)
puts "ServicePack Major:#{ver_info_ex.wServicePackMajor}"
puts "ServicePack Minor:#{ver_info_ex.wServicePackMinor}"