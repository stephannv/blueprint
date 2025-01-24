module Blueprint::HTML::BufferRenderer
  extend self

  def render(content : String, to buffer : String::Builder)
    ::HTML.escape(content, buffer)
  end

  def render(content : Proc, to buffer : String::Builder)
    BlockRenderer.render(content, to: buffer)
  end

  def render(content : SafeObject, to buffer : String::Builder)
    content.to_s(buffer)
  end

  def render(content : Nil, to buffer : String::Builder)
  end

  def render(content, to buffer : String::Builder)
    ::HTML.escape(content.to_s, buffer)
  end

  def render(to buffer : String::Builder, &) : Nil
    buffer_size_before_block_evaluation = buffer.bytesize
    content = yield
    return if buffer_size_before_block_evaluation != buffer.bytesize # return if something was written to buffer

    render(content, to: buffer)
  end

  def render(block : Proc, to buffer : String::Builder) : Nil
    buffer_size_before_block_evaluation = buffer.bytesize
    content = block.call
    return if buffer_size_before_block_evaluation != buffer.bytesize # return if something was written to buffer

    render(content, to: buffer)
  end
end
