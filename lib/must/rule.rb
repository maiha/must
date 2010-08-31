require 'set'

module Must
  class Rule
    attr_reader :object

    def initialize(object)
      @object    = object
      @not       = false
    end

    def a()  self end
    def an() self end

    def not
      @not = ! @not
      return self
    end

    def be(*args, &block)
      if args.empty?
        self
      else
        valid?(object == args.shift, &block)
      end
    end

    def empty(&block)
      valid?(object.empty?, &block)
    end

    def blank(&block)
      valid?(object.blank?, &block)
    end

    def exist(&block)
      self.not()
      be(nil, &block)
    end

    def kind_of(*targets)
      valid?(targets.any?{|klass| object.is_a? klass}) {
        target = targets.map{|i| i.name}.join('/')
        raise Invalid, "expected #{target} but got #{object.class}"
      }
    end

    def one_of(target, &block)
      valid?(target === @object, &block)
    end

    def valid?(condition, &block)
      if condition ^ @not
        object
      else
        block_or_throw(&block)
      end
    end

    def block_or_throw(&block)
      if block
        block.call
      else
        raise Invalid
      end
    end

    def coerced(*types, &block)
      coecings        ||= types.last.is_a?(Hash) ? types.pop : {}
      already_coerced ||= Set.new
      kind_of(*types)
    rescue Invalid
      block_or_throw(&block) if already_coerced.include?(@object.class)
      already_coerced << @object.class
      @object =
        case (obj = coecings[@object.class])
        when Symbol ; @object.send obj
        when Proc   ; obj.call(@object)
        else        ; obj
        end
      retry
    end

    alias :match :one_of
  end
end
