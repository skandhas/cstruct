require 'rspec'
require_relative 'predefined_struct'

#--------------------------
# in C:
# struct Point
# {
#    int x;
#    int y;
# }; 
#--------------------------
# in Ruby:
# class Point < CStruct
#   int32:x
#   int32:y 
# end
#--------------------------
describe 'Normal Member -> Point' do
  subject do
    point = PredefinedStruct::Point.new
    point.x,point.y = 10,20
    point      
  end  
    
  its(:x) { should == 10 }
  its(:y) { should == 20 }
end

#--------------------------
# in C:
# struct Point
# {
#    int x;
#    int y;
# }; 
#--------------------------
# in Ruby:
#  class Line < CStruct
#    Point:begin_point
#    Point:end_point 
#  end
#--------------------------
describe 'Struct Member -> Line' do
  subject do
    line = PredefinedStruct::Line.new
    line.begin_point.x = 10 
    line.begin_point.y = 20
    line      
  end 
     
  its(:'begin_point.x') { should == 10 }
  its(:'begin_point.y') { should == 20 }
end

#--------------------------
# in C:
# struct Collection
# {
#    int32 elements[8];
# }; 
#--------------------------
# in Ruby:
#  class Collection < CStruct
#    int32:elements,[8]
#  end
#--------------------------
describe 'Array Member -> Collection' do
  subject do
    collection = PredefinedStruct::Collection.new    
    
    (0..7).each do |i|
      collection.elements[i] = i  # assign like as C language
    end

    collection     
  end 

  its(:elements) { should == (0..7).to_a }

end

#--------------------------
# in C:   
# struct T{
#   struct Inner          
#   {
#      int v1; 
#      int v2;
#   };
#   Inner inner;
# };
# -------------------------
# in Ruby:
# class T < CStruct
#   class Inner < CStruct
#     int32 :v1
#     int32 :v2
#   end
#   Inner :inner
# end
# -------------------------
describe 'Inner Struct Member-> T' do
  subject do
    t = PredefinedStruct::T.new    
    t.inner.v1 = 10
    t.inner.v2 = 20
    t 
  end 

  its(:'inner.v1') { should == 10 }
  its(:'inner.v2') { should == 20 }
end


# -------------------------
# in C:
# struct Window
# {
#    int style;
#    struct{
#       int x;
#       int y;
#    }position; /* position is anonymous struct's instance */
# }; 
# -------------------------
# in Ruby:
#  class Window < CStruct
#    int32:style
#    struct :position do
#        int32:x
#        int32:y 
#    end
#  end
# -------------------------
describe 'Anonymous Struct Member -> Window' do  
  subject do
    window = PredefinedStruct::Window.new
    window.style = 1
    window.position.x = 10
    window.position.y = 20
    window
  end
  
  its(:style)       { should == 1}  
  its(:'position.x'){ should == 10} 
  its(:'position.y'){ should == 20} 
end

# -------------------------
# in C:
# struct U
# {
#    union{
#       int x;
#       int y;
#    }value; /* values is anonymous union's instance */
# };
# -------------------------
#  in Ruby:
#  class U < CStruct
#    union:value do
#      int32:x
#      int32:y
#    end
#  end
# -------------------------
describe 'Anonymous Union Member -> U' do  
  subject do
    u = PredefinedStruct::U.new
    u.value.x = 10
    u
  end  
  its(:'value.x'){ should == 10}
end

# -------------------------
# in C:
# struct Addition{
#  char description[32]
# };
# -------------------------
# in Ruby:
# class Addition < CStruct
#   char :description,[32];
# end
# -------------------------
describe 'Char Buffer Member -> Addition' do
  subject do
    addition = PredefinedStruct::Addition.new
    addition.description = 'Hello Ruby!'
    addition
  end
  
  its(:'description.to_cstr') {should == 'Hello Ruby!'}
end
