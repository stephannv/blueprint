module Blueprint::HTML::ElementRenderer
  private def element(tag_name : String | Symbol, **attributes, &) : Nil
    @buffer << "<"
    @buffer << tag_name
    __append_attributes__(attributes)
    @buffer << ">"
    capture_content { yield }
    @buffer << "</"
    @buffer << tag_name
    @buffer << ">"
  end

  private def element(tag_name : String | Symbol, __content__, **attributes) : Nil
    @buffer << "<"
    @buffer << tag_name
    __append_attributes__(attributes)
    @buffer << ">"
    append_to_buffer(__content__)
    @buffer << "</"
    @buffer << tag_name
    @buffer << ">"
  end

  private def void_element(tag_name : String | Symbol, **attributes) : Nil
    @buffer << "<"
    @buffer << tag_name
    __append_attributes__(attributes)
    @buffer << ">"
  end
end
