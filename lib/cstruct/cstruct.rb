require 'cstruct/field'
require 'cstruct/utils'
#
# ===Description
# CStruct is a simulation of the C language's struct.
# Its main purpose is to manipulate binary-data conveniently in Ruby.
# ===Supported primitive types in CStruct
# * signed types:
#   char,int8,int16,int32,int64,float,double
# * unsigned types:
#   uchar,uint8,uint16,uint32,uint64
# ===More infomantion
# * source: http://github.com/skandhas/cstruct
# * document: http://cstruct.rubyforge.org/documents.html
# * examples: http://cstruct.rubyforge.org/examples.html
class CStruct
  # version  
  VERSION = "1.0.1.pre"
  class << self
    # set the options of a struct.
    def options opts
       @options.merge! opts
    end
    
    # Return the endian of a struct;the default is :little.
    def endian
      @options[:endian] 
    end
  
    # Return the align of a struct;the default is 1.
    def align
      @options[:align]
    end
  
    # Return the fields of a struct.
    def fields
      @fields
    end
    # Return the size of a struct;+size+ similar to +sizeof+ in C language.
    #
    # Example:
    #
    #   class Point < CStruct
    #     int32:x
    #     int32:y
    #   end
    #
    #   puts Point.size # or Point.__size__ 
    #     
    def size
      @options[:layout_size]
    end
    
    alias_method :__size__, :size
  end

private   
  def self.init_class_variables  
    @fields = {}
    @options= { :layout_size =>0, :endian => :little, :align  => 1}
  end  
  		
  def self.field(symbol,fsize,fsign,dimension = nil)
    field = Field.new(symbol,fsize,@options[:layout_size],fsign,dimension)
    @options[:layout_size] += field.byte_size
    @fields[symbol] = field     
    dimension.is_a?(Array) ? (do_arrayfield field):(do_field field)
  end
  
  def self.structfield(symbol,sclass,ssize,dimension = nil)
    field = Field.new(symbol,ssize,@options[:layout_size],:struct,dimension)
    @options[:layout_size] += field.byte_size
    @fields[symbol] = field
    dimension.is_a?(Array) ? (do_arraystructfield field,sclass):(do_structfield field,sclass)        
  end  
  
  def self.inherited(clazz)
      clazz.init_class_variables
  end
    
  def self.method_missing(method, *args)
    sclass = method_to_class_by_class self,method
    sclass = method_to_class_by_class Object,method unless sclass
	  sclass = method_to_class_by_namespace method unless sclass
	  sclass = method_to_class method unless sclass
    super unless sclass 
    is_cstruct = sclass.ancestors.select{|x| x == CStruct } 
    if is_cstruct
        symbol,dimension = *args
        structfield symbol,sclass,sclass.size,dimension
    else
      super
    end
  end
  
  def self.method_to_class_by_class(clazz,method)
    method_string_or_symbol = RUBY_VERSION < '1.9' ? (method.to_s):(method)
    unless clazz.constants.include? method_string_or_symbol
      return nil
    end
    clazz.const_get method
  end

  def self.method_to_class_by_namespace(method) #:nodoc: X::Y::A
    sclass = nil
      class_name_array = self.to_s.split('::')
  	return nil if class_name_array.size < 2
    class_array = []
      class_name_array.pop
      class_name_array.inject(self){|m,class_name| class_array << m.const_get(class_name.to_sym);  class_array.last }
      class_array.reverse_each do |clazz|
        if clazz.const_defined?(method)
          sclass = clazz.const_get(method) 
          break
        end  
      end
  	sclass
  end

  def self.method_to_class(method) #:nodoc: X_Y_A
     
  	super_namespace = nil	
  	class_name_array = self.to_s.split('::')
  	
  	if class_name_array.size < 2
  		super_namespace = Object
     else
  		class_name_array.pop
  		super_namespace = class_name_array.inject(Object) {|m,class_name| m.const_get(class_name.to_sym) }
     end

  	namespace_name_array = method.to_s.split('_')
  	return nil if namespace_name_array.size < 2
  	sclass = namespace_name_array.inject(super_namespace) {|m,class_name| m.const_get(class_name.to_sym) }
  end

  def self.do_field(field)
    symbol = field.tag   
    define_method(symbol)       { normal_field_to_value(symbol) }
    define_method("#{symbol}=") { |value| value_to_field(symbol,value) }
  end

  def self.do_arrayfield(field) 
    symbol = field.tag   
    define_method(symbol)       {  array_field_to_value(symbol) }
    define_method("#{symbol}=") { |value| value_to_arrayfield(symbol,value) }
  end

  def self.do_structfield(field,sclass)
    symbol = field.tag 
    define_method(symbol)       { struct_field_to_value(symbol,sclass)}
    define_method("#{symbol}=") { |value| value_to_struct_field(symbol,sclass,value)}
  end

  def self.do_arraystructfield(field,sclass) 
    symbol = field.tag    
    define_method(symbol)       { array_struct_field_to_value(symbol,sclass) }
    define_method("#{symbol}=") { |value| value_to_array_struct_field(symbol,sclass,value) }
  end
  
  def self.unsigned(symbol,fsize,dimension)
    field symbol,fsize,:unsigned,dimension
  end
    
  def self.signed(symbol,fsize,dimension)
    field symbol,fsize,:signed,dimension
  end

  public 
  class << self
    # args =[symbol,dimension=nil]
    [1,2,4,8].each do |i|
      define_method("unsigned_#{i}byte") { |*args| unsigned(args[0],i,args[1]) }
      define_method("signed_#{i}byte")   { |*args| signed(args[0],i,args[1]) }  
    end 
    
    def float(*args) #:nodoc: 
      field args[0],4,:float,args[1]  
    end

    def double(*args) #:nodoc:
      field args[0],8,:double,args[1]
    end
    
    alias uint64  unsigned_8byte
    alias uint32  unsigned_4byte
    alias uint16  unsigned_2byte 
    alias uint8   unsigned_1byte
    alias uchar   unsigned_1byte
    
    alias int64  signed_8byte
    alias int32  signed_4byte
    alias int16  signed_2byte 
    alias int8   signed_1byte
    alias char   signed_1byte  
  end
  
  # call init_class_variables
  init_class_variables
    
