require 'enumerator'

class CStruct
  module Utils #:nodoc: all
    UnpackFormat =
    {
      :little => { 1=>'C',2=>'v',4=>'V',8=>'Q',:float=>'e',:double=>'E'},
      :big    => { 1=>'C',2=>'n',4=>'N',8=>'Q',:float=>'g',:double=>'G'}, #8=>'Q'? 'Q' is native endian
    }
    SigedMaxValue    = {  1 => 0x7F, 2 => 0x7FFF, 4 => 0x7FFFFFFF, 8 => 0x7FFFFFFFFFFFFFFF }
    UnsigedMaxValue  = {  1 => 0xFF, 2 => 0xFFFF, 4 => 0xFFFFFFFF, 8 => 0xFFFFFFFFFFFFFFFF }
    
    class << self
      # buffer is a String's object
      def unpack(buffer,struct_endian,fsize,fsign)
        format_index = (fsign==:float or fsign ==:double) ? (fsign):(fsize)
        format = UnpackFormat[struct_endian][format_index]
        value  = buffer.unpack(format).first
       
        if  fsign == :signed
          value = unsigned_to_signed value,fsize
        end  
        value
      end
      
      # buffer is a Array's object
      def pack(buffer,struct_endian,fsize,fsign)
        format_index = (fsign==:float or fsign ==:double) ? (fsign):(fsize)
        format = UnpackFormat[struct_endian][format_index] 
        buffer.pack format
      end

      def string_setbyte(string,index,value)
        RUBY_VERSION < "1.9" ? (string[index] = value):(string.setbyte index,value)       
      end

      def string_getbyte(string,index)
        RUBY_VERSION < "1.9" ? (string[index]):(string.getbyte index)
      end
      
      def unsigned_to_signed(value,value_size)
        value > SigedMaxValue[value_size] ? (value - UnsigedMaxValue[value_size]-1):(value)  
      end

      def buffer_setbytes(target,source,target_index)
          source.enum_for(:each_byte).each_with_index do |byte,index|
          string_setbyte(target,target_index + index,byte)
        end
      end

    end
  end
end 