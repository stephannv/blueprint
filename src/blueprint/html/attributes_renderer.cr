module Blueprint::HTML::AttributesRenderer
  extend self

  private CACHE       = {} of UInt64 => String
  private CACHE_MUTEX = Mutex.new

  def render(attributes : NamedTuple | Hash, to buffer : String::Builder) : Nil
    return if attributes.empty?

    attributes_hash : UInt64 = attributes.hash

    lock_cache do
      if cached_attributes = CACHE[attributes_hash]?
        buffer << cached_attributes
      else
        tmp_buffer = String::Builder.new

        attributes.each { |name, value| append_attribute(tmp_buffer, name, value) }

        buffer << (CACHE[attributes_hash] = tmp_buffer.to_s)
      end
    end
  end

  def lock_cache(&)
    {% if flag?(:preview_mt) %}
      CACHE_MUTEX.synchronize { yield }
    {% else %}
      yield
    {% end %}
  end

  private def append_attribute(buffer : String::Builder, name, value : Nil) : Nil
  end

  private def append_attribute(buffer : String::Builder, name, value : Bool) : Nil
    return unless value

    buffer << " "
    buffer << parse_name(name)
  end

  private def append_attribute(buffer : String::Builder, name, value : NamedTuple | Hash) : Nil
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

  private def parse_name(name : String) : String
    if name.matches?(/[<>&"']/)
      raise Blueprint::HTML::ArgumentError.new("Unsafe attribute name: `#{name}`")
    end

    name
  end

  private def parse_name(name : Symbol) : String
    parse_name(name.to_s.gsub("_", "-"))
  end
end
