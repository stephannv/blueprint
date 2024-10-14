require "spec"
require "../src/blueprint/html"

class MarkdownLink
  def initialize(@text : String, @href : String); end

  def to_s
    "[#{@text}](#{@href})"
  end
end

def normalize_html(html : String) : String
  html.strip.gsub(/\R\s+/, "")
end
