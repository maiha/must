require "must/version"

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

require "must/rule"
Object.__send__ :include, Must
