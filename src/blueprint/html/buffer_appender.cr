module Blueprint::HTML::BufferAppender
  private def append_to_buffer(content : String)
    escape(content, @buffer)
  end

  private def append_to_buffer(content : SafeObject)
    content.to_s(@buffer)
  end

  private def append_to_buffer(content : Nil)
  end

  private def append_to_buffer(content)
    escape(content.to_s, @buffer)
  end

  private def escape(value : String, io : IO)
    ::HTML.escape(value, io)
  end
end
