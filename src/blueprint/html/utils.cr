module Blueprint::HTML::Utils
  def plain(content : String) : Nil
    @buffer << content
  end

  def doctype
    @buffer << "<!DOCTYPE html>"
  end
end
