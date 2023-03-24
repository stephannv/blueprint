module Blueprint::HTML::BaseElements
  private def element(_name : Symbol, **attributes, &block)
    @buffer << "<" << _name << parse_attributes(attributes) << ">"
    capture_content { with self yield }
    @buffer << "</" << _name << ">"
  end

  private def void_element(_name : Symbol, **attributes)
    @buffer << "<" << _name << parse_attributes(attributes) << ">"
  end

  macro define_normal_elements(names)
    {% for name, index in names %}
      def {{name.id}}(**attributes, &block)
        element({{name}}, **attributes) do
          with self yield
        end
      end

      def {{name.id}}(**attributes)
        element({{name}}, **attributes) { "" }
      end
    {% end %}
  end

  macro define_empty_elements(names)
    {% for name, index in names %}
      def {{name.id}}(**attributes)
        element({{name}}, **attributes) { "" }
      end
    {% end %}
  end

  macro define_void_elements(names)
    {% for name, index in names %}
      def {{name.id}}(**attributes)
        void_element({{name}}, **attributes)
      end
    {% end %}
  end

  define_normal_elements %i[
    a abbr address article aside audio b bdi bdo blockquote body button canvas caption cite code colgroup data
    datalist dd del details dfn dialog div dl dt em fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6 head
    header hgroup html i ins kbd label legend li main map mark menu meter nav noscript object ol optgroup option
    output p picture pre progress q rp rt ruby s samp script section select slot small span strong style sub summary
    sup table tbody td template textarea tfoot th thead time title tr u ul var video
  ]
  define_void_elements %i[area base br col embed hr img input link meta source track wbr]
  define_empty_elements %i[iframe portal]
end
