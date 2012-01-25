# Must
module Must
  class Invalid < StandardError; end
  class ShouldNotEmpty  < Invalid; end

  def must(*args)
    if args.size > 0
      Rule.new(self).be.kind_of(*args)
    else
      Rule.new(self)
    end
  end
end

require File.dirname(__FILE__) + '/must/rule'
Object.__send__ :include, Must
