module Blueprint::HTML::ElementRenderer
  private def element(_tag_name : String | Symbol, **attributes, &) : Nil
    @buffer << "<"
    @buffer << _tag_name
    append_attributes(attributes)
    @buffer << ">"
    capture_content { yield }
    @buffer << "</"
    @buffer << _tag_name
    @buffer << ">"
  end

  private def element(_tag_name : String | Symbol, __content__ : String, **attributes) : Nil
    @buffer << "<"
    @buffer << _tag_name
    append_attributes(attributes)
    @buffer << ">"
    ::HTML.escape(__content__, @buffer)
    @buffer << "</"
    @buffer << _tag_name
    @buffer << ">"
  end

  private def void_element(_tag_name : String | Symbol, **attributes) : Nil
    @buffer << "<"
    @buffer << _tag_name
    append_attributes(attributes)
    @buffer << ">"
  end
end
