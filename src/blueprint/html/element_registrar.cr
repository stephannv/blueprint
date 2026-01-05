module Blueprint::HTML::ElementRegistrar
  macro register_element(method_name, tag = nil)
    {% tag ||= method_name.tr("_", "-") %}

    def {{method_name.id}}(**attributes, &block) : Nil
      {{method_name.id}}(attributes) { yield }
    end

    def {{method_name.id}}(**attributes) : Nil
      {{method_name.id}}(attributes)
    end

    def {{method_name.id}}(attributes : NamedTuple | Hash, &block) : Nil
      buffer << "<{{tag.id}}"
      render_attributes(attributes, to: buffer)
      buffer << ">"
      BufferRenderer.render(to: buffer) { yield }
      buffer << "</{{tag.id}}>"
    end

    def {{method_name.id}}(attributes : NamedTuple | Hash) : Nil
      buffer << "<{{tag.id}}"
      render_attributes(attributes, to: buffer)
      buffer << "></{{tag.id}}>"
    end
  end

  macro register_empty_element(method_name, tag = nil)
    {% tag ||= method_name.tr("_", "-") %}

    def {{method_name.id}}(**attributes) : Nil
      {{method_name.id}}(attributes)
    end

    def {{method_name.id}}(attributes : NamedTuple | Hash) : Nil
      buffer << "<{{tag.id}}"
      render_attributes(attributes, to: buffer)
      buffer << "></{{tag.id}}>"
    end
  end

  macro register_void_element(method_name, tag = nil)
    {% tag ||= method_name.tr("_", "-") %}

    def {{method_name.id}}(**attributes) : Nil
      {{method_name.id}}(attributes)
    end

    def {{method_name.id}}(attributes : NamedTuple | Hash) : Nil
      buffer << "<{{tag.id}}"
      render_attributes(attributes, to: buffer)
      buffer << ">"
    end
  end
end
