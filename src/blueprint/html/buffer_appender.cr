module Blueprint::HTML::BufferAppender
  private def append_to_buffer(content : String)
    ::HTML.escape(content, @buffer)
  end

  private def append_to_buffer(content : SafeObject)
    content.to_s(@buffer)
  end

  private def append_to_buffer(content : Nil)
  end

  private def append_to_buffer(content)
    ::HTML.escape(content.to_s, @buffer)
  end
end
