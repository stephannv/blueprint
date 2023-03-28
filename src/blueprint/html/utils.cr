module Blueprint::HTML::Utils
  def plain(content : String) : Nil
    ::HTML.escape(content, @buffer)
  end

  def doctype
    @buffer << "<!DOCTYPE html>"
  end

  def comment(&)
    @buffer << "<!--"
    ::HTML.escape(yield, @buffer)
    @buffer << "-->"
  end

  def whitespace
    @buffer << " "
  end
end
