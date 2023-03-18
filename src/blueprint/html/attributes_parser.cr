module Blueprint::HTML::AttributesParser
  private def parse_attributes(attributes : NamedTuple) : String
    String.build do |io|
      attributes.each do |name, value|
        if value.is_a?(NamedTuple) && (name == :data || name == :aria)
          parse_special_attribute(io, name, value)
        else
          io << " " << parse_attribute_name(name) << "=\"" << value << "\""
        end
      end
    end
  end

  private def parse_special_attribute(io, base_name, attributes : NamedTuple)
    attributes.each do |name, value|
      io << " " << base_name << "-" << parse_attribute_name(name) << "=\"" << value << "\""
    end
  end

  private def parse_attribute_name(name)
    name.to_s.gsub("_", "-")
  end
end
