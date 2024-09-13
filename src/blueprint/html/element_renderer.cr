module Blueprint::HTML::ElementRenderer
  private def element(tag_name : String | Symbol, **attributes, &) : Nil
    @buffer << "<"
    @buffer << tag_name
    append_attributes(attributes)
    @buffer << ">"
    capture_content { yield }
    @buffer << "</"
    @buffer << tag_name
    @buffer << ">"
  end

  private def element(tag_name : String | Symbol, __content__ : String, **attributes) : Nil
    @buffer << "<"
    @buffer << tag_name
    append_attributes(attributes)
    @buffer << ">"
    ::HTML.escape(__content__, @buffer)
    @buffer << "</"
    @buffer << tag_name
    @buffer << ">"
  end

  private def void_element(tag_name : String | Symbol, **attributes) : Nil
    @buffer << "<"
    @buffer << tag_name
    append_attributes(attributes)
    @buffer << ">"
  end
end
