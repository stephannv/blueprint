module Blueprint::HTML::ElementRegistrar
  macro register_element(method_name, tag = nil)
    {% tag ||= method_name.tr("_", "-") %}

    private def {{method_name.id}}(**attributes, &block) : Nil
      @buffer << "<{{tag.id}}"
      AttributesRenderer.render(@buffer, attributes)
      @buffer << ">"
      BufferRenderer.render(to: @buffer) { yield }
      @buffer << "</{{tag.id}}>"
    end

    private def {{method_name.id}}(**attributes) : Nil
      @buffer << "<{{tag.id}}"
      AttributesRenderer.render(@buffer, attributes)
      @buffer << "></{{tag.id}}>"
    end
  end

  macro register_empty_element(method_name, tag = nil)
    {% tag ||= method_name.tr("_", "-") %}

    private def {{method_name.id}}(**attributes) : Nil
      @buffer << "<{{tag.id}}"
      AttributesRenderer.render(@buffer, attributes)
      @buffer << "></{{tag.id}}>"
    end
  end

  macro register_void_element(method_name, tag = nil)
    {% tag ||= method_name.tr("_", "-") %}

    private def {{method_name.id}}(**attributes) : Nil
      @buffer << "<{{tag.id}}"
      AttributesRenderer.render(@buffer, attributes)
      @buffer << ">"
    end
  end
end
