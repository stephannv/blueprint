module Blueprint::HTML::ElementRenderer
  private def element(tag_name : String | Symbol, **attributes, &) : Nil
    @buffer << "<"
    @buffer << tag_name
    __append_attributes__(attributes)
    @buffer << ">"
    __capture_content__ { yield }
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
