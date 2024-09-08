module Blueprint::HTML
  private def capture_content(&) : Nil
    buffer_size_before_block_evaluation = @buffer.bytesize
    content = with self yield
    if buffer_size_before_block_evaluation == @buffer.bytesize
      ::HTML.escape(content.to_s, @buffer)
    end
  end
end
