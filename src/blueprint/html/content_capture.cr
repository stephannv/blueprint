module Blueprint::HTML::ContentCapture
  private def capture_content(&block)
    length_before = @buffer.size
    content = with self yield
    ::HTML.escape(content.to_s, @buffer) if length_before == @buffer.size
  end
end
