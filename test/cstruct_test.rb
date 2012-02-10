require 'test/unit'
require 'cstruct'


class CStructTest < Test::Unit::TestCase
	
	test 'struct member' do 
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

		assert_equal 30,line.end_point.y
  end
end
