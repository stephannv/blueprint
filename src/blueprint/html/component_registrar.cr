module Blueprint::HTML::ComponentRegistrar
  macro register_component(helper_method, component_class, block = true)
    {% if block %}
      private def {{helper_method.id}}(*args, **kwargs, &) : Nil
        render {{component_class}}.new(*args, **kwargs) do |component|
          yield component
        end
      end

      {% if block == :optional %}
        private def {{helper_method.id}}(*args, **kwargs) : Nil
          render({{component_class}}.new(*args, **kwargs)) {}
        end
      {% end %}
    {% else %}
      private def {{helper_method.id}}(*args, **kwargs) : Nil
        render {{component_class}}.new(*args, **kwargs)
      end
    {% end %}
  end
end
