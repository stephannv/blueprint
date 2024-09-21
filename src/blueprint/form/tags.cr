require "../html"

module Blueprint::Form::Tags
  include Blueprint::HTML

  def label(attribute : Symbol, value = nil, **html_options, &) : Nil
    super(**{for: input_id(attribute, value)}.merge(html_options)) do
      yield
    end
  end

  def label(attribute : Symbol, text : String? = nil, value = nil, **html_options) : Nil
    label(attribute, value, **html_options) { text || attribute.to_s.capitalize }
  end

  {% for type in %i[color date datetime datetime_local email file hidden month number password range search tel text time url week] %}
    def {{type.id}}_input(attribute : Symbol, **html_options) : Nil
      input **default_input_options("{{type.tr("_", "-").id}}", attribute).merge(html_options)
    end
  {% end %}

  def checkbox_input(attribute : Symbol, checked_value = "1", unchecked_value = "0", **html_options) : Nil
    hidden_input(attribute, id: nil, value: unchecked_value) if unchecked_value

    input(**default_input_options("checkbox", attribute, value: checked_value).merge(html_options))
  end

  def radio_input(attribute : Symbol, value, **html_options) : Nil
    input **{type: safe("radio"), id: input_id(attribute, value), name: input_name(attribute), value: value}
      .merge(html_options)
  end

  def range_input(attribute : Symbol, range : Range, **html_options)
    range_input(attribute, **html_options.merge(min: range.begin, max: range.end))
  end

  def reset(value = safe("Reset"), **html_options) : Nil
    input(**{type: safe("reset"), value: value}.merge(html_options))
  end

  def submit(value = safe("Submit"), **html_options) : Nil
    input(**{type: safe("submit"), value: value}.merge(html_options))
  end

  def input_id(attribute : Symbol, value = nil)
    String.build do |io|
      if @scope != :""
        io << @scope << "_"
      end

      io << attribute

      if value
        io << "_" << value
      end
    end
  end

  def input_name(attribute : Symbol)
    if @scope == :""
      attribute
    else
      String.build { |io| io << @scope << "[" << attribute << "]" }
    end
  end

  private def default_input_options(type : String, attribute : Symbol, **options) : NamedTuple
    {type: safe(type), id: input_id(attribute), name: input_name(attribute)}.merge(options)
  end
end
