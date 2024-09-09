module Blueprint::HTML
  macro register_element(method_name, tag = nil)
    {% tag ||= method_name.tr("_", "-") %}

    private def {{method_name.id}}(**attributes, &block) : Nil
      element({{tag}}, **attributes) { with self yield }
    end

    private def {{method_name.id}}(**attributes) : Nil
      element({{tag}}, "", **attributes)
    end

    private def {{method_name.id}}(__content__ : String, **attributes) : Nil
      element({{tag}}, __content__, **attributes)
    end
  end

  macro register_empty_element(method_name, tag = nil)
    {% tag ||= method_name.tr("_", "-") %}

    private def {{method_name.id}}(**attributes) : Nil
      element({{tag}}, "", **attributes)
    end
  end

  macro register_void_element(method_name, tag = nil)
    {% tag ||= method_name.tr("_", "-") %}

    private def {{method_name.id}}(**attributes) : Nil
      void_element({{tag}}, **attributes)
    end
  end

  private def element(_tag_name : String | Symbol, **attributes, &block) : Nil
    @buffer << "<"
    @buffer << _tag_name
    @buffer << parse_attributes(attributes)
    @buffer << ">"
    capture_content { with self yield }
    @buffer << "</"
    @buffer << _tag_name
    @buffer << ">"
  end

  private def element(_tag_name : String | Symbol, __content__ : String, **attributes) : Nil
    @buffer << "<"
    @buffer << _tag_name
    @buffer << parse_attributes(attributes)
    @buffer << ">"
    ::HTML.escape(__content__, @buffer)
    @buffer << "</"
    @buffer << _tag_name
    @buffer << ">"
  end

  private def void_element(_tag_name : String | Symbol, **attributes) : Nil
    @buffer << "<"
    @buffer << _tag_name
    @buffer << parse_attributes(attributes)
    @buffer << ">"
  end
end
