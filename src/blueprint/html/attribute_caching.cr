@[Experimental]
module Blueprint::HTML::AttributeCaching
  private CACHE = {} of UInt64 => String

  private def __append_attributes__(attributes : NamedTuple) : Nil
    return if attributes.empty?

    attributes_hash : UInt64 = attributes.hash

    if cached_attributes = CACHE[attributes_hash]?
      @buffer << cached_attributes
    else
      new_buffer = String::Builder.new
      buffering_to(new_buffer) { super }
      @buffer << (CACHE[attributes_hash] = new_buffer.to_s)
    end
  end
end
