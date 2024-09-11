require "spec"
require "../src/blueprint/html"

def normalize_html(html : String) : String
  html.strip.gsub(/\R\s+/, "")
end
