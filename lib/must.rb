# Must
module Must
  class Invalid < StandardError; end
  class ShouldNotEmpty  < Invalid; end

  def must
    Rule.new(self)
  end
end
