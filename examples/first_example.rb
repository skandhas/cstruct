# CStruct Examples
require 'cstruct'

# example:
# struct Point in C\C++ (32-bit platform): 
#
# struct Point
# {
#    int x;
#    int y;
# }; 

# struct Point in Ruby: 
class Point < CStruct
  int32:x
  int32:y 
end

# create a Point's instance
point   = Point.new

# assign like as C language
point.x = 10
point.y = 20

puts "point.x = #{point.x},point.y = #{point.y}"



# struct PointF in C\C++  (32-bit platform): 
#
# struct PointF
# {
#    double x;
#    double y;
# }; 

# struct PointF in Ruby: 
class PointF < CStruct
  double:x
  double:y 
end

# create a PointF's instance
# use 'block' to initialize the fields
point2   = PointF.new do |st|
  st.x = 10.56
  st.y = 20.78
end

puts "sizeof(PointF) = #{PointF.size}"
puts "point2.x = #{point2.x},point2.y = #{point2.y}"

