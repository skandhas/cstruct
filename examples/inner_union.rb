# CStruct Examples
require 'cstruct'

# example:
# struct U in C\C++ (32-bit platform): 
# 
#struct U
#{
#    union NumericType
#    {
#        int   x;
#        int   y;  
#    };
#    NumericType value;
#};

# Named union is unsupported in CStruct. Fortunately, anonymous union can take the place of it.
# struct U in Ruby: 
class U < CStruct
    union:value do
        int32:x
        int32:y
    end
end

#  See also: 'anonymous_union.rb' 