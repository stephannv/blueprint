module Blueprint::HTML::BlockRenderer
  private def render_block(&) : Nil
    buffer_size_before_block_evaluation = @buffer.bytesize
    content = with self yield
    if buffer_size_before_block_evaluation == @buffer.bytesize
      ::HTML.escape(content.to_s, @buffer)
    end
  end
end
