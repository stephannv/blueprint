require "../svg/component"

module Blueprint::HTML
  def svg(**attributes, &)
    render Blueprint::SVG::Component.new(**attributes) do |component|
      with component yield
    end
  end

  def svg(**attributes)
    svg(**attributes) { }
  end
end
