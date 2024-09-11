require "html"

require "./html"

module Blueprint::RawHTML
  include Blueprint::HTML

  private def append_attribute(attribute_name, attribute_value) : Nil
    @buffer << " "
    @buffer << attribute_name.to_s
    @buffer << %(=")
    @buffer << attribute_value.to_s
    @buffer << %(")
  end

  private def capture_content(&) : Nil
    buffer_size_before_block_evaluation = @buffer.bytesize
    content = yield
    @buffer << content if buffer_size_before_block_evaluation == @buffer.bytesize
  end

  private def element(_tag_name : String | Symbol, __content__ : String, **attributes) : Nil
    @buffer << "<"
    @buffer << _tag_name
    append_attributes(attributes)
    @buffer << ">"
    @buffer << __content__
    @buffer << "</"
    @buffer << _tag_name
    @buffer << ">"
  end

  private def plain(content : String) : Nil
    @buffer << content
  end

  private def comment(&) : Nil
    @buffer << "<!--"
    @buffer << yield
    @buffer << "-->"
  end
end
