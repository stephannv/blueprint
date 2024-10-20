module Blueprint::HTML::BlockRenderer
  private def __capture_content__(&) : Nil
    buffer_size_before_block_evaluation = @buffer.bytesize
    content = yield
    return if buffer_size_before_block_evaluation != @buffer.bytesize # return if something was written to buffer

    __append_to_buffer__(content)
  end

  private def __capture_content__(block : Proc) : Nil
    buffer_size_before_block_evaluation = @buffer.bytesize
    content = block.call
    return if buffer_size_before_block_evaluation != @buffer.bytesize # return if something was written to buffer

    __append_to_buffer__(content)
  end
end
