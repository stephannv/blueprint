module Blueprint::HTML::BlockRenderer
  private def capture_content(&) : Nil
    buffer_size_before_block_evaluation = @buffer.bytesize
    content = yield
    if buffer_size_before_block_evaluation == @buffer.bytesize
      ::HTML.escape(content.to_s, @buffer)
    end
  end
end
