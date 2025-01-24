module Blueprint::HTML::AttributesRenderer
  extend self

  def render(buffer : String::Builder, attributes : NamedTuple) : Nil
    attributes.each { |name, value| append_attribute(buffer, name, value) }
  end

  private def append_attribute(buffer : String::Builder, name, value : Nil) : Nil
  end

  private def append_attribute(buffer : String::Builder, name, value : Bool) : Nil
    return unless value

    buffer << " "
    buffer << parse_name(name)
  end

  private def append_attribute(buffer : String::Builder, name, value : NamedTuple) : Nil
    name_prefix = parse_name(name)

    value.each do |attr_name, attr_value|
      append_attribute(buffer, "#{name_prefix}-#{parse_name(attr_name)}", attr_value)
    end
  end

  private def append_attribute(buffer : String::Builder, name, value : Array) : Nil
    append_attribute(buffer, name, value.flatten.compact.join(" "))
  end

  private def append_attribute(buffer : String::Builder, name, value) : Nil
    buffer << " "
    buffer << parse_name(name)
    buffer << %(=")
    append_value(buffer, value)
    buffer << %(")
  end

  private def append_value(buffer : String::Builder, value : String) : Nil
    buffer << value.gsub('"', "&quot;")
  end

  private def append_value(buffer : String::Builder, value : SafeObject) : Nil
    value.to_s buffer
  end

  private def append_value(buffer : String::Builder, value : Number) : Nil
    value.to_s buffer
  end

  private def append_value(buffer : String::Builder, value) : Nil
    append_value buffer, value.to_s
  end

  private def parse_name(name) : String
    name.to_s.gsub("_", "-")
  end
end
