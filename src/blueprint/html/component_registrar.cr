module Blueprint::HTML::ComponentRegistrar
  macro register_component(helper_method, component_class, block = true)
    {% if block %}
      def {{helper_method.id}}(**args, &block)
        render {{component_class}}.new(**args) do |component|
          yield component
        end
      end

      {% if block == :optional %}
        def {{helper_method.id}}(**args)
          render({{component_class}}.new(**args)) { nil }
        end
      {% end %}
    {% else %}
      def {{helper_method.id}}(**args)
        render {{component_class}}.new(**args)
      end
    {% end %}
  end
end
