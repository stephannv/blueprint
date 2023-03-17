module Blueprint::HTML::AttributesParser
  private def parse_attributes(attributes : NamedTuple) : String
    String.build do |io|
      attributes.each do |name, value|
        io << " " << name << "=\"" << value << "\""
      end
    end
  end
end
