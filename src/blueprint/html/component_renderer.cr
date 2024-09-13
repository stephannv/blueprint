module Blueprint::HTML::ComponentRenderer
  private def render(blueprint : Blueprint::HTML) : Nil
    blueprint.to_s(@buffer)
  end

  private def render(blueprint : Blueprint::HTML, &) : Nil
    blueprint.to_s(@buffer) do
      yield blueprint
    end
  end
end
