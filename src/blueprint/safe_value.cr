class Blueprint::SafeValue(T)
  include SafeObject

  getter value : T

  def initialize(@value : T); end

  def to_s(io : String::Builder)
    @value.to_s(io)
  end
end
