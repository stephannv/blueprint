module Blueprint::HTML::Helpers
  HTML_ESCAPE_ONCE_REGEXP = /["><']|&(?!([a-zA-Z]+|(#\d+)|(#[xX][\dA-Fa-f]+));)/

  HTML_ESCAPE = {"&": "&amp;", ">": "&gt;", "<": "&lt;", %("): "&quot;", "'": "&#39;"}

  private def safe(value) : SafeValue
    Blueprint::SafeValue.new(value)
  end

  private def escape_once(value : String) : SafeValue
    safe value.gsub(HTML_ESCAPE_ONCE_REGEXP, HTML_ESCAPE)
  end

  private def escape_once(value) : SafeValue
    escape_once(value.to_s)
  end

  @[Experimental]
  macro tokens(**conditions)
    String.build do |io|
      {% for key, value in conditions %}
        if {{key.id}}
          io << " " unless io.empty?
          io << {{value}}
        end
      {% end %}
    end
  end
end
