module Blueprint::HTML::BaseTags
  private def tag(name : Symbol, **attributes, &block)
    @buffer << "<" << name << ">"
    capture_content { with self yield }
    @buffer << "</" << name << ">"
  end

  private def empty_tag(name : Symbol, **attributes)
    @buffer << "<" << name << "></" << name << ">"
  end

  private def void_tag(name : Symbol, **attributes)
    @buffer << "<" << name << "/>"
  end

  private def capture_content(&block)
    length_before = @buffer.size
    content = with self yield
    @buffer << content if length_before == @buffer.size
  end

  macro define_tags(names)
    {% for name, index in names %}
      def {{name.id}}(**attributes, &block)
        tag({{name}}, **attributes) do
          with self yield
        end
      end
    {% end %}
  end

  macro define_empty_tags(names)
    {% for name, index in names %}
      def {{name.id}}(**attributes)
        empty_tag({{name}}, **attributes)
      end
    {% end %}
  end

  macro define_void_tags(names)
    {% for name, index in names %}
      def {{name.id}}(**attributes)
        void_tag({{name}}, **attributes)
      end
    {% end %}
  end

  define_tags %i[
    a abbr address area article aside audio b bdi bdo blockquote body button canvas caption cite code colgroup data
    datalist dd del details dfn dialog div dl dt em fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6 head
    header hgroup html i ins kbd label legend li main map mark menu meter nav noscript object ol optgroup option
    output p picture pre progress q rp rt ruby s samp script section select slot small span strong style sub summary
    sup table tbody td template textarea tfoot th thead time title tr u ul var video
  ]
  define_empty_tags %i[iframe portal]
  define_void_tags %i[base br col embed hr img input link meta source track wbr]
end
