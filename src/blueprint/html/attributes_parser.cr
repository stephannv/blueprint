module Blueprint::HTML
  private def parse_attributes(attributes : NamedTuple) : String
    String.build do |io|
      attributes.each do |name, value|
        append_attribute(io, name, value)
      end
    end
  end

  private def append_attribute(io : String::Builder, attribute_name, attribute_value) : Nil
    case attribute_value
    when Nil, false
      # does nothing
    when true
      append_boolean_attribute(io, attribute_name)
    when NamedTuple
      process_named_tuple_attribute(io, attribute_name, attribute_value)
    when Array
      append_array_attribute(io, attribute_name, attribute_value)
    else
      append_normal_attribute(io, attribute_name, attribute_value)
    end
  end

  private def append_normal_attribute(io : String::Builder, attribute_name, attribute_value) : Nil
    io << " "
    io << parse_attribute_name(attribute_name)
    io << %(=")
    ::HTML.escape(attribute_value.to_s, io)
    io << %(")
  end

  private def append_boolean_attribute(io : String::Builder, attribute_name) : Nil
    io << " "
    io << parse_attribute_name(attribute_name)
  end

  private def append_array_attribute(io : String::Builder, attribute_name, attribute_value : Array) : Nil
    append_normal_attribute(io, attribute_name, attribute_value.flatten.compact.join(" "))
  end

  private def process_named_tuple_attribute(io : String::Builder, attribute_name, attribute_value : NamedTuple) : Nil
    attribute_name_prefix = parse_attribute_name(attribute_name)

    attribute_value.each do |name, value|
      append_attribute(io, "#{attribute_name_prefix}-#{parse_attribute_name(name)}", value)
    end
  end

  private def parse_attribute_name(attribute_name) : String
    attribute_name.to_s.gsub("_", "-")
  end
end
