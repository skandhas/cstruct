# CStruct Examples
require 'cstruct'

# example:
# struct Window in C\C++ (32-bit platform): 
# 
# struct Window
# {
#    int style;
#    struct{
#       int x;
#       int y;
#    }position; /* position is anonymous struct's instance */
# }; 


# struct Window in Ruby: 
class Window < CStruct
    int32:style
    struct :position do
        int32:x
        int32:y	
    end
end
# or like this (use brace):
# class Window < CStruct
#    int32:style
#    struct (:position) {
#        int32:x
#        int32:y	
#    }
# end

# create a Window's instance
window = Window.new

# assign like as C language
window.style = 1
window.position.x = 10
window.position.y = 10

puts "sizeof(Window) = #{Window.__size__}" # "__size__" is alias of "size"
puts "window.style = #{window.style},window.position.x = #{window.position.x},window.position.y = #{window.position.y}"
