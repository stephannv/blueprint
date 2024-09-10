module Blueprint::HTML::Utils
  private def plain(content : String) : Nil
    plain { content }
  end

  private def plain(&) : Nil
    ::HTML.escape(yield, @buffer)
  end

  private def doctype : Nil
    @buffer << "<!DOCTYPE html>"
  end

  private def comment(content : String) : Nil
    comment { content }
  end

  private def comment(&) : Nil
    @buffer << "<!--"
    ::HTML.escape(yield, @buffer)
    @buffer << "-->"
  end

  private def whitespace : Nil
    @buffer << " "
  end

  def unsafe_raw(content : String) : Nil
    unsafe_raw { content }
  end

  def unsafe_raw(&) : Nil
    @buffer << yield
  end
end
