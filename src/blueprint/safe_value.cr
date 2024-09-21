class Blueprint::SafeValue(T)
  include SafeObject

  def initialize(@value : T); end

  delegate to_s, to: @value
end
