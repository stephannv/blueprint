module Blueprint::HTML::Renderer
  private def render(renderable : Blueprint::HTML) : Nil
    renderable.to_s(@buffer)
  end

  private def render(renderable : Blueprint::HTML.class) : Nil
    renderable.new.to_s(@buffer)
  end

  private def render(renderable : Blueprint::HTML, &) : Nil
    renderable.to_s(@buffer) do
      yield renderable
    end
  end

  private def render(renderable : Blueprint::HTML.class, &) : Nil
    renderable.new.to_s(@buffer) do
      yield renderable
    end
  end

  private def render(renderable) : Nil
    __append_to_buffer__(renderable)
  end
end
