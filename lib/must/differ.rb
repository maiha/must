module Must
  class Differ
    attr_reader :a, :b, :path

    def initialize(a, b, path)
      @a, @b, @path = a, b, path
    end

    def eq_float?(a, b)
      (a - b).abs <= 0.0000001
    end

    def eq_object?(a, b)
      a == b
    end

    def execute!
      unless a.class == b.class
        failed ClassMismatch, "%s expected [%s], but got [%s]" % [path, a.class, b.class]
      end

      if a.is_a?(Array)
        max = [a.size, b.size].max
        max.times do |i|
          Differ.new(a[i], b[i], "#{path}[#{i}]").execute!
        end
        return true
      end

      if a.is_a?(Hash)
        (a.keys | b.keys).each do |key|
          Differ.new(a[key], b[key], "#{path}[#{key}]").execute!
        end
        return true
      end

      eq = 
        case a
        when Float; eq_float?(a, b)
        else      ; eq_object?(a, b)
        end

      unless eq
        av = a.inspect.split(//)[0..50].join
        bv = b.inspect.split(//)[0..50].join
        failed ValueMismatch, "%s expected %s(%s), but got %s(%s)" % [path, av, a.class, bv, a.class]
      end

      return true

    rescue Must::ClassMismatch => err
      if a.class == b.class
        as = Must::StructInfo.new(a).inspect
        bs = Must::StructInfo.new(b).inspect
        raise Must::StructMismatch, "%s expected %s, but got %s" % [path, as, bs]
      else
        raise
      end
    end

    def execute
      execute!
      return true
    rescue Must::Invalid
      return false
    end

    def failed(klass, msg)
      raise klass, msg
    end
  end
end
