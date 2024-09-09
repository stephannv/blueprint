module Blueprint::HTML::ElementRenderer
  private def element(_tag_name : String | Symbol, **attributes, &) : Nil
    @buffer << "<"
    @buffer << _tag_name
    parse_attributes(attributes)
    @buffer << ">"
    render_block { with self yield }
    @buffer << "</"
    @buffer << _tag_name
    @buffer << ">"
  end

  private def element(_tag_name : String | Symbol, __content__ : String, **attributes) : Nil
    @buffer << "<"
    @buffer << _tag_name
    parse_attributes(attributes)
    @buffer << ">"
    ::HTML.escape(__content__, @buffer)
    @buffer << "</"
    @buffer << _tag_name
    @buffer << ">"
  end

  private def void_element(_tag_name : String | Symbol, **attributes) : Nil
    @buffer << "<"
    @buffer << _tag_name
    parse_attributes(attributes)
    @buffer << ">"
  end
end
