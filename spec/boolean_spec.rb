require 'spec_helper'

describe Must, "boolean" do
  def ok(&block)
    block.should_not raise_error
  end

  def ng(error = Must::Invalid, &block)
    block.should raise_error(error)
  end

  specify do
    ok { true.must(Boolean) }
    ok { false.must(Boolean) }

    ng { nil.must(Boolean) }
    ng { 1.must(Boolean) }
    ng { "".must(Boolean) }
    ng { [true].must(Boolean) }
  end
end
