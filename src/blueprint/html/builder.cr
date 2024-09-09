module Blueprint::HTML
  @[Experimental]
  def self.build(&) : String
    Builder.build { |builder| with builder yield }
  end

  @[Experimental]
  struct Builder
    include Blueprint::HTML

    def self.build(&) : String
      builder = new
      builder.build { yield builder }
    end

    def build(&) : String
      to_html { with self yield }
    end

    private def blueprint(&) : Nil
      yield
    end
  end
end
