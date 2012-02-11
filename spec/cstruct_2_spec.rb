require 'rspec'
require_relative '../lib/cstruct'


describe 'Normal Member -> Point' do
  subject do

    class Point < CStruct
      int32:x
      int32:y 
    end

    point = Point.new
    point.x,point.y = -10,20
    point      
  end  
    
  its(:x) { should == -10 }
  its(:y) { should == 20 }
end


describe 'Struct Member -> Line' do
  subject do
    class Point < CStruct
      int32:x
      int32:y 
    end

    class Line < CStruct
      Point:begin_point
      Point:end_point 
    end

    line = Line.new
    line.begin_point.x = 10 
    line.begin_point.y = 20
    line      
  end 
     
  its(:'begin_point.x') { should == 10 }
  its(:'begin_point.y') { should == 20 }
end


describe 'Array Member -> Collection' do
  subject do
    
    class Collection < CStruct
      int32:elements,[8]
    end

    collection = Collection.new    
    
    (0..7).each do |i|
      collection.elements[i] = i  # assign like as C language
    end

    collection     
  end 

  its(:elements) { should == (0..7).to_a }
end

describe 'Array Struct Member -> PointArray' do
  it 'PointArray' do  
    class Point < CStruct
      double:x
      double:y 
    end

    class PointArray < CStruct
      Point:elements,[4]
    end

    array = PointArray.new 
    (0..3).each do |i| 
      array.elements[i].x = i+0.234
      array.elements[i].y = i+1.667
    end

    (0..3).each do |i| 
      array.elements[i].x.should == i+0.234
      array.elements[i].y.should == i+1.667
    end
  end   
  
end


describe 'Inner Struct Member-> T' do
  subject do
    class T < CStruct
      class Inner < CStruct
        int32 :v1
        int32 :v2
      end
      Inner :inner
    end

    t = T.new    
    t.inner.v1 = 10
    t.inner.v2 = 20
    t 
  end 

  its(:'inner.v1') { should == 10 }
  its(:'inner.v2') { should == 20 }
end

describe 'Anonymous Struct Member -> Window' do  
  subject do
    class Window < CStruct
      int32:style
      struct :position do
        int32:x
        int32:y 
      end
    end
    window = Window.new
    window.style = 1
    window.position.x = 10
    window.position.y = 20
    window
  end
  
  its(:style)       { should == 1}  
  its(:'position.x'){ should == 10} 
  its(:'position.y'){ should == 20} 
end

describe 'Anonymous Union Member -> U' do  
  subject do
    class U < CStruct
        union:value do
        int32:x
        int32:y
      end
    end

    u = U.new
    u.value.x = 10
    u
  end  
  its(:'value.x'){ should == 10}
end

describe 'Char Buffer Member -> Addition' do
  subject do
    class Addition < CStruct
      char :description,[32]
    end

    addition = Addition.new
    addition.description = 'Hello Ruby!'
    addition
  end
  
  its(:'description.to_cstr') {should == 'Hello Ruby!'}
end

=begin
describe 'Binary File IO ' do
  subject do
 
    class Point < CStruct
      int32:x
      int32:y 
    end

    class PointF < CStruct
      double:x
      double:y 
    end

    class Addition < CStruct
      char :description,[32]
    end
    
    class IOData < CStruct
      Point:point
      PointF:pointf
      Addition:addition
    end

    write_data = IOData.new
    # write file
    File.open("point.bin","wb")do |f|
        write_data.point   = Point.new {|st| st.x = 100; st.y =200 }
        write_data.point_f = PointF.new{|st| st.x = 20.65; st.y =70.86 }
      
        write_data.addition = Addition.new 
        write_data.addition.description= "Hello Ruby!"

        f.write write_data.data
    end

    read_data = IOData.new

    #read file
    File.open("point.bin","rb")do |f|      
      read_data   << f.read(IODtata.size)    
        
      puts point.x
      puts point.y
      puts point_f.x
      puts point_f.y
      puts addition.description.to_cstr
    end
    read_data
  end
  
  its(:'point.x') {should == 200}
end
=end
describe 'Namespace ' do
 it 'NS1 NS2' do
    module NS1    #namespace
        class A < CStruct
            uint32:handle
        end
      
        module NS2
            class B < CStruct
                A:a # directly use A
            end 
        end

        class C < CStruct
          A     :a
          NS2_B :b  # Meaning of the 'NS2_B' is NS2::B
        end 
    end

    class D < CStruct
        NS1_NS2_B:b # Meaning of the 'NS1_NS2_B' is NS1::NS2::B
    end 

    v = D.new
    v.b.a.handle = 120
    v.b.a.handle.should == 120
    
  end
end

