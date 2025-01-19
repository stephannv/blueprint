module Blueprint::HTML::OutputHelpers
  private def plain(content : String) : Nil
    __append_to_buffer__(content)
  end

  private def doctype : Nil
    @buffer << "<!DOCTYPE html>"
  end

  private def comment(content) : Nil
    @buffer << "<!--"
    __append_to_buffer__(content)
    @buffer << "-->"
  end

  private def whitespace : Nil
    @buffer << " "
  end

  private def raw(content : SafeObject) : Nil
    __append_to_buffer__(content)
  end
end
