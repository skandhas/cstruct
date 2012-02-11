##Synopsis
CStruct is a simulation of the C language's struct.Its main purpose is to manipulate binary-data conveniently in Ruby. It can be used in:

  * Binary file IO like C.
  * The parameter of the OS's API.(e.g. Win32)
  * Other... 
  
Lean more: [http://cstruct.rubyforge.org/][1]

##Getting Started
###Install CStruct
Install CStruct is easy. 

    gem install cstruct

###Using CStruct
Let's see an example,struct Point in C language(32-bit platform) like this:

    struct Point
    {
      int x;
      int y;
    };
How to represent struct Point in Ruby? You can use CStruct to do it.

    class Point < CStruct
      int32:x
      int32:y
    end
Example:

    require 'cstruct'
    
    # struct Point in Ruby:
    class Point < CStruct
     int32:x
     int32:y
    end

    # create a Point's instance
    point = Point.new

    # assign like as C language
    point.x = 10
    point.y = 20
    puts "point.x = #{point.x},point.y = #{point.y}"

###Using Win32Struct
like this: 

    typedef struct _OSVERSIONINFOEXA {
       DWORD dwOSVersionInfoSize;
       DWORD dwMajorVersion;
       DWORD dwMinorVersion;
       DWORD dwBuildNumber;
       DWORD dwPlatformId;
       CHAR szCSDVersion[ 128 ];
       WORD wServicePackMajor;
       WORD wReserved[2];
    } OSVERSIONINFOEXA;
in Ruby:

    class OSVERSIONINFOEXA < Win32Struct
       DWORD :dwOSVersionInfoSize
       DWORD :dwMajorVersion
       DWORD :dwMinorVersion
       DWORD :dwBuildNumber
       DWORD :dwPlatformId
       CHAR :szCSDVersion,[ 128 ]
       WORD :wServicePackMajor
       WORD :wServicePackMinor
       WORD :wReserved,[2]
    end
##Lean More
Please see also [Documents][2] and [Examples][3]. 



[1]:http://cstruct.rubyforge.org/
[2]:http://cstruct.rubyforge.org/documents.html
[3]:http://cstruct.rubyforge.org/examples.html