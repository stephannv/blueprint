module Blueprint::HTML::AttributesHandler
  private def append_attributes(attributes : NamedTuple) : Nil
    attributes.each do |name, value|
      append_attribute(name, value)
    end
  end

  private def append_attribute(attribute_name, attribute_value) : Nil
    case attribute_value
    when Nil, false
      # does nothing
    when true
      append_boolean_attribute(attribute_name)
    when NamedTuple
      process_named_tuple_attribute(attribute_name, attribute_value)
    when Array
      append_array_attribute(attribute_name, attribute_value)
    else
      append_normal_attribute(attribute_name, attribute_value)
    end
  end

  private def append_normal_attribute(attribute_name, attribute_value) : Nil
    @buffer << " "
    @buffer << parse_attribute_name(attribute_name)
    @buffer << %(=")
    ::HTML.escape(attribute_value.to_s, @buffer)
    @buffer << %(")
  end

  private def append_boolean_attribute(attribute_name) : Nil
    @buffer << " "
    @buffer << parse_attribute_name(attribute_name)
  end

  private def append_array_attribute(attribute_name, attribute_value : Array) : Nil
    append_normal_attribute(attribute_name, attribute_value.flatten.compact.join(" "))
  end

  private def process_named_tuple_attribute(attribute_name, attribute_value : NamedTuple) : Nil
    attribute_name_prefix = parse_attribute_name(attribute_name)

    attribute_value.each do |name, value|
      append_attribute("#{attribute_name_prefix}-#{parse_attribute_name(name)}", value)
    end
  end

  private def parse_attribute_name(attribute_name) : String
    attribute_name.to_s.gsub("_", "-")
  end
end
