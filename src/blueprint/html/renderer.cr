module Blueprint::HTML::Renderer
  def render(other : Blueprint::HTML)
    other.call(@buffer)
  end
end
