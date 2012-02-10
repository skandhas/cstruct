

class CStruct
  class Field
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
    
    def type
      case @sign
      when is_float?  then :float
      when is_double? then :double  
      when is_struct? then :struct
      when is_union?  then :union
      else
        :error 
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
