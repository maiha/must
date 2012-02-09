require 'set'
require "must/struct_info"

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

    def kind_of(*targets, &block)
      bool = targets.any?{|klass| is_a?(klass)}
      block ||= proc {
        target = targets.map{|i| instance?(i) ? i.class.name : i.name}.join('/')
        raise Invalid, "expected #{target} but got #{object.class}"
      }
      valid?(bool, &block)
    end

    def one_of(target, &block)
      valid?(target === @object, &block)
    end
    alias :match :one_of

    def valid?(condition, &block)
      if condition ^ @not
        object
      else
        block_or_throw(&block)
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

    def duck(method_name, &block)
      valid?(duck?(method_name), &block)
    end

    def duck?(method_name)
      case method_name.to_s
      when /^\./ then method_defined?($')
      when /^#/  then instance_method_defined?($')
      else       ;    method_defined?(method_name)
      end
    end

    def struct?(target)
      Must::StructInfo.new(@object).same?(target)
    end

    def struct(target, &block)
      valid?(struct?(target), &block)
    end

    private
      def instance?(obj)
        obj.class.to_s !~ /\A(Class|Module)\Z/o
      end

      def instance_method_defined?(method_name)
        return false if instance?(@object)
        !! @object.instance_methods.find { |m| m.to_s == method_name.to_s}
      end

      def method_defined?(method_name)
        @object.respond_to?(method_name)
      end

      def is_a?(klass)
        if instance?(klass)
          struct?(klass)
        else
          @object.is_a? klass
        end
      end

      def block_or_throw(&block)
        if block
          block.call
        else
          raise Invalid
        end
      end

  end
end