public  
  attr_accessor:owner
  
  def initialize  #:nodoc:
    @data  = "\0"*self.class.size
    @data.encode!("BINARY") if RUBY_VERSION >= '1.9'
    @owner = []
    yield self if block_given?
  end
  
  # Return the data buffer of a CStruct's instance.
  def data
    @data
  end
  
  # Fill the date buffer of a CStruct's instance with zero.
  def reset
    (0...self.class.size).each { |i| Utils.string_setbyte @data,i, 0 }
    sync_to_owner
  end

  # Assign to CStruct's instance.	
  def data= bindata
    raise 'Data Type Error!' unless bindata.is_a? String
    self << bindata
  end
  
  # Assign to CStruct's instance.
  def << bindata
    count = @data.size < bindata.size ? @data.size : bindata.size
    (0...count).each do |i|
      Utils.string_setbyte @data,i,Utils.string_getbyte(bindata,i)
    end
  end
    
  def sync_to_owner #:nodoc:
    return if @owner.empty?
    final_offset = @owner.inject(0) do |sum,owner_value| 
      _,foffset,_ = owner_value
      sum+= foffset
    end
    onwerdata,_,_ = @owner.last
    Utils.buffer_setbytes onwerdata,@data,final_offset
  end
  
  alias __data__  data
  alias __reset__ reset
  alias __data__= data=

