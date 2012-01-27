module Must
  module SameStruct
    def self.check(src, dst)
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

    def self.classify(obj)
      class?(obj) ? obj : obj.class
    end

    def self.class?(obj)
      obj.class.to_s =~ /\A(Class|Module)\Z/o
    end
  end
end
