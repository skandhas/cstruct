# CStruct Examples
require 'cstruct'

# struct Point in Ruby: 
class Point < CStruct
  int32:x
  int32:y 
end

# struct PointF in Ruby: 
class PointF < CStruct
  double:x
  double:y 
end

class Addition < CStruct
	char :description,[32]
end

# write file
File.open("point.bin","wb")do |f|
    point   = Point.new {|st| st.x = 100; st.y =200 }
    point_f = PointF.new{|st| st.x = 20.65; st.y =70.86 }
	
    addition = Addition.new 
    addition.description= "Hello Ruby!"

    f.write point.data
    f.write point_f.data
    f.write addition.data

end

#read file
File.open("point.bin","rb")do |f|
    point    = Point.new 
    point_f  = PointF.new
    addition = Addition.new
    
    point   << f.read(Point.size)
    point_f << f.read(PointF.size)
    addition <<  f.read(Addition.size)
    
    puts point.x
    puts point.y
    puts point_f.x
    puts point_f.y
    puts addition.description.to_cstr
end