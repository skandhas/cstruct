# CStruct Examples
require 'cstruct'

# example:
# struct T in C\C++ (32-bit platform): 
# 
# struct T
# {
#    int element[8];
# }; 

# struct T in Ruby: 
class T < CStruct
  int32:elements,[8]
end

# create a T's instance
t_array = T.new

(0..7).each do |i|
  t_array.elements[i] = i  # assign like as C language
end

# output
(0..7).each {|i| puts "t_array.elements[#{i}] = #{t_array.elements[i]}" }


# Actually,t_array.elements.class is Array. So..
t_array.elements.each {|element| puts element }