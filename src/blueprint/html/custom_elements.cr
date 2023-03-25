module Blueprint::HTML::CustomElements
  macro register_custom_elements(*names)
    {% for name in names %}
      def {{name.id}}(**attributes, &block)
        element({{name.tr("_", "-")}}, **attributes) do
          with self yield
        end
      end

      def {{name.id}}(**attributes)
        element({{name.tr("_", "-")}}, **attributes) { "" }
      end
    {% end %}
  end
end