private  
  def normal_field_to_value(symbol)
    make_normal_field(self.class.fields[symbol],self.class.endian)
  end
  
  def array_field_to_value(symbol)
    make_array_normal_field(self.class.fields[symbol],self.class.endian)
  end

  def struct_field_to_value(symbol,sclass)
    make_struct_field(self.class.fields[symbol],self.class.endian,sclass)
  end

  def array_struct_field_to_value(symbol,sclass)
    make_array_struct_field(self.class.fields[symbol],self.class.endian,sclass)
  end
  
  def value_to_field(symbol,value)
    dataref   = @data
    onwerref  = @owner
    self.class.class_eval do
      field = @fields[symbol]
      bin_string = CStruct::Utils::pack [value],@options[:endian],field.byte_size,field.sign
      CStruct::Utils.buffer_setbytes dataref,bin_string,field.offset
    end   
    sync_to_owner
  end
  
  
  def value_to_arrayfield(symbol,value)  
    field = self.class.fields[symbol]
    array_length = field.byte_size/field.size
  
    if field.size == 1 and value.is_a? String   
      if value.length >= array_length
        puts "WARNING: \"#{value}\".length(#{value.length}) >= #{symbol}.length(#{dimension})!!"
      end  

      value = value[0...array_length-1]
      CStruct::Utils.buffer_setbytes @data,value,field.offset
      sync_to_owner
    else 
      raise "No Implement!(CStruct,version:#{CStruct::VERSION})" 
    end
  end
  
  def value_to_struct_field(symbol,sclass,value)
    raise "No Implement!(CStruct,version:#{CStruct::VERSION})" 
  end
  
  def value_to_array_struct_field(symbol,sclass,value)
    raise "No Implement!(CStruct,version:#{CStruct::VERSION})" 
  end

  def make_normal_field(field,sendian,sclass = nil) 
    Utils::unpack(@data[field.offset,field.size],sendian,field.size,field.sign)
  end
  
  def make_struct_field(field,sendian,sclass)
    value = sclass.new
    value <<  @data[field.offset,field.size]
    value.owner << [@data,field.offset,field.size]
    unless self.owner.empty? 
      value.owner += self.owner
    end
    value
  end
  
  def make_array_normal_field(field,sendian,sclass = nil)
    dataref= @data
    objref = self
    value  = buffer_to_values field,sendian
    
    def value.metaclass  
      class<<self; self; end
    end
    
    value.metaclass.__send__ :define_method,:[]= do |i,v|
      bin_string = Utils::pack [v],sendian,field.size,field.sign
      Utils.buffer_setbytes dataref,bin_string,field.offset + i * field.size
      objref.sync_to_owner
    end

    case field.size
    when 1
      value.metaclass.__send__(:define_method,:to_cstr){ value.pack("C#{value.index(0)}") }
    when 2
      if  RUBY_VERSION > "1.9"
        utf_endian = {:little=>"LE",:big=>"BE"} 
        value.metaclass.__send__ :define_method,:to_wstr do 
          value.pack("S#{value.index(0)}").force_encoding("UTF-16#{utf_endian[sendian]}")
        end   
      end 
    when 4
      value.metaclass.__send__ :define_method,:to_wstr do 
        value.pack("L#{value.index(0)}").force_encoding("UTF-32#{utf_endian[sendian]}")   
      end     
    end  
    value
  end
  
  def make_array_struct_field(field,sendian,sclass)
    buffer_to_structs field,sendian,sclass
  end
  
  def buffer_to_single_value(fsize,foffset,iterator,sendian,fsign)
    CStruct::Utils::unpack(@data[foffset + iterator * fsize,fsize],sendian,fsize,fsign)
  end
  
  def buffer_to_values(field,sendian)
    (0...field.byte_size/field.size).map do |i|
      buffer_to_single_value(field.size,field.offset,i,sendian,field.sign)
    end
  end
  
  def buffer_to_single_struct(sclass,ssize,soffset,iterator,sendian,fsign)
    value =  sclass.new
    value << @data[soffset + iterator * ssize,ssize]

    value.owner << [@data,soffset + iterator * ssize,ssize]

    unless self.owner.empty?
      value.owner += self.owner
    end   
    value
  end
  
  def buffer_to_structs(field,sendian,sclass)
    (0...field.byte_size/field.size).map do |i|
      buffer_to_single_struct(sclass,field.size,field.offset,i,sendian,field.sign)
    end
  end

end 

# Define a anonymous union field.
#
# Example:
# in C:
#   struct U
#   {
#      union{
#        int x;
#        int y;
#      }value; /* values is anonymous union's instance */
# };
#
# use CStruct in Ruby:
#   class U < CStruct
#     union:value do
#       int32:x
#       int32:y
#     end
#   end
#
def CStruct.union symbol,&block
	union_super  = self.ancestors[1]
	union_class = Class.new(union_super) do
	def self.change_to_union #:nodoc:
	    @fields.each_key  { |symbol| @fields[symbol].offset = 0 }

	    max_field_size = @fields.values.inject(0)do |max,field| 
	      dimension = field.dimension
	      dimension_product = 1
        if dimension.is_a? Array
	        dimension_product = dimension.inject(1){|m,d| m *= d }
        end       
	      field_size = field.size* dimension_product
	      max = (field_size> max ? field_size : max)
	    end
	    @options[:layout_size] = max_field_size
	  end
	end	
    union_class.instance_eval(&block) 
    union_class.instance_eval{change_to_union}
    structfield symbol,union_class,union_class.size
end 

# Define a anonymous struct field.
# 
# Example:
#
# in C:
#   struct Window
#   {
#      int style;
#      struct{
#        int x;
#        int y;
#      }position;
#   }; 
# 
# use CStruct in Ruby:
#   class Window < CStruct
#     int32:style
#     struct :position do
#       int32:x
#       int32:y 
#     end
#   end
#
def CStruct.struct symbol,&block
  struct_super  = self.ancestors[1]
  struct_class = Class.new(struct_super) 
  struct_class.instance_eval(&block)
  structfield symbol,struct_class,struct_class.__size__
end
	 
