

class CStruct
  class Field #:nodoc: all
    attr_accessor:tag
    attr_accessor:size
    attr_accessor:offset
    attr_accessor:sign
    attr_accessor:dimension

    def initialize(tag,size,offset,sign,dimension = nil,*arg)
      @tag    = tag
      @size   = size 
      @offset = offset
      @sign   = sign
      @dimension = dimension
    end
    
    def byte_size
      if @dimension
        @size * dimension.inject(1){|m,i| m*=i}
      else
        @size
      end  
    end
    
    def is_float?
      @sign == :float
    end
    
    def is_double?
      @sign == :double
    end
    
    def is_struct?
      @sign == :struct
    end
    
    def is_union?
      @sign == :union
    end

  end
end
