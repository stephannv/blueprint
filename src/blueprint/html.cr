require "html"

require "./html/attributes_parser"
require "./html/content_capture"
require "./html/element_registrar"
require "./html/renderer"
require "./html/standard_elements"
require "./html/utils"

module Blueprint::HTML
  @buffer = IO::Memory.new

  def to_html : String
    return "" unless render?

    blueprint
    @buffer.to_s
  end

  def to_html(&) : String
    return "" unless render?

    blueprint { capture_content { yield } }
    @buffer.to_s
  end

  private def render? : Bool
    true
  end
end
