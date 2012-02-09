module Must
  class StructInfo

    module Classify
      def classify(obj)
        class?(obj) ? obj : obj.class
      end

      def class?(obj)
        obj.class.to_s =~ /\A(Class|Module)\Z/o
      end
    end

    module Browser
      include Classify

      def struct(obj)
        case obj
        when Hash
          Hash[*(obj.first || []).map{|i| struct(i)}]
        when Array
          obj.empty? ? [] : [struct(obj.first)]
        else
          classify(obj)
        end
      end

      def types(obj)
        case obj
        when Hash
          ([Hash] + (obj.first || []).map{|i| types(i)}.flatten).uniq
        when Array
          ([Array] + obj.map{|i| types(i)}.flatten).uniq
        else
          [classify(obj)]
        end
      end

      def same?(src, dst)
        case src
        when Hash
          return true if dst == Hash
          dst.must(Hash)
          return true if src.empty?
          return true if dst.empty?
          key1, val1 = src.first
          key2, val2 = dst.first
          key1.must(key2)
          val1.must(val2)

        when Array
          return true if dst == Array
          dst.must(Array)
          return true if src.empty?
          return true if dst.empty?
          src.first.must(dst.first)

        else
          # 1.must.struct(2)
          # 1.must.struct(Integer)
          dst_class = classify(dst)
          return true if classify(src).ancestors.include?(dst_class)

          # Fixnum.must.struct(2)
          return true if class?(src) and src.ancestors.include?(dst_class)

          return false
        end
        return true

      rescue Must::Invalid
        return false
      end

      extend self
    end

    ######################################################################
    ### StructInfo

    def initialize(obj)
      @obj = obj
    end

    def types
      Browser.types(@obj)
    end

    def struct
      Browser.struct(@obj)
    end

    def same?(dst)
      Browser.same?(@obj, dst)
    end

    def inspect
      struct.inspect
    end
  end
end
