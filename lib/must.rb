# Must
module Must
  class Invalid < StandardError; end
  class ShouldNotEmpty  < Invalid; end

  def must
    Rule.new(self)
  end
end

require File.dirname(__FILE__) + '/must/rule'
Object.__send__ :include, Must
