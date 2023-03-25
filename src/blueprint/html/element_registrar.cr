module Blueprint::HTML::ElementRegistrar
  macro register_element(method_name, tag = nil)
    {% tag ||= method_name.tr("_", "-") %}

    def {{method_name.id}}(**attributes, &block)
      element({{tag}}, **attributes) do
        with self yield
      end
    end

    def {{method_name.id}}(**attributes)
      element({{tag}}, **attributes) { "" }
    end
  end

  macro register_empty_element(method_name, tag = nil)
    {% tag ||= method_name.tr("_", "-") %}

    def {{method_name.id}}(**attributes)
      element({{tag}}, **attributes) { "" }
    end
  end

  macro register_void_element(method_name, tag = nil)
    {% tag ||= method_name.tr("_", "-") %}

    def {{method_name.id}}(**attributes)
      void_element({{tag}}, **attributes)
    end
  end

  private def element(_tag_name : String | Symbol, **attributes, &block)
    @buffer << "<" << _tag_name << parse_attributes(attributes) << ">"
    capture_content { with self yield }
    @buffer << "</" << _tag_name << ">"
  end

  private def void_element(_tag_name : String | Symbol, **attributes)
    @buffer << "<" << _tag_name << parse_attributes(attributes) << ">"
  end
end
