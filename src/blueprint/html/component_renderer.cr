module Blueprint::HTML::ComponentRenderer
  private def render(blueprint : Blueprint::HTML) : Nil
    blueprint.render_to(@buffer)
  end

  private def render(blueprint : Blueprint::HTML, &) : Nil
    blueprint.render_to(@buffer) do
      yield blueprint
    end
  end
end
