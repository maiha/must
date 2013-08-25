require "must/version"

# Must
module Must
  class Invalid < StandardError; end
  class ClassMismatch  < Invalid; end
  class StructMismatch < Invalid; end
  class ValueMismatch  < Invalid; end

  def must(*args, &block)
    if args.size > 0
      # Fast type checking for the case "obj.must(klass)"
      args.each{|klass| return self if self.class == klass}

      # Or, check it in a slow but strict way
      Rule.new(self).be.kind_of(*args, &block)
    else
      Rule.new(self)
    end
  end
end

require "must/rule"
require "must/differ"
require "must/struct_info"

Object.__send__ :include, Must
