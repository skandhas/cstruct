

class CStruct
  class Field
    attr_accessor:size
    attr_accessor:offset
    attr_accessor:sign
    attr_accessor:dimension

    def initialize(size,offset,sign)
      @size   = size 
      @offset = offset
      @sign   = sign
    end
    
    def type
      case @sign
      when is_float?  then :float
      when is_double? then :double  
      when is_struct? then :struct
      when is_union?  then :union
      else
        @sign 
      end
    end

    def is_float?
      @sign == :float
    end
    
    def is_double?
      @sign == :double
    end
    
    def is_struct?
    
    end
    
    def is_union
    
    end

  end
end
