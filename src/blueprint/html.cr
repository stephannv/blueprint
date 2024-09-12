require "html"

require "./html/attributes_handler"
require "./html/block_renderer"
require "./html/builder"
require "./html/component_renderer"
require "./html/element_registrar"
require "./html/element_renderer"
require "./html/helpers"
require "./html/renderer"
require "./html/standard_elements"
require "./html/svg"
require "./html/utils"

module Blueprint::HTML
  include Blueprint::HTML::AttributesHandler
  include Blueprint::HTML::BlockRenderer
  include Blueprint::HTML::ComponentRenderer
  include Blueprint::HTML::ElementRegistrar
  include Blueprint::HTML::ElementRenderer
  include Blueprint::HTML::Helpers
  include Blueprint::HTML::Renderer
  include Blueprint::HTML::StandardElements
  include Blueprint::HTML::SVG
  include Blueprint::HTML::Utils

  @buffer : String::Builder = String::Builder.new

  def to_html : String
    render_to(@buffer)

    @buffer.to_s
  end

  def to_html(&) : String
    render_to(@buffer) { yield }

    @buffer.to_s
  end

  private def envelope(&) : Nil
    yield
  end
end
