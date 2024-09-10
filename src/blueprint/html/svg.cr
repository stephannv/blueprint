require "../svg/component"

module Blueprint::HTML::SVG
  private def svg(**attributes) : Nil
    svg(**attributes) { }
  end

  private def svg(**attributes, &) : Nil
    render Blueprint::SVG::Component.new(**attributes) do |component|
      with component yield
    end
  end
end
