module Must
  class Differ
    attr_reader :a, :b, :path

    def initialize(a, b, path)
      @a, @b, @path = a, b, path
    end

    def same_float?(a, b)
      al = a.to_s.sub(/\.(\d{1,})$/, '\1').length
      bl = b.to_s.sub(/\.(\d{1,})$/, '\1').length
      if al > 8 and bl > 8
        len = 6 # [al, bl].min - 2
        a.to_s == b.to_s or
          a.round(len).to_s == b.round(len).to_s
      else
        a.to_s == b.to_s or
          (a - b).abs <= Float::EPSILON * [a.abs, b.abs].max
      end
    end

    def same_object?(a, b)
      a == b
    end

    def execute!
      unless a.class == b.class
        failed("%s expected [%s], but got [%s]" % [path, a.class, b.class])
      end

      if a.is_a?(Array)
        max = [a.size, b.size].max
        (0...max).each do |i|
          Differ.new(a[i], b[i], "#{path}[#{i}]").execute
        end
        return true
      end

      if a.is_a?(Hash)
        (a.keys | b.keys).each do |key|
          Differ.new(a[key], b[key], "#{path}[#{key}]").execute
        end
        return true
      end

      same = 
        case a
        when Float; same_float?(a, b)
        else      ; same_object?(a, b)
        end

      unless same
        av = a.inspect.split(//)[0..50].join
        bv = b.inspect.split(//)[0..50].join
        failed("%s expected %s[%s], but got %s[%s]" % [path, av, a.class, bv, a.class])
      end
    end

    def execute
      execute!
      return nil
    rescue => err
      return err
    end

    private
      def failed(msg)
        raise msg
      end
  end
end
