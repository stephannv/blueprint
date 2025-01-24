module Blueprint::HTML::EscapeOnce
  extend self

  HTML_ESCAPE_ONCE_REGEXP = /["><']|&(?!([a-zA-Z]+|(#\d+)|(#[xX][\dA-Fa-f]+));)/

  HTML_ESCAPE = {"&": "&amp;", ">": "&gt;", "<": "&lt;", %("): "&quot;", "'": "&#39;"}

  def escape(value) : String
    value.to_s.gsub(HTML_ESCAPE_ONCE_REGEXP, HTML_ESCAPE)
  end
end
