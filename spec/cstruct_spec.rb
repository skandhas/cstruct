require 'rspec'
require 'cstruct'

puts "Test CStruct-#{CStruct::VERSION}"

describe 'Normal Member -> Point' do
  subject do

    class Point < CStruct
      int32:x
      int32:y
    end

    point = Point.new
    point.x,point.y = -10,20
    point
  end

  describe '#x' do
    subject { super().x }
    it { is_expected.to eq(-10) }
  end

  describe '#y' do
    subject { super().y }
    it { is_expected.to eq(20) }
  end
end

describe 'Struct Member -> Line' do
  subject do
    class Point < CStruct
      int32:x
      int32:y
    end

    class Line < CStruct
      Point:begin_point
      Point:end_point
    end

    line = Line.new
    line.begin_point.x = 10
    line.begin_point.y = 20
    line
  end

  describe '#begin_point' do
    subject { super().begin_point }
    describe '#x' do
      subject { super().x }
      it { is_expected.to eq(10) }
    end
  end

  describe '#begin_point' do
    subject { super().begin_point }
    describe '#y' do
      subject { super().y }
      it { is_expected.to eq(20) }
    end
  end
end

describe 'Array Member -> Collection' do
  subject do

    class Collection < CStruct
      int32:elements,[8]
    end

    collection = Collection.new

    (0..7).each do |i|
      collection.elements[i] = i  # assign like as C language
    end

    collection
  end

  describe '#elements' do
    subject { super().elements }
    it { is_expected.to eq((0..7).to_a) }
  end
end

describe 'Array Struct Member -> PointArray' do
  it 'PointArray' do
    class Point < CStruct
      double:x
      double:y
    end

    class PointArray < CStruct
      Point:elements,[4]
    end

    array = PointArray.new
    (0..3).each do |i|
      array.elements[i].x = i+0.234
      array.elements[i].y = i+1.667
    end

    (0..3).each do |i|
      expect(array.elements[i].x).to eq(i+0.234)
      expect(array.elements[i].y).to eq(i+1.667)
    end
  end

end


describe 'Inner Struct Member-> T' do
  subject do
    class T < CStruct
      class Inner < CStruct
        int32 :v1
        int32 :v2
      end
      Inner :inner
    end

    t = T.new
    t.inner.v1 = 10
    t.inner.v2 = 20
    t
  end

  describe '#inner' do
    subject { super().inner }
    describe '#v1' do
      subject { super().v1 }
      it { is_expected.to eq(10) }
    end
  end

  describe '#inner' do
    subject { super().inner }
    describe '#v2' do
      subject { super().v2 }
      it { is_expected.to eq(20) }
    end
  end
end

describe 'Anonymous Struct Member -> Window' do
  subject do
    class Window < CStruct
      int32:style
      struct :position do
        int32:x
        int32:y
      end
    end
    window = Window.new
    window.style = 1
    window.position.x = 10
    window.position.y = 20
    window
  end

  describe '#style' do
    subject { super().style }
    it { is_expected.to eq(1)}
  end

  describe '#position' do
    subject { super().position }
    describe '#x' do
      subject { super().x }
      it { is_expected.to eq(10)}
    end
  end

  describe '#position' do
    subject { super().position }
    describe '#y' do
      subject { super().y }
      it { is_expected.to eq(20)}
    end
  end
end

describe 'Anonymous Union Member -> U' do
  subject do
    class U < CStruct
        union:value do
        int32:x
        int32:y
      end
    end

    u = U.new
    u.value.x = 10
    u
  end

  describe '#value' do
    subject { super().value }
    describe '#x' do
      subject { super().x }
      it { is_expected.to eq(10)}
    end
  end
end

describe 'Char Buffer Member -> Addition' do
  subject do
    class Addition < CStruct
      char :description,[32]
    end

    addition = Addition.new
    addition.description = 'Hello Ruby!'
    addition
  end

  describe '#description' do
    subject { super().description }
    describe '#to_cstr' do
      subject { super().to_cstr }
      it {is_expected.to eq('Hello Ruby!')}
    end
  end
end

=begin
describe 'Binary File IO ' do
  subject do

    class Point < CStruct
      int32:x
      int32:y
    end

    class PointF < CStruct
      double:x
      double:y
    end

    class Addition < CStruct
      char :description,[32]
    end

    class IOData < CStruct
      Point:point
      PointF:pointf
      Addition:addition
    end

    write_data = IOData.new
    # write file
    File.open("point.bin","wb")do |f|
        write_data.point   = Point.new {|st| st.x = 100; st.y =200 }
        write_data.point_f = PointF.new{|st| st.x = 20.65; st.y =70.86 }

        write_data.addition = Addition.new
        write_data.addition.description= "Hello Ruby!"

        f.write write_data.data
    end

    read_data = IOData.new

    #read file
    File.open("point.bin","rb")do |f|
      read_data   << f.read(IODtata.size)

      puts point.x
      puts point.y
      puts point_f.x
      puts point_f.y
      puts addition.description.to_cstr
    end
    read_data
  end

  its(:'point.x') {should == 200}
end
=end
describe 'Namespace ' do
 it 'NS1 NS2' do
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
    expect(v.b.a.handle).to eq(120)

  end
end

