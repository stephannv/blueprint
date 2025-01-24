module Blueprint::HTML::ElementRegistrar
  macro register_element(method_name, tag = nil)
    {% tag ||= method_name.tr("_", "-") %}

    def {{method_name.id}}(**attributes, &block) : Nil
      @buffer << "<{{tag.id}}"
      AttributesRenderer.render(attributes, to: @buffer)
      @buffer << ">"
      BufferRenderer.render(to: @buffer) { yield }
      @buffer << "</{{tag.id}}>"
    end

    def {{method_name.id}}(**attributes) : Nil
      @buffer << "<{{tag.id}}"
      AttributesRenderer.render(attributes, to: @buffer)
      @buffer << "></{{tag.id}}>"
    end
  end

  macro register_empty_element(method_name, tag = nil)
    {% tag ||= method_name.tr("_", "-") %}

    def {{method_name.id}}(**attributes) : Nil
      @buffer << "<{{tag.id}}"
      AttributesRenderer.render(attributes, to: @buffer)
      @buffer << "></{{tag.id}}>"
    end
  end

  macro register_void_element(method_name, tag = nil)
    {% tag ||= method_name.tr("_", "-") %}

    def {{method_name.id}}(**attributes) : Nil
      @buffer << "<{{tag.id}}"
      AttributesRenderer.render(attributes, to: @buffer)
      @buffer << ">"
    end
  end
end
