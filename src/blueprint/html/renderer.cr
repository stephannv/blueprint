module Blueprint::HTML::Renderer
  def render(other : Blueprint::HTML)
    other.to_html(@buffer)
  end

  def render(other : Blueprint::HTML, &block)
    other.to_html(@buffer) do
      with self yield other
    end
  end
end
