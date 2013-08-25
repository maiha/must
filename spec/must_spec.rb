require 'spec_helper'

describe Must, "must" do
  def ok(&block)
    block.should_not raise_error
  end

  def ng(error = Must::Invalid, &block)
    block.should raise_error(error)
  end

  context "1.must(klass)" do
    specify do
      ok { 1.must(Integer) }
      ok { 1.must(Integer, String) }
      ok { 1.must(Fixnum) }

      ng { 1.must(String)  }
      ng { 1.must(String, Array)  }
    end
  end

  context "klass.must(klass)" do
    specify do
      ok { Fixnum.must(Fixnum) }
      ok { Fixnum.must(Integer) }
      ok { Fixnum.must(Numeric) }
      ok { Fixnum.must(Integer, String) }

      ng { Integer.must(Fixnum) }
      ng { Integer.must(String)  }
      ng { Integer.must(String, Array)  }
    end
  end

  context "true.must(bool)" do
    specify do
      ok { true.must(true) }
      ok { true.must(true,false) }
      ng { true.must(false) }
      ng { "xx".must(true,false) }

      ok { false.must(false) }
      ok { false.must(true,false) }
      ng { false.must(true) }
      ng { "xxx".must(true,false) }
    end
  end
end
