#--
# Copyright (c) 2010 skandhas<github.com/skandhas>
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++
require_relative 'cstruct/field'
require_relative 'cstruct/utils'

class CStruct  
  VERSION = '1.0.1'

  class << self
    def options opts
       @options.merge! opts
    end
    
    def endian
      @options[:endian] 
    end
  
    def align
      @options[:align]
    end
  
    def fields
      @fields
    end

    def size
      @options[:layout_size]
    end
  end

private   
  def self.init_class_var  
    @fields = {}
    @options= { :layout_size =>0, :endian => :little, :align  => 1}
  end  
  		
  def self.field(symbol,fsize,fsign,dimension = nil)
    if dimension.is_a? Array
      do_arrayfield  symbol,fsize,fsign,dimension
    else
      do_field Field.new(symbol,fsize,@options[:layout_size],fsign)
      #do_field symbol,fsize,fsign
    end      
  end
  
  def self.structfield(symbol,sclass,ssize,dimension = nil)
    if dimension.is_a? Array
      do_arraystructfield  symbol,sclass,ssize,dimension 
    else
      do_structfield symbol,sclass,ssize
    end      
  end  
  
  def self.inherited(clazz)
      clazz.init_class_var
  end
    
  def self.method_missing(method, *args)
    sclass = method_to_class_by_class self,method
    sclass = method_to_class_by_class Object,method unless sclass
	  sclass = method_to_class_by_namespace method unless sclass
	  sclass = method_to_class method unless sclass
    super unless sclass 
    is_cstruct = sclass.ancestors.select{|x| x == CStruct } 
     if  is_cstruct
        symbol,dimension = *args
        structfield symbol,sclass,sclass.size,dimension
     else
      super
     end
  end
  
  def  self.method_to_class_by_class(clazz,method)
    method_string_or_symbol = RUBY_VERSION < '1.9' ? (method.to_s):(method)
    unless clazz.constants.include? method_string_or_symbol
      return nil
    end
    clazz.const_get method
  end
  
  
  # X::Y::A
  def self.method_to_class_by_namespace(method)
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

  # X_Y_A
  def self.method_to_class(method)
     
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
=begin  
  def self.do_field(symbol,fsize,fsign)
    foffset =  @options[:layout_size]
    @options[:layout_size]   += fsize
    @fields[symbol] = Field.new(symbol,fsize,foffset,fsign)
    
    define_method(symbol)       { normal_field_to_value(symbol) }
    define_method("#{symbol}=") { |value| value_to_field(symbol,value) }
  end
=end
  def self.do_field(field)
    symbol = field.tag
    @options[:layout_size]   += field.size
    @fields[symbol] = field #Field.new(symbol,fsize,foffset,fsign)
    
    define_method(symbol)       { normal_field_to_value(symbol) }
    define_method("#{symbol}=") { |value| value_to_field(symbol,value) }
  end
  
  def self.do_arrayfield(symbol,fsize,fsign,dimension) 
    bytesize = fsize * dimension.inject(1){ |m,i| m*=i }
    foffset  = @options[:layout_size]
    @options[:layout_size] +=  bytesize
    @fields[symbol] = Field.new(symbol,fsize,foffset,fsign,dimension) 
    
    define_method(symbol)       {  array_field_to_value(symbol) }
    define_method("#{symbol}=") { |value| value_to_arrayfield(symbol,value) }
  end
  
  def self.do_structfield(symbol,sclass,ssize)
    foffset =  @options[:layout_size]
    @options[:layout_size]  +=  ssize
    @fields[symbol] = Field.new(symbol,ssize,foffset,:struct)
    
    define_method(symbol)       { struct_field_to_value(symbol,sclass)}
    define_method("#{symbol}=") { |value| value_to_struct_field(symbol,sclass,value)}
  end
  
  def self.do_arraystructfield(symbol,sclass,ssize,dimension) 
    bytesize = ssize * dimension.inject(1){|m,i| m*=i}
    foffset  = @options[:layout_size]
    @options[:layout_size] +=  bytesize
    @fields[symbol] = [ssize,foffset,:ignore,dimension,bytesize]
    
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
    alias_method :__size__, :size
    
    # args =[symbol,dimension=nil]
    [1,2,4,8].each do |i|
      define_method("unsigned_#{i}byte") { |*args| unsigned(args[0],i,args[1]) }
      define_method("signed_#{i}byte")   { |*args| signed(args[0],i,args[1]) }  
    end 
    
    def float(*args)  
      field args[0],4,:float,args[1]  
    end

    def double(*args) 
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
  
  # call init_class_var
  init_class_var
    
