module Blueprint::HTML::ElementRenderer
  private def element(tag_name : String | Symbol, **attributes, &) : Nil
    @buffer << "<"
    @buffer << tag_name
    AttributesRenderer.render(@buffer, attributes)
    @buffer << ">"
    __capture_content__ { yield }
    @buffer << "</"
    @buffer << tag_name
    @buffer << ">"
  end

  private def void_element(tag_name : String | Symbol, **attributes) : Nil
    @buffer << "<"
    @buffer << tag_name
    AttributesRenderer.render(@buffer, attributes)
    @buffer << ">"
  end
end
