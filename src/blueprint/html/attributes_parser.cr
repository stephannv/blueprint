module Blueprint::HTML::AttributesParser
  private def parse_attributes(attributes : NamedTuple) : String
    String.build do |io|
      attributes.each do |name, value|
        if name == :data && value.is_a?(NamedTuple)
          parse_data_attributes(io, value)
        else
          io << " " << name << "=\"" << value << "\""
        end
      end
    end
  end

  private def parse_data_attributes(io, attributes)
    attributes.each do |name, value|
      io << " " << "data-" << name << "=\"" << value << "\""
    end
  end
end
