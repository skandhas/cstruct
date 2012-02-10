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