module Blueprint::HTML::Renderer
  def render_to(buffer : String::Builder) : Nil
    return unless render?

    @buffer = buffer

    envelope { blueprint }
  end

  def render_to(buffer : String::Builder, &) : Nil
    return unless render?

    @buffer = buffer

    envelope do
      blueprint { capture_content { yield } }
    end
  end

  private def render? : Bool
    true
  end
end
