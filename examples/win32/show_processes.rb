# CStruct Examples
require 'windows/tool_helper'
require 'cstruct/win32struct'
include Windows::ToolHelper

module Windows
  MAX_PATH = 260
  module ToolHelper 
    class PROCESSENTRY32 < Win32Struct
      DWORD   :dwSize
      DWORD   :cntUsage
      DWORD   :th32ProcessID 
      DWORD   :th32DefaultHeapID
      DWORD   :th32ModuleID 
      DWORD   :cntThreads
      DWORD   :th32ParentProcessID
      LONG    :pcPriClassBase        
      DWORD   :dwFlags
      CHAR    :szExeFile,[MAX_PATH]  
    end
  end 
end

def show_all_processes
  proc_enrty32 = PROCESSENTRY32.new
  proc_enrty32.dwSize = PROCESSENTRY32.__size__
  snap_handle  = CreateToolhelp32Snapshot( TH32CS_SNAPPROCESS,0)
  
  if Process32First(snap_handle,proc_enrty32.data)
    show_process proc_enrty32 
    while true
      break if !Process32Next( snap_handle,proc_enrty32.data ) 
      show_process proc_enrty32
    end   
  end
  
end

def show_process proc_enrty32
    printf"%20s 0x%08X\n",proc_enrty32.szExeFile.to_cstr,proc_enrty32.th32ProcessID
end

printf"%20s %s\n","<Process Name>","<PID>"
printf"%20s %s\n","--------------","-----"
show_all_processes