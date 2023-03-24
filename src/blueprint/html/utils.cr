module Blueprint::HTML::Utils
  def plain(content : String) : Nil
    ::HTML.escape(content, @buffer)
  end

  def doctype
    @buffer << "<!DOCTYPE html>"
  end
end
