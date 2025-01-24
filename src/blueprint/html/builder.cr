struct Blueprint::HTML::Builder
  include Blueprint::HTML

  def self.build(&) : String
    new.build { |builder| yield builder }
  end

  def build(&) : String
    to_s { yield self }
  end

  private def blueprint(&) : Nil
    yield
  end
end
