require "html"
require "./html/*"

module Blueprint::HTML
  include Blueprint::HTML::ElementRegistrar
  include Blueprint::HTML::StandardElements
  include Blueprint::HTML::AttributesParser
  include Blueprint::HTML::ContentCapture
  include Blueprint::HTML::Renderer
  include Blueprint::HTML::Utils

  @buffer = IO::Memory.new

  def to_html : String
    return "" unless render?

    blueprint
    @buffer.to_s
  end

  def to_html(&) : String
    return "" unless render?

    blueprint do
      capture_content { yield }
    end
    @buffer.to_s
  end

  def to_html(buffer : IO::Memory) : String
    @buffer = buffer
    to_html
  end

  def to_html(buffer : IO::Memory, &) : String
    @buffer = buffer
    to_html do
      yield
    end
  end

  def render? : Bool
    true
  end
end
