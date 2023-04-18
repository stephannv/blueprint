module Blueprint::HTML
  # EXPERIMENTAL
  def self.build(&)
    Builder.build do |builder|
      with builder yield
    end
  end

  private struct Builder
    include Blueprint::HTML

    def self.build(&)
      builder = new
      builder.build do
        yield builder
      end
    end

    private def blueprint(&)
      yield
    end

    protected def build(&)
      to_html { with self yield }
    end
  end
end
