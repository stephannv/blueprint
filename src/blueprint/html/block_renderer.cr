module Blueprint::HTML::BlockRenderer
  private def capture_content(&) : Nil
    buffer_size_before_block_evaluation = @buffer.bytesize
    content = yield
    return if buffer_size_before_block_evaluation != @buffer.bytesize # return if something was written to buffer

    append_to_buffer(content)
  end
end
