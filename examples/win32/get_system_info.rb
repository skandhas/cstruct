# CStruct Examples
require 'windows/system_info'
require 'cstruct/win32struct'
include Windows::SystemInfo

# SYSTEM_INFO in VC6 's SDK
# typedef struct _SYSTEM_INFO {
#     union {
#         DWORD dwOemId;          // Obsolete field...do not use
#         struct {
#             WORD wProcessorArchitecture;
#             WORD wReserved;
#         };
#     };
#     DWORD dwPageSize;
#     LPVOID lpMinimumApplicationAddress;
#     LPVOID lpMaximumApplicationAddress;
#     DWORD dwActiveProcessorMask;
#     DWORD dwNumberOfProcessors;
#     DWORD dwProcessorType;
#     DWORD dwAllocationGranularity;
#     WORD wProcessorLevel;
#     WORD wProcessorRevision;
# } SYSTEM_INFO, *LPSYSTEM_INFO;

# SYSTEM_INFO in Ruby
class SYSTEM_INFO < Win32Struct
  union:u do
    DWORD:dwOemId
    struct:x do
        WORD:wProcessorArchitecture
        WORD:wReserved  
    end
  end
  DWORD  :dwPageSize
  LPVOID :lpMinimumApplicationAddress
  LPVOID :lpMaximumApplicationAddress
  DWORD  :dwActiveProcessorMask
  DWORD  :dwNumberOfProcessors
  DWORD  :dwProcessorType
  DWORD  :dwAllocationGranularity
  WORD   :wProcessorLevel
  WORD   :wProcessorRevision
end

# call GetSystemInfo
sys_info = SYSTEM_INFO.new
GetSystemInfo(sys_info.__data__) # __data__ is an alias for method 'data'   
    
#output
puts "<System Infomation>" 
puts    "Processor Architecture:#{sys_info.u.x.wProcessorArchitecture}" # 'u' and 'x' can not be omitted
puts    "Page Size:#{sys_info.dwPageSize}"
puts    "Minimum Application Address:0x#{sys_info.lpMinimumApplicationAddress.to_s 16}"
puts    "Maximum Application Address:0x#{sys_info.lpMaximumApplicationAddress.to_s 16}"
puts    "Active Processor Mask:#{sys_info.dwActiveProcessorMask}"
puts    "Number Of Processors:#{sys_info.dwNumberOfProcessors}"
puts    "Processor Type:#{sys_info.dwProcessorType}"
puts    "Allocation Granularity:0x#{sys_info.dwAllocationGranularity.to_s 16}"
puts    "Processor Level:#{sys_info.wProcessorLevel}"
puts    "Processor Revision:#{sys_info.wProcessorRevision}"
    
    
    