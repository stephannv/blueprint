module Blueprint::HTML::Helpers
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
