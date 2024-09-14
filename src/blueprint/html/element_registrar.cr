module Blueprint::HTML::ElementRegistrar
  macro register_element(method_name, tag = nil)
    {% tag ||= method_name.tr("_", "-") %}

    private def {{method_name.id}}(**attributes, &block) : Nil
      element({{tag}}, **attributes) { yield }
    end

    private def {{method_name.id}}(**attributes) : Nil
      element({{tag}}, "", **attributes)
    end

    private def {{method_name.id}}(__content__, **attributes) : Nil
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
end
