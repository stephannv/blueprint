module Blueprint::HTML
  macro register_element(method_name, tag = nil)
    {% tag ||= method_name.tr("_", "-") %}

    private def {{method_name.id}}(**attributes, &block) : Nil
      element({{tag}}, **attributes) { with self yield }
    end

    private def {{method_name.id}}(**attributes) : Nil
      element({{tag}}, **attributes) { "" }
    end
  end

  macro register_empty_element(method_name, tag = nil)
    {% tag ||= method_name.tr("_", "-") %}

    private def {{method_name.id}}(**attributes) : Nil
      element({{tag}}, **attributes) { "" }
    end
  end

  macro register_void_element(method_name, tag = nil)
    {% tag ||= method_name.tr("_", "-") %}

    private def {{method_name.id}}(**attributes) : Nil
      void_element({{tag}}, **attributes)
    end
  end

  private def element(_tag_name : String | Symbol, **attributes, &block) : Nil
    @buffer << "<" << _tag_name << parse_attributes(attributes) << ">"
    capture_content { with self yield }
    @buffer << "</" << _tag_name << ">"
  end

  private def void_element(_tag_name : String | Symbol, **attributes) : Nil
    @buffer << "<" << _tag_name << parse_attributes(attributes) << ">"
  end
end
