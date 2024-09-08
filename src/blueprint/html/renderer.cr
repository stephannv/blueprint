# :nodoc:
module Blueprint::HTML
  private def render(blueprint : Blueprint::HTML) : Nil
    blueprint.render_to(@buffer)
  end

  private def render(blueprint : Blueprint::HTML, &) : Nil
    blueprint.render_to(@buffer) do
      with self yield blueprint
    end
  end

  protected def render_to(buffer : String::Builder) : Nil
    return unless render?

    @buffer = buffer
    blueprint
  end

  protected def render_to(buffer : String::Builder, &) : Nil
    return unless render?

    @buffer = buffer
    blueprint { capture_content { yield } }
  end
end
