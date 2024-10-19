module Blueprint::HTML::AttributesHandler
  private def __append_attributes__(attributes : NamedTuple) : Nil
    attributes.each { |name, value| __append_attribute__(name, value) }
  end

  # Do nothing
  private def __append_attribute__(name, value : Nil) : Nil
  end

  # Append boolean attribute when it's true or do nothing when it's false
  private def __append_attribute__(name, value : Bool) : Nil
    return unless value

    @buffer << " "
    @buffer << __parse_attribute_name__(name)
  end

  # Expand NamedTuple attribute using '-' as separator
  private def __append_attribute__(name, value : NamedTuple) : Nil
    name_prefix = __parse_attribute_name__(name)

    value.each do |attr_name, attr_value|
      __append_attribute__("#{name_prefix}-#{__parse_attribute_name__(attr_name)}", attr_value)
    end
  end

  # Flatten, compact and join array attribute
  private def __append_attribute__(name, value : Array) : Nil
    __append_attribute__(name, value.flatten.compact.join(" "))
  end

  # Append attribute escaping its value if it's not a safe object
  private def __append_attribute__(name, value) : Nil
    @buffer << " "
    @buffer << __parse_attribute_name__(name)
    @buffer << %(=")
    __append_attribute_value__(value)
    @buffer << %(")
  end

  private def __append_attribute_value__(value : String) : Nil
    @buffer << value.gsub('"', "&quot;")
  end

  private def __append_attribute_value__(value : SafeObject) : Nil
    value.to_s @buffer
  end

  private def __append_attribute_value__(value : Number) : Nil
    value.to_s @buffer
  end

  private def __append_attribute_value__(value) : Nil
    __append_attribute_value__ value.to_s
  end

  private def __parse_attribute_name__(name) : String
    name.to_s.gsub("_", "-")
  end
end
