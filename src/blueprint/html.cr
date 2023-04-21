require "html"

require "./html/attributes_parser"
require "./html/builder"
require "./html/content_capture"
require "./html/element_registrar"
require "./html/renderer"
require "./html/standard_elements"
require "./html/svg"
require "./html/utils"

module Blueprint::HTML
  @buffer = IO::Memory.new

  def to_html : String
    return "" unless render?

    envelope { blueprint }

    @buffer.to_s
  end

  def to_html(&) : String
    return "" unless render?

    envelope do
      blueprint { capture_content { yield } }
    end

    @buffer.to_s
  end

  private def render? : Bool
    true
  end

  private def envelope(&) : Nil
    yield
  end
end
