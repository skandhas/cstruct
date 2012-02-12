# CStruct Examples
require 'cstruct'

# example:
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
p D.__size__
p v.b.a.handle
