# CStruct Examples
require 'windows/memory'
require 'win32struct'

include Windows::Memory

# example:

# typedef struct _MEMORYSTATUS {
#     DWORD dwLength;
#     DWORD dwMemoryLoad;
#     DWORD dwTotalPhys;
#     DWORD dwAvailPhys;
#     DWORD dwTotalPageFile;
#     DWORD dwAvailPageFile;
#     DWORD dwTotalVirtual;
#     DWORD dwAvailVirtual;
# } MEMORYSTATUS, *LPMEMORYSTATUS;

class MEMORYSTATUS < Win32Struct
    DWORD :dwLength
    DWORD :dwMemoryLoad
    DWORD :dwTotalPhys
    DWORD :dwAvailPhys
    DWORD :dwTotalPageFile
    DWORD :dwAvailPageFile
    DWORD :dwTotalVirtual
    DWORD :dwAvailVirtual	
end



# create a MEMORYSTATUS's instance
stat = MEMORYSTATUS.new {|st| st.dwLength = MEMORYSTATUS.size }

# call API "GlobalMemoryStatus" - See also MSDN
GlobalMemoryStatus(stat.data)

#output
printf "[Physical Memory]\n"
printf "  total:%12d bytes\n",stat.dwTotalPhys
printf "  free :%12d bytes\n",stat.dwAvailPhys

printf "[Virtual Memory]\n"
printf "  total:%12d bytes\n",stat.dwTotalVirtual
printf "  free :%12d bytes\n",stat.dwAvailVirtual

printf "[Paging File]\n"
printf "  total:%12d bytes\n",stat.dwTotalPageFile
printf "  free :%12d bytes\n",stat.dwAvailPageFile

