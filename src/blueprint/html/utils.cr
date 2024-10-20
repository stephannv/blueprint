module Blueprint::HTML::Utils
  private def plain(content : String) : Nil
    append_to_buffer(content)
  end

  private def doctype : Nil
    @buffer << "<!DOCTYPE html>"
  end

  private def comment(content) : Nil
    @buffer << "<!--"
    append_to_buffer(content)
    @buffer << "-->"
  end

  private def whitespace : Nil
    @buffer << " "
  end

  private def raw(content : SafeObject) : Nil
    append_to_buffer(content)
  end
end
