module Blueprint::HTML::OutputHelpers
  private def plain(content : String) : Nil
    BufferRenderer.render(content, to: @buffer)
  end

  private def doctype : Nil
    @buffer << "<!DOCTYPE html>"
  end

  private def comment(content) : Nil
    @buffer << "<!--"
    BufferRenderer.render(content, to: @buffer)
    @buffer << "-->"
  end

  private def whitespace : Nil
    @buffer << " "
  end

  private def raw(content : SafeObject) : Nil
    BufferRenderer.render(content, to: @buffer)
  end
end
