
class CStruct
  module Utils #:nodoc: all
    UnpackFormat =
    {
      :little => { 1=>'C',2=>'v',4=>'V',8=>'Q',:float=>'e',:double=>'E'},
      :big    => { 1=>'C',2=>'n',4=>'N',8=>'Q',:float=>'g',:double=>'G'}, #8=>'Q'? 'Q' is native endian
    }
    SigedMaxValue    = {  1 => 0x7F, 2 => 0x7FFF, 4 => 0x7FFFFFFF, 8 => 0x7FFFFFFFFFFFFFFF }
    UnsigedMaxValue  = {  1 => 0xFF, 2 => 0xFFFF, 4 => 0xFFFFFFFF, 8 => 0xFFFFFFFFFFFFFFFF }
    
    # buffer is a String's object
    def self.unpack buffer,struct_endian,fsize,fsign
      value =nil
      if fsign==:float or fsign ==:double
        format = UnpackFormat[struct_endian][fsign]
        value  = buffer.unpack(format)[0]
      else  
      format = UnpackFormat[struct_endian][fsize]
      value  = buffer.unpack(format)[0]
      if  fsign == :signed
        value = unsigned_to_signed  value,fsize
      end  
      end      
      value
    end
    
    # buffer is a Array's object
    def self.pack(buffer,struct_endian,fsize,fsign)
      if fsign==:float or fsign ==:double
        format = UnpackFormat[struct_endian][fsign]
      else
      format = UnpackFormat[struct_endian][fsize]
      end 
      buffer.pack format
    end
    
    # dosen't use monkey patch~
    
    def self.string_setbyte(string,index,value)
      RUBY_VERSION < "1.9" ? (string[index] = value):(string.setbyte index,value)       
    end

    def self.string_getbyte(string,index)
      RUBY_VERSION < "1.9" ? (string[index]):(string.getbyte index)
    end
    
    def self.unsigned_to_signed value,value_size
      if value>SigedMaxValue[value_size] 
        ret = value - UnsigedMaxValue[value_size]-1
      else
        ret = value
      end
      
    end
    def self.buffer_setbytes(target,source,targetindex)
        source.enum_for(:each_byte).each_with_index do |byte,index|
        string_setbyte(target,targetindex + index,byte)
      end
    end
  end
end 