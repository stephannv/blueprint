module Blueprint::HTML::Renderer
  def render(other : Blueprint::HTML)
    other.to_html(@buffer)
  end
end
