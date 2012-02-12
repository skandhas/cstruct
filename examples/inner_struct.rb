# CStruct Examples
require 'cstruct'
# example:
# struct A in C\C++ (32-bit platform): 
# struct A{
#     struct Inner
#     {
#       int v1; 
#       int v2;
#     };
#     Inner inner;
# };

# struct A in Ruby:
class A < CStruct
  class Inner < CStruct
    int32 :v1
    int32 :v2
  end
  Inner :inner
end

a = A.new
a.inner.v1 = 1
a.inner.v2 = 2

puts a.inner.v1 
puts a.inner.v2 
