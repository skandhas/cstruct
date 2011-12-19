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
#
# struct Line in C\C++ (32-bit platform): 
#
# struct Line
# {
#    Point begin_point;
#    Point end_point;
# }; 

# struct TwoLine in C\C++ (32-bit platform): 
#
# struct TwoLine
# {
#    Line lines[2];
# }; 



# struct Point , Line and TwoLine in Ruby: 
class Point < CStruct
  int32:x
  int32:y 
end

class Line < CStruct
  Point:begin_point
  Point:end_point 
end

class TwoLine < CStruct
  Line:lines,[2]
end


line = Line.new

# assign like as C language
line.begin_point.x = 0
line.begin_point.y = 0
line.end_point.x = 20   
line.end_point.y = 30


puts "sizeof(Line) = #{Line.__size__}" # "__size__" is alias of "size"
puts "line.begin_point.x = #{line.begin_point.x}"
puts "line.begin_point.y = #{line.begin_point.y}"
puts "line.end_point.x = #{line.end_point.x}"  
puts "line.end_point.y = #{line.end_point.y}"

two_line = TwoLine.new

# assign like as C language
two_line.lines[0].begin_point.x = 6
two_line.lines[0].begin_point.y = 16
two_line.lines[0].end_point.x = 26   
two_line.lines[0].end_point.y = 36

two_line.lines[1].begin_point.x = 6
two_line.lines[1].begin_point.y = 16
two_line.lines[1].end_point.x = 26   
two_line.lines[1].end_point.y = 36