public  
  attr_accessor:owner
  
  def initialize
    @data  = "\0"*self.class.size
    @data.encode!("BINARY") if RUBY_VERSION >= '1.9'
    @owner = []
    yield self if block_given?
  end
  
  def data
    @data
  end
  
  def reset
    (0...self.class.size).each do |i|
      CStruct::Utils.string_setbyte @data,i, 0
    end
    sync_to_owner
  end
  	
  def data= bindata
    raise 'Data Type Error!' unless bindata.is_a? String
    self << bindata
  end
  
  def << bindata
    count = @data.size < bindata.size ? @data.size : bindata.size
    (0...count).each do |i|
      CStruct::Utils.string_setbyte @data,i, CStruct::Utils.string_getbyte(bindata,i)
    end
  end
    
  def sync_to_owner
    return if @owner.empty?
    final_offset = @owner.inject(0) do |sum,owner_value| 
      _,foffset,_ = owner_value
      sum+= foffset
    end
    onwerdata,_,_ = @owner.last
    CStruct::Utils.buffer_setbytes onwerdata,@data,final_offset
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
    CStruct::Utils::unpack(@data[field.offset,field.size],sendian,field.size,field.sign)
  end
  
  def make_struct_field(field,sendian,sclass)
    value = sclass.new
    value <<  @data[field.offset,field.size]
    value.owner << [@data,field.offset,field.size]
    if self.owner.size > 0
      value.owner += self.owner
    end
    value
  end
  
  def make_array_normal_field(field,sendian,sclass = nil)
    dataref   = @data
    objref    = self
    value = buffer_to_values field,sendian
    
    def value.metaclass  
      class<<self; self; end
    end
    
    value.metaclass.__send__ :define_method,:[]= do |i,v|
      bin_string = CStruct::Utils::pack [v],sendian,field.size,field.sign
      CStruct::Utils.buffer_setbytes dataref,bin_string,field.offset + i * field.size
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
    value = []
    (0...field.byte_size/field.size).each do |i|
        value <<  buffer_to_single_value(field.size,field.offset,i,sendian,field.sign)
    end
    value
  end
  
  def buffer_to_single_struct(sclass,ssize,soffset,iterator,sendian,fsign)
    value =  sclass.new
    value << @data[soffset + iterator * ssize,ssize]

    value.owner << [@data,soffset + iterator * ssize,ssize]

    if self.owner.size > 0
      value.owner += self.owner
    end   
    value
  end
  
  def buffer_to_structs(field,sendian,sclass)
    value =[]
    (0...field.byte_size/field.size).each do |i|
        value <<  buffer_to_single_struct(sclass,field.size,field.offset,i,sendian,field.sign)
      end
    value
  end
end 

def CStruct.union symbol,&block
	union_super  = self.ancestors[1]
	union_class = Class.new(union_super) do
	def self.change_to_union
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
    do_structfield symbol,union_class,union_class.size
end

def CStruct.struct symbol,&block
  struct_super  = self.ancestors[1]
  struct_class = Class.new(struct_super) 
  struct_class.instance_eval(&block)
  do_structfield symbol,struct_class,struct_class.size
end
	 
