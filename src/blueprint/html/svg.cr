require "../svg/component"

module Blueprint::HTML::SVG
  private def svg(**attributes, &) : Nil
    render Blueprint::SVG::Component.new(**attributes) do |component|
      with component yield
    end
  end

  private def svg(**attributes) : Nil
    render Blueprint::SVG::Component.new(**attributes)
  end
end
