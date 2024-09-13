module Blueprint::HTML::Utils
  private def plain(content : String) : Nil
    ::HTML.escape(content, @buffer)
  end

  private def doctype : Nil
    @buffer << "<!DOCTYPE html>"
  end

  private def comment(content : String) : Nil
    @buffer << "<!--"
    ::HTML.escape(content, @buffer)
    @buffer << "-->"
  end

  private def whitespace : Nil
    @buffer << " "
  end

  def unsafe_raw(content : String) : Nil
    @buffer << content
  end
end
