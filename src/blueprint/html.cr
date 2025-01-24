require "html"

require "./html/*"

require "./safe_object"
require "./safe_value"

module Blueprint::HTML
  include Blueprint::HTML::ElementRegistrar
  include Blueprint::HTML::OutputHelpers
  include Blueprint::HTML::StandardElements
  include Blueprint::HTML::ValueHelpers

  @buffer : String::Builder = String::Builder.new

  def self.build(&) : String
    Builder.build { |builder| with builder yield }
  end

  def to_s : String
    to_s(@buffer)

    @buffer.to_s
  end

  def to_s(&) : String
    to_s(@buffer) { yield self }

    @buffer.to_s
  end

  def to_s(buffer : String::Builder) : Nil
    return unless render?

    @buffer = buffer

    around_render { blueprint }
  end

  def to_s(buffer : String::Builder, &) : Nil
    return unless render?

    @buffer = buffer

    around_render do
      blueprint { BufferRenderer.render(to: @buffer) { yield } }
    end
  end

  def render? : Bool
    true
  end

  def around_render(&) : Nil
    yield
  end

  def element(tag_name : String | Symbol, **attributes, &) : Nil
    @buffer << "<"
    @buffer << tag_name
    AttributesRenderer.render(attributes, to: @buffer)
    @buffer << ">"
    BufferRenderer.render(to: @buffer) { yield }
    @buffer << "</"
    @buffer << tag_name
    @buffer << ">"
  end

  def void_element(tag_name : String | Symbol, **attributes) : Nil
    @buffer << "<"
    @buffer << tag_name
    AttributesRenderer.render(attributes, to: @buffer)
    @buffer << ">"
  end

  def render(renderable : Blueprint::HTML) : Nil
    renderable.to_s(@buffer)
  end

  def render(renderable : Blueprint::HTML.class) : Nil
    renderable.new.to_s(@buffer)
  end

  def render(renderable : Blueprint::HTML, &) : Nil
    renderable.to_s(@buffer) do
      yield renderable
    end
  end

  def render(renderable : Blueprint::HTML.class, &) : Nil
    renderable.new.to_s(@buffer) do
      yield renderable
    end
  end

  def render(renderable) : Nil
    BufferRenderer.render(renderable, to: @buffer)
  end

  private def svg(**attributes) : Nil
    svg(**attributes) { }
  end

  private def svg(**attributes, &) : Nil
    render SVG.new(**attributes) do |svg|
      with svg yield
    end
  end
end
