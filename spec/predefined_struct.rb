require_relative '../lib/cstruct'
module PredefinedStruct
  # in C:
  # struct Point
  # {
  #    int x;
  #    int y;
  # }; 
  class Point < CStruct
    int32:x
    int32:y 
  end
  
  # in C:
  # struct Line
  # {
  #    Point begin_point;
  #    Point end_point;
  # }; 
  class Line < CStruct
    Point:begin_point
    Point:end_point 
  end
  
  # in C:
  # struct Collection
  # {
  #    int32 elements[8];
  # }; 
  class Collection < CStruct
    int32:elements,[8]
  end

  # in C:   
  # struct T{
  #     struct Inner          
  #     {
  #       int v1; 
  #       int v2;
  #     };
  #     Inner inner;
  # };
  class T < CStruct
    class Inner < CStruct
      int32 :v1
      int32 :v2
    end
    Inner :inner
  end

  # in C:
  # struct U
  # {
  #    union{
  #       int x;
  #       int y;
  #    }value; /* values is anonymous union's instance */
  # }; 
  class U < CStruct
    union:value do
      int32:x
      int32:y
    end
  end
  
  # in C:
  # struct Window
  # {
  #    int style;
  #    struct{
  #       int x;
  #       int y;
  #    }position; /* position is anonymous struct's instance */
  # }; 
  #
  class Window < CStruct
    int32:style
    struct :position do
      int32:x
      int32:y 
    end
  end

  # in C:
  # struct Addition{
  #  char description[32]
  # };
  class Addition < CStruct
    char :description,[32]
  end

end