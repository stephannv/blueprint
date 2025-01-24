module Blueprint::HTML::ElementRenderer
  private def element(tag_name : String | Symbol, **attributes, &) : Nil
    @buffer << "<"
    @buffer << tag_name
    AttributesRenderer.render(attributes, to: @buffer)
    @buffer << ">"
    BufferRenderer.render(to: @buffer) { yield }
    @buffer << "</"
    @buffer << tag_name
    @buffer << ">"
  end

  private def void_element(tag_name : String | Symbol, **attributes) : Nil
    @buffer << "<"
    @buffer << tag_name
    AttributesRenderer.render(attributes, to: @buffer)
    @buffer << ">"
  end
end
