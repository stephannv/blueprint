module Blueprint::HTML::AttributesHandler
  private def append_attributes(attributes : NamedTuple) : Nil
    attributes.each do |name, value|
      append_attribute(name, value)
    end
  end

  private def append_attribute(name, value) : Nil
    case value
    when Nil, false
      # does nothing
    when true
      append_boolean_attribute(name)
    when NamedTuple
      process_named_tuple_attribute(name, value)
    when Array
      append_array_attribute(name, value)
    else
      append_normal_attribute(name, value)
    end
  end

  private def append_boolean_attribute(name) : Nil
    @buffer << " "
    @buffer << parse_name(name)
  end

  private def append_array_attribute(name, value : Array) : Nil
    append_normal_attribute(name, value.flatten.compact.join(" "))
  end

  private def process_named_tuple_attribute(name, value : NamedTuple) : Nil
    name_prefix = parse_name(name)

    value.each do |attr_name, attr_value|
      append_attribute("#{name_prefix}-#{parse_name(attr_name)}", attr_value)
    end
  end

  private def append_normal_attribute(name, value) : Nil
    @buffer << " "
    @buffer << parse_name(name)
    @buffer << %(=")
    append_attribute_value(value)
    @buffer << %(")
  end

  private def append_attribute_value(value : String) : Nil
    @buffer << value.gsub('"', "&quot;")
  end

  private def append_attribute_value(value : SafeObject) : Nil
    value.to_s @buffer
  end

  private def append_attribute_value(value : Number) : Nil
    value.to_s @buffer
  end

  private def append_attribute_value(value) : Nil
    append_attribute_value value.to_s
  end

  private def parse_name(name) : String
    name.to_s.gsub("_", "-")
  end
end
