module Blueprint::HTML::ComponentRegistrar
  macro register_component(helper_method, component_class, block = true)
    {% if block %}
      private def {{helper_method.id}}(**args, &block) : Nil
        render {{component_class}}.new(**args) do |component|
          yield component
        end
      end

      {% if block == :optional %}
        private def {{helper_method.id}}(**args) : Nil
          render({{component_class}}.new(**args)) { nil }
        end
      {% end %}
    {% else %}
      private def {{helper_method.id}}(**args) : Nil
        render {{component_class}}.new(**args)
      end
    {% end %}
  end
end
