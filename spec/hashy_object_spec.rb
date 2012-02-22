require 'spec_helper'

describe HashyObject do
  describe "initialize" do
    it "raises a TooMuchRecursionException when initializing with too high a recursion_level" do
      expect {
        HashyObject.new("my string", HashyObject::MAX_RECURSION_LEVELS + 1)
      }.to raise_error(::HashyObject::TooMuchRecursionException)
    end
  end

  context "with a string" do
    specify {
      HashyObject.new("my string").inspect.should == "my string"
    }
  end

  context "with a hash" do
    specify {
      HashyObject.new({}).inspect.should == "{}"
    }

    specify {
      HashyObject.new({:a => 1, :b => 2}).inspect.should == "{:a=>1, :b=>2}"
    }

    specify {
      HashyObject.new({:a => {:a => "string me", 'b' => 'i gots me a string key'}, 'other key' => 5}).inspect.should ==
        '{:a=>{:a=>"string me", "b"=>"i gots me a string key"}, "other key"=>5}'
    }
  end

  context "with a dumb class" do
    specify {
      HashyObject.new(NoDecoration.new).inspect.should == "{:@a=>1}"
    }
  end

  context "with a deeply embedded dumb class" do
    specify {
      HashyObject.new(NoDecorationContainer.new).inspect.should == "{:@b=>{:@a=>1}}"
    }
  end

  context "with an array of dumb classes" do
    specify {
      HashyObject.new([NoDecoration.new]).inspect.should == "[{:@a=>1}]"
    }
  end

  context "with a hash of dumb classes" do
    specify {
      HashyObject.new({:a => NoDecoration.new}).inspect.should == "{:a=>{:@a=>1}}"
    }
  end

  context "with a properly decorated class"

  describe "#inspectable" do
    specify {
      HashyObject.new("face").should be_inspectable
    }
    specify {
      HashyObject.new({:a=>1}).should be_inspectable
    }
    specify {
      HashyObject.new(%W(a b c d e f g)).should be_inspectable
    }
    specify {
      HashyObject.new(NoDecoration.new).should_not be_inspectable
    }
    specify {
      HashyObject.new(WithDecoration.new).should be_inspectable
    }

    specify {
      HashyObject.new([NoDecoration.new]).should_not be_inspectable
    }
  end
end

class NoDecoration
  def initialize
    @a = 1
  end
end

class WithDecoration < NoDecoration
  def inspect
    {:a => @a}.inspect
  end
end

class NoDecorationContainer
  def initialize
    @b = NoDecoration.new
  end
end