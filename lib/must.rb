require "must/version"

# Must
module Must
  ######################################################################
  ### Original Type

  Boolean = Class.new

  ######################################################################
  ### Exceptions

  class Invalid < StandardError; end
  class ClassMismatch  < Invalid; end
  class StructMismatch < Invalid; end
  class ValueMismatch  < Invalid; end

  def must(*args, &block)
    if args.size > 0
      # Fast type checking
      args.each{|klass|
        return self if self.class == klass  # 1.must(Fixnum)
        return self if self       == klass  # flag.must(true, false)
        return self if klass == Boolean and (self == true or self == false)
      }

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
