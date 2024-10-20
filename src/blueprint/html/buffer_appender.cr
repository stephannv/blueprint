module Blueprint::HTML::BufferAppender
  private def __append_to_buffer__(content : String)
    __escape__(content, @buffer)
  end

  private def __append_to_buffer__(content : Proc)
    __capture_content__(content)
  end

  private def __append_to_buffer__(content : SafeObject)
    content.to_s(@buffer)
  end

  private def __append_to_buffer__(content : Nil)
  end

  private def __append_to_buffer__(content)
    __escape__(content.to_s, @buffer)
  end

  private def __escape__(value : String, io : IO)
    ::HTML.escape(value, io)
  end
end
