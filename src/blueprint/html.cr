require "html"

require "./html/attributes_handler"
require "./html/block_renderer"
require "./html/builder"
require "./html/component_renderer"
require "./html/element_registrar"
require "./html/element_renderer"
require "./html/helpers"
require "./html/standard_elements"
require "./html/style_builder"
require "./html/svg"
require "./html/utils"

module Blueprint::HTML
  include Blueprint::HTML::AttributesHandler
  include Blueprint::HTML::BlockRenderer
  include Blueprint::HTML::ComponentRenderer
  include Blueprint::HTML::ElementRegistrar
  include Blueprint::HTML::ElementRenderer
  include Blueprint::HTML::Helpers
  include Blueprint::HTML::StandardElements
  include Blueprint::HTML::StyleBuilder
  include Blueprint::HTML::SVG
  include Blueprint::HTML::Utils

  @buffer : String::Builder = String::Builder.new

  def to_s : String
    to_s(@buffer)

    @buffer.to_s
  end

  def to_s(&) : String
    to_s(@buffer) { yield }

    @buffer.to_s
  end

  def to_s(buffer : String::Builder) : Nil
    return unless render?

    @buffer = buffer

    envelope { blueprint }
  end

  def to_s(buffer : String::Builder, &) : Nil
    return unless render?

    @buffer = buffer

    envelope do
      blueprint { capture_content { yield } }
    end
  end

  private def render? : Bool
    true
  end

  private def envelope(&) : Nil
    yield
  end
end
