# CStruct Examples
require 'cstruct'

# example:
# struct U in C\C++ (32-bit platform): 
# 
# struct U
# {
#    union{
#       int x;
#       int y;
#    }value; /* values is anonymous union's instance */
# }; 

# struct U in Ruby: 
class U < CStruct
  union:value do
    int32:x
    int32:y
  end
end

# or like this (use brace):
# class U < CStruct
#    union (:position) {
#        int32:x
#        int32:y    
#    }
# end


# create a U's instance
u = U.new

# Notice! Assign is different from C language.
# 'value' can not be omitted !
u.value.x = 10

puts "sizeof(U) = #{U.__size__}" # "__size__" is alias of "size" . You may use 'size'.
puts "u.value.x = #{u.value.x }, u.value.y = #{u.value.y }"


