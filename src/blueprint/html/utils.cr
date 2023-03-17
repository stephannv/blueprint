module Blueprint::HTML::Utils
  def plain(content : String) : Nil
    @buffer << content
  end
end
